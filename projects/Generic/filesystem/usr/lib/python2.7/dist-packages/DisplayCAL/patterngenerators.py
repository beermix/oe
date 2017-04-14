# -*- coding: utf-8 -*-

from socket import (AF_INET, SHUT_RDWR, SO_BROADCAST, SO_REUSEADDR, SOCK_DGRAM,
					SOCK_STREAM, SOL_SOCKET, error, gethostname, gethostbyname,
					socket, timeout)
from time import sleep
import errno
import httplib
import struct
import threading
import urllib
import urlparse

import demjson

import localization as lang
from log import safe_print
from network import get_network_addr
from util_http import encode_multipart_formdata
from util_str import safe_unicode


_lock = threading.RLock()


def _shutdown(sock, addr):
	try:
		# Will fail if the socket isn't connected, i.e. if there
		# was an error during the call to connect()
		sock.shutdown(SHUT_RDWR)
	except error, exception:
		if exception.errno != errno.ENOTCONN:
			safe_print("MadTPG_Net: SHUT_RDWR for %s:%i failed:" %
					   addr[:2], exception)
	sock.close()


class GenHTTPPatternGeneratorClient(object):

	""" Generic pattern generator client using HTTP REST interface """

	def __init__(self, host, port, bits, use_video_levels=False,
				 logfile=None):
		self.host = host
		self.port = port
		self.bits = bits
		self.use_video_levels = use_video_levels
		self.logfile = logfile

	def wait(self):
		self.connect()

	def __del__(self):
		self.disconnect_client()

	def _conn_exc(self, exception):
		msg = lang.getstr("connection.fail", safe_unicode(exception))
		raise Exception(msg)

	def _request(self, method, url, params=None, headers=None, validate=None):
		try:
			self.conn.request(method, url, params, headers or {})
			resp = self.conn.getresponse()
		except (error, httplib.HTTPException), exception:
			self._conn_exc(exception)
		else:
			if resp.status == httplib.OK:
				return self._validate(resp, url, validate)
			else:
				raise Exception("%s %s" % (resp.status, resp.reason))

	def _shutdown(self):
		# Override this method in subclass!
		pass

	def _validate(self, resp, url, validate):
		# Override this method in subclass!
		pass

	def connect(self):
		self.ip = gethostbyname(self.host)
		self.conn = httplib.HTTPConnection(self.ip, self.port)
		self.conn.connect()

	def disconnect_client(self):
		self.listening = False
		if hasattr(self, "conn"):
			self._shutdown()
			self.conn.close()
			del self.conn

	def send(self, rgb=(0, 0, 0), bgrgb=(0, 0, 0), bits=None,
			 use_video_levels=None, x=0, y=0, w=1, h=1):
		rgb, bgrgb, bits = self._get_rgb(rgb, bgrgb, bits, use_video_levels)
		# Override this method in subclass!


class GenTCPSockPatternGeneratorServer(object):

	""" Generic pattern generator server using TCP sockets """

	def __init__(self, port, bits, use_video_levels=False, logfile=None):
		self.port = port
		self.bits = bits
		self.use_video_levels = use_video_levels
		self.socket = socket(AF_INET, SOCK_STREAM)
		self.socket.settimeout(1)
		self.socket.bind(('', port))
		self.socket.listen(1)
		self.listening = False
		self.logfile = logfile

	def wait(self):
		self.listening = True
		if self.logfile:
			try:
				host = get_network_addr()
			except error:
				host = gethostname()
			self.logfile.write(lang.getstr("connection.waiting") +
							   (" %s:%s\n" % (host, self.port)))
		while self.listening:
			try:
				self.conn, addr = self.socket.accept()
			except timeout:
				continue
			self.conn.settimeout(1)
			break
		if self.listening:
			if self.logfile:
				self.logfile.write(lang.getstr("connection.established") + "\n")

	def __del__(self):
		self.disconnect_client()
		self.socket.close()

	def _get_rgb(self, rgb, bgrgb, bits=None, use_video_levels=None):
		""" The RGB range should be 0..1 """
		if not bits:
			bits = self.bits
		if use_video_levels is None:
			use_video_levels = self.use_video_levels
		bitv = 2 ** bits - 1
		if use_video_levels:
			minv = 16.0 / 255.0
			maxv = 235.0 / 255.0 - minv
			if bits > 8:
				# For video encoding the extra bits of precision are created by
				# bit shifting rather than scaling, so we need to scale the fp
				# value to account for this.
				minv = (minv * 255.0 * (1 << (bits - 8))) / bitv
				maxv = (maxv * 255.0 * (1 << (bits - 8))) / bitv
		else:
			minv = 0.0
			maxv = 1.0
		rgb = [round(minv * bitv + v * bitv * maxv) for v in rgb]
		bgrgb = [round(minv * bitv + v * bitv * maxv) for v in bgrgb]
		return rgb, bgrgb, bits

	def disconnect_client(self):
		self.listening = False
		if hasattr(self, "conn"):
			try:
				self.conn.shutdown(SHUT_RDWR)
			except error, exception:
				if exception.errno != errno.ENOTCONN:
					safe_print("Warning - could not shutdown pattern generator "
							   "connection:", exception)
			self.conn.close()
			del self.conn

	def send(self, rgb=(0, 0, 0), bgrgb=(0, 0, 0),
			 use_video_levels=None, x=0, y=0, w=1, h=1):
		for server, bits in ((ResolveLSPatternGeneratorServer, 8),
							 (ResolveCMPatternGeneratorServer, 10)):
			server.__dict__["send"](self, rgb, bgrgb, bits, use_video_levels,
									x, y, w, h)


class PrismaPatternGeneratorClient(GenHTTPPatternGeneratorClient):

	""" Prisma HTTP REST interface """

	def __init__(self, host, port=80, use_video_levels=False, logfile=None):
		GenHTTPPatternGeneratorClient.__init__(self, host, port, 8,
											   use_video_levels=use_video_levels,
											   logfile=logfile)
		self.prod_prisma = 2
		self.oem_qinc = 1024
		self.prod_oem = (struct.pack("<I", self.prod_prisma) +
						 struct.pack("<I", self.oem_qinc))
		# UDP discovery of Prisma devices in local network
		self._cast_sockets = {}
		self._threads = []
		self.broadcast_request_port = 7737
		self.broadcast_response_port = 7747
		self.debug = 0
		self.listening = False
		self._event_handlers = {"on_client_added": []}
		self.broadcast_ip = "255.255.255.255"
		self.prismas = {}

	def listen(self):
		self.listening = True
		port = self.broadcast_response_port
		if (self.broadcast_ip, port) in self._cast_sockets:
			return
		sock = socket(AF_INET, SOCK_DGRAM)
		sock.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
		sock.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)
		sock.settimeout(0)
		try:
			sock.bind(("", port))
			thread = threading.Thread(target=self._cast_receive_handler,
									  args=(sock, self.broadcast_ip, port))
			self._threads.append(thread)
			thread.start()
		except error, exception:
			safe_print("PrismaPatternGeneratorClient: UDP Port %i: %s" %
					   (port, exception))

	def _cast_receive_handler(self, sock, host, port):
		cast = "broadcast"
		if self.debug:
			safe_print("PrismaPatternGeneratorClient: Entering receiver thread for %s port %i" %
					   (cast, port))
		self._cast_sockets[(host, port)] = sock
		while getattr(self, "listening", False):
			try:
				data, addr = sock.recvfrom(4096)
			except timeout, exception:
				safe_print("PrismaPatternGeneratorClient: In receiver thread for %s port %i:" %
						   (cast, port), exception)
				continue
			except error, exception:
				if exception.errno == errno.EWOULDBLOCK:
					sleep(.05)
					continue
				if exception.errno != errno.ECONNRESET or self.debug:
					safe_print("PrismaPatternGeneratorClient: In receiver thread for %s port %i:" %
							   (cast, port), exception)
				break
			else:
				with _lock:
					if self.debug:
						safe_print("PrismaPatternGeneratorClient: Received %s from %s:%s: %r" %
								   (cast, addr[0], addr[1], data))
					if data.startswith(self.prod_oem):
						name = data[8:32].rstrip("\0")
						serial = data[32:].rstrip("\0")
						self.prismas[addr[0]] = {"serial": serial,
												 "name": name}
						self._dispatch_event("on_client_added",
											 (addr, self.prismas[addr[0]]))
		self._cast_sockets.pop((host, port))
		_shutdown(sock, (host, port))
		if self.debug:
			safe_print("PrismaPatternGeneratorClient: Exiting %s receiver thread for port %i" %
					   (cast, port))

	def announce(self):
		""" Anounce ourselves """
		port = self.broadcast_request_port
		sock = socket(AF_INET, SOCK_DGRAM)
		sock.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)
		sock.settimeout(1)
		sock.connect((self.broadcast_ip, port))
		addr = sock.getsockname()
		if self.debug:
			safe_print("PrismaPatternGeneratorClient: Sending broadcast from %s:%s to port %i" %
					   (addr[0], addr[1], port))
		sock.sendall(self.prod_oem)
		sock.close()

	def bind(self, event_name, handler):
		""" Bind a handler to an event """
		if not event_name in self._event_handlers:
			self._event_handlers[event_name] = []
		self._event_handlers[event_name].append(handler)

	def unbind(self, event_name, handler=None):
		"""
		Unbind (remove) a handler from an event
		
		If handler is None, remove all handlers for the event.
		
		"""
		if event_name in self._event_handlers:
			if handler in self._event_handlers[event_name]:
				self._event_handlers[event_name].remove(handler)
				return handler
			else:
				return self._event_handlers.pop(event_name)

	def _dispatch_event(self, event_name, event_data=None):
		""" Dispatch events """
		if self.debug:
			safe_print("PrismaPatternGeneratorClient: Dispatching", event_name)
		for handler in self._event_handlers.get(event_name, []):
			handler(event_data)

	def _get_rgb(self, rgb, bgrgb, bits=8, use_video_levels=None):
		""" The RGB range should be 0..1 """
		_get_rgb = GenTCPSockPatternGeneratorServer.__dict__["_get_rgb"]
		rgb, bgrgb, bits = _get_rgb(self, rgb, bgrgb, 8, use_video_levels)
		# Encode RGB values for Prisma HTTP REST interface
		# See prisma-sdk/prisma.cpp, PrismaIo::wincolor
		rgb = [int(round(v)) for v in rgb]
		bgrgb = [int(round(v)) for v in bgrgb]
		rgb = ((rgb[0] & 0xff) << 16 |
			   (rgb[1] & 0xff) << 8 |
			   (rgb[2] & 0xff) << 0)
		bgrgb = ((bgrgb[0] & 0xff) << 16 |
				 (bgrgb[1] & 0xff) << 8 |
				 (bgrgb[2] & 0xff) << 0)
		return rgb, bgrgb, bits

	def invoke(self, api, method=None, params=None, validate=None):
		url = "/" + api
		if method:
			url += "?m=" + method
			if params:
				url += "&" + urllib.unquote_plus(urllib.urlencode(params))
		if not validate:
			validate = {method: "Ok"}
		return self._request("GET", url, validate=validate)

	def _shutdown(self):
		try:
			self.invoke("window", "off", {"sz": 10})
		except:
			pass

	def _validate(self, resp, url, validate):
		raw = resp.read()
		if isinstance(validate, dict):
			data = demjson.decode(raw)
			components = urlparse.urlparse(url)
			api = components.path[1:]
			query = urlparse.parse_qs(components.query)
			if "m" in query:
				method = query["m"][0]
				if data.get(method) == "Error" and "msg" in data:
					raise Exception("%s: %s" % (self.host, data["msg"]))
			for key, value in validate.iteritems():
				if key not in data:
					raise Exception(lang.getstr("response.invalid.missing_key",
												(self.host, key, raw)))
				elif value is not None and data[key] != value:
					raise Exception(lang.getstr("response.invalid.value",
												(self.host, key, value, raw)))
			data["raw"] = raw
			return data
		elif validate:
			if raw != validate:
				raise Exception(lang.getstr("response.invalid",
											(self.host, raw)))
		return raw

	def disable_processing(self, size=10):
		self.enable_processing(False, size)

	def enable_processing(self, enable=True, size=10):
		if enable:
			win = 1
		else:
			win = 2
		self.invoke("window", "win%i" % win, {"sz": size})

	def get_config(self):
		return self.invoke("setup", validate={"preset": None, "settings": None,
											  "vpath": None})

	def get_installed_3dluts(self):
		return self.invoke("cube", "list", validate={"list": "Ok", "tables": None})

	def load_preset(self, presetname):
		return self.invoke("setup", "loadPreset", {"n": presetname},
						   validate={"settings": None})

	def load_3dlut_file(self, path, filename):
		with open(path, "rb") as lut3d:
			data = lut3d.read()
		files = [("cubeFile", filename, data)]
		content_type, params = encode_multipart_formdata([], files)
		headers = {"Content-Type": content_type,
				   "Content-Length": str(len(params))}
		# Upload 3D LUT
		self._request("POST", "/fwupload", params, headers)

	def remove_3dlut(self, filename):
		self.invoke("cube", "remove", {"n": filename})

	def set_3dlut(self, filename):
		# Select 3D LUT
		self.invoke("setup", "setCube", {"n": filename, "f": "null"})

	def set_prismavue(self, value):
		self.invoke("setup", "setPrismaVue", {"a": value, "t": "null"})

	def send(self, rgb=(0, 0, 0), bgrgb=(0, 0, 0), bits=None,
			 use_video_levels=None, x=0, y=0, w=1, h=1):
		rgb, bgrgb, bits = self._get_rgb(rgb, bgrgb, bits, use_video_levels)
		self.invoke("window", "color", {"bg": bgrgb, "fg": rgb})


class ResolveLSPatternGeneratorServer(GenTCPSockPatternGeneratorServer):

	def __init__(self, port=20002, bits=8, use_video_levels=False,
				 logfile=None):
		GenTCPSockPatternGeneratorServer.__init__(self, port, bits,
												  use_video_levels, logfile)

	def send(self, rgb=(0, 0, 0), bgrgb=(0, 0, 0), bits=None,
			 use_video_levels=None, x=0, y=0, w=1, h=1):
		""" Send an RGB color to the pattern generator. The RGB range should be 0..1 """
		rgb, bgrgb, bits = self._get_rgb(rgb, bgrgb, bits, use_video_levels)
		xml = ('<?xml version="1.0" encoding="UTF-8" ?><calibration><shapes>'
			   '<rectangle><color red="%i" green="%i" blue="%i" />'
			   '<geometry x="%.2f" y="%.2f" cx="%.2f" cy="%.2f" /></rectangle>'
			   '</shapes></calibration>' % tuple(rgb + [x, y,  w, h]))
		self.conn.sendall("%s%s" % (struct.pack(">I", len(xml)), xml))


class ResolveCMPatternGeneratorServer(GenTCPSockPatternGeneratorServer):

	def __init__(self, port=20002, bits=10, use_video_levels=False,
				 logfile=None):
		GenTCPSockPatternGeneratorServer.__init__(self, port, bits,
												  use_video_levels, logfile)

	def send(self, rgb=(0, 0, 0), bgrgb=(0, 0, 0), bits=None,
			 use_video_levels=None, x=0, y=0, w=1, h=1):
		""" Send an RGB color to the pattern generator. The RGB range should be 0..1 """
		rgb, bgrgb, bits = self._get_rgb(rgb, bgrgb, bits, use_video_levels)
		xml = ('<?xml version="1.0" encoding="utf-8"?><calibration>'
			   '<color red="%i" green="%i" blue="%i" bits="%i"/>'
			   '<background red="%i" green="%i" blue="%i" bits="%i"/>'
			   '<geometry x="%.2f" y="%.2f" cx="%.2f" cy="%.2f"/>'
			   '</calibration>' % tuple(rgb + [bits] + bgrgb + [bits, x, y,
																  w, h]))
		self.conn.sendall("%s%s" % (struct.pack(">I", len(xml)), xml))
	

if __name__ == "__main__":
	patterngenerator = GenTCPSockPatternGeneratorServer()
