# -*- coding: utf-8 -*-

from __future__ import with_statement
import os
import re
import string
import urllib2

from config import get_data_path
from defaultpaths import cache as cachepath
from meta import domain
from options import verbose, debug
from log import safe_print as _safe_print
from util_io import GzipFileProper
from util_str import StrList, create_replace_function, safe_unicode
import colormath
import localization as lang


class VRMLParseError(Exception):
	pass


class Tag(object):

	""" X3D Tag """

	def __init__(self, tagname, **attributes):
		self.parent = None
		self.tagname = tagname
		self.children = []
		self.attributes = attributes

	def __str__(self):
		return self.markup()

	def markup(self, allow_empty_element_tag=False, x3dom=False):
		markup = ["<%s" % self.tagname]
		attrs = []
		for key, value in self.attributes.iteritems():
			value = value.strip().replace("<",
										  "&lt;").replace(">",
														  "&gt;").replace("&",
																		  "&amp;").replace("'",
																						   "&#39;")
			if value in ("FALSE", "TRUE"):
				value = value.lower()
			attrs.append("%s='%s'" % (key, value))
		if attrs:
			markup.append(" " + " ".join(attrs))
		if not allow_empty_element_tag:
			markup.append(">")
		if self.children:
			if allow_empty_element_tag:
				markup.append(">")
			markup.append("\n")
			for child in self.children:
				for line in child.markup(allow_empty_element_tag,
										 x3dom).splitlines():
					markup.append("\t" + line + "\n")
		if not allow_empty_element_tag or self.children:
			# Not XML, or XML with children
			markup.append("</%s>\n" % self.tagname)
		else:
			# XML, no children
			markup.append("/>")
		if (self.tagname == "Material" and
			float(self.attributes.get("transparency",
									  "0").strip()) not in (0.0, 1.0) and x3dom):
			# Fix z-fighting in X3DOM renderer
			markup.append("<DepthMode readOnly='true'></DepthMode>")
		return "".join(markup)

	def append_child(self, child):
		child.parent = self
		self.children.append(child)

	def html(self, title="Untitled", xhtml=False, embed=False, force=False,
			 cache=True):
		"""
		Convert X3D to HTML
		
		This will generate HTML5 by default unless you set xhtml=True.
		
		If embed is True, the X3DOM runtime and X3D viewer will be embedded in
		the HTML (increases filesize considerably)
		
		"""
		# Get children of X3D document
		x3d_html = re.sub("\s*</?X3D(?:\s+[^>]*)?>\s*", "",
						  self.markup(xhtml, True))
		if not xhtml:
			# Convert uppercase letters at start of tag name to lowercase
			x3d_html = re.sub("(</?[0-9A-Z]+)",
							  lambda match: match.groups()[0].lower(), x3d_html)
		# Indent
		x3d_html = "\n".join(["\t" * 2 + line
							  for line in x3d_html.splitlines()]).lstrip()

		# Collect resources
		def get_resource(url, source=True):
			baseurl, basename = os.path.split(url)
			# Strip protocol
			cache_uri = re.sub("^\w+://", "", baseurl)
			# Strip www
			cache_uri = re.sub("^(?:www\.)?", "", cache_uri)
			# domain.com -> com.domain
			domain, path = cache_uri.split("/", 1)
			cache_uri = "/".join([".".join(reversed(domain.split("."))), path])
			# com.domain/path -> com.domain.path
			cache_uri = re.sub("^([^/]+)/", "\\1.", cache_uri)
			cachedir = os.path.join(cachepath,
									os.path.join(*cache_uri.split("/")))
			if not os.path.isdir(cachedir):
				_safe_print("Creating cache directory:", cachedir)
				os.makedirs(cachedir)
			cachefilename = os.path.join(cachedir, basename)
			body = ""
			if not force and os.path.isfile(cachefilename):
				_safe_print("Using cached file:", cachefilename)
				with open(cachefilename, "rb") as cachefile:
					body = cachefile.read()
			if not body.strip():
				for url in (url, url.replace("https://", "http://")):
					_safe_print("Requesting:", url)
					try:
						response = urllib2.urlopen(url)
					except urllib2.URLError, exception:
						_safe_print(exception)
					else:
						body = response.read()
						response.close()
						break
			if not body.strip():
				# Fallback to local copy
				url = get_data_path("x3d-viewer/" + basename)
				if not url:
					_safe_print("Error: Resource not found:", basename)
					return
				with open(url, "rb") as resource_file:
					body = resource_file.read()
			if body.strip():
				if cache and (force or not os.path.isfile(cachefilename)):
					with open(cachefilename, "wb") as cachefile:
						cachefile.write(body)
				if source and not basename.endswith(".swf"):
					if basename.endswith(".css"):
						return "<style>%s</style>" % body
					elif basename.endswith(".js"):
						return "<script>%s" % body
					else:
						return body
				else:
					return "file:///" + safe_unicode(cachefilename).encode("UTF-8").lstrip("/").replace(os.path.sep, "/")
			else:
				_safe_print("Error: Empty document:", url)
				if os.path.isfile(cachefilename):
					_safe_print("Removing", cachefilename)
					os.remove(cachefilename)
		# Get HTML template from cache or online
		html = get_resource("https://%s/x3d-viewer/release/x3d-viewer.html" %
							domain.lower(), True)
		if cache or embed:
			# Update resources in HTML
			restags = re.findall("<[^>]+\s+data-fallback-\w+=[^>]*>", html)
			for restag in restags:
				attrname = re.search(r"\s+data-fallback-(\w+)=",
									 restag).groups()[0]
				url = re.search(r"\s+%s=([\"'])(.+?)\1" % attrname,
								restag).groups()[1]
				if url.endswith(".swf") and not cache:
					continue
				resource = get_resource(url, embed)
				if not resource:
					continue
				if embed and not url.endswith(".swf"):
					html = html.replace(restag, resource)
				else:
					updated_restag = re.sub(r"(\s+data-fallback-%s=)([\"']).+?\2"
											% attrname, r"\1\2%s\2" % resource,
											restag)
					html = html.replace(restag, updated_restag)
		# Update title
		html = re.sub("(<title>)[^<]*(</title>)",
					  create_replace_function(r"\1%s\2", safe_unicode(title).encode("UTF-8")), html)
		# Insert X3D
		html = html.replace("</x3d>", "\t" + x3d_html + "\n\t\t</x3d>")
		# Finish
		if xhtml:
			html = "<?xml version='1.0' encoding='UTF-8'?>\n" + html
			html = re.sub("\s*/>", " />", html)
		else:
			html = re.sub("\s*/>", ">", html)
		return html

	def xhtml(self, *args, **kwargs):
		kwargs["xhtml"] = True
		return self.html(*args, **kwargs)
	
	def x3d(self):
		x3d = "\n".join(["<?xml version='1.0' encoding='UTF-8'?>",
						 '<!DOCTYPE X3D PUBLIC "ISO//Web3D//DTD X3D 3.0//EN" "http://www.web3d.org/specifications/x3d-3.0.dtd">',
						 self.markup(allow_empty_element_tag=True)])
		return x3d

def _attrchk(attribute, token, tag, indent):
	if attribute:
		if debug:
			if tag.attributes.get(token):
				safe_print(indent, "attribute %r %r" % (token,
														tag.attributes[token]))
		attribute = False
	return attribute


def get_vrml_axes(xlabel="X", ylabel="Y", zlabel="Z", offsetx=0,
				  offsety=0, offsetz=0, maxx=100, maxy=100, maxz=100, zero=True):
	return """# Z axis
		Transform {
			translation %(offsetx).1f %(offsety).1f %(offsetz).1f
			children [
				Shape {
					geometry Box { size 2.0 2.0 %(maxz).1f }
					appearance Appearance {
						material Material { diffuseColor 0.7 0.7 0.7 }
					}
				}
			]
		}
		# Z axis label
		Transform {
			translation %(zlabelx).1f %(zlabely).1f %(zlabelz).1f
			children [
				Shape {
					geometry Text {
						string ["%(zlabel)s"]
						fontStyle FontStyle { family "SANS" style "BOLD" size 10.0 }
					}
					appearance Appearance {
						material Material { diffuseColor 0.7 0.7 0.7 }
					}
				}
			]
		}
		# X axis
		Transform {
			translation %(xaxisx).1f %(offsety).1f %(xyaxisz).1f
			children [
				Shape {
					geometry Box { size %(maxx).1f 2.0 2.0 }
					appearance Appearance {
						material Material { diffuseColor 0.7 0.7 0.7 }
					}
				}
			]
		}
		# X axis label
		Transform {
			translation %(xlabelx).1f %(xlabely).1f %(xyaxisz).1f
			children [
				Shape {
					geometry Text {
						string ["%(xlabel)s"]
						fontStyle FontStyle { family "SANS" style "BOLD" size 10.0 }
					}
					appearance Appearance {
						material Material { diffuseColor 0.7 0.7 0.7 }
					}
				}
			]
		}
		# Y axis
		Transform {
			translation %(offsetx).1f %(yaxisy).1f %(xyaxisz).1f
			children [
				Shape {
					geometry Box { size 2.0 %(maxy).1f 2.0 }
					appearance Appearance {
						material Material { diffuseColor 0.7 0.7 0.7 }
					}
				}
			]
		}
		# Y axis label
		Transform {
			translation %(ylabelx).1f %(ylabely).1f %(xyaxisz).1f
			children [
				Shape {
					geometry Text {
						string ["%(ylabel)s"]
						fontStyle FontStyle { family "SANS" style "BOLD" size 10.0 }
					}
					appearance Appearance {
						material Material { diffuseColor 0.7 0.7 0.7 }
					}
				}
			]
		}
		# Zero
		Transform {
			translation %(zerox).1f %(zeroy).1f %(zeroz).1f
			children [
				Shape {
					geometry Text {
						string ["%(zerolabel)s"]
						fontStyle FontStyle { family "SANS" style "BOLD" size 10.0 }
					}
					appearance Appearance {
						material Material { diffuseColor 0.7 0.7 0.7 }
					}
				}
			]
		}""" % dict(locals().items() +
					{"xaxisx": maxx / 2.0 + offsetx,
					 "yaxisy": maxy / 2.0 + offsety,
					 "xyaxisz": offsetz - maxz / 2.0,
					 "zlabelx": offsetx - 10,
					 "zlabely": offsety - 10,
					 "zlabelz": maxz / 2.0 + offsetz + 5,
					 "xlabelx": maxx + offsetx + 5,
					 "xlabely": offsety - 5,
					 "ylabelx": offsetx - 5,
					 "ylabely": maxy + offsety + 5,
					 "zerolabel": "0" if zero else "",
					 "zerox": offsetx - 10,
					 "zeroy": offsety - 10,
					 "zeroz": offsetz - maxz / 2.0 - 5}.items())


def safe_print(*args, **kwargs):
	if debug:
		_safe_print(*args, **kwargs)


def update_vrml(vrml, colorspace):
	""" Update color and axes in VRML """
	offsetx, offsety = 0, 0
	maxz = scale = 100
	maxxy = 200
	if colorspace.startswith("DIN99"):
		scale = 1.0
	elif colorspace == "Lu'v'":
		offsetx, offsety = -.3, -.3
		scale = maxxy / .6
	elif colorspace == "xyY":
		offsetx, offsety = -.4, -.4
		scale = maxxy / .8
	def update_xyz(xyz):
		x, y, z = [float(v) for v in xyz.split()]
		a, b, L = x, y, z + 50
		X, Y, Z = colormath.Lab2XYZ(L, a, b, scale=100)
		if colorspace.startswith("DIN99"):
			if colorspace == "DIN99":
				z, x, y = colormath.Lab2DIN99(L, a, b)
			elif colorspace == "DIN99b":
				z, x, y = colormath.Lab2DIN99b(L, a, b)
			elif colorspace == "DIN99c":
				z, x, y = colormath.XYZ2DIN99c(X, Y, Z)
			else:
				z, x, y = colormath.XYZ2DIN99d(X, Y, Z)
			x, y, z = x * scale, y * scale, z / 100.0 * maxz
		elif colorspace == "Luv":
			z, x, y = colormath.XYZ2Luv(X, Y, Z)
		elif colorspace == "Lu'v'":
			L, u_, v_ = colormath.XYZ2Lu_v_(X, Y, Z)
			x, y, z = ((u_ + offsetx) * scale,
					   (v_ + offsety) * scale,
					   L / 100.0 * maxz)
		elif colorspace == "xyY":
			x, y, Y = colormath.XYZ2xyY(X, Y, Z)
			x, y, z = ((x + offsetx) * scale,
					   (y + offsety) * scale,
					   Y / 100.0 * maxz)
		elif colorspace == "ICtCp":
			I, Ct, Cp = colormath.XYZ2ICtCp(X / 100.0, Y / 100.0, Z / 100.0,
										  clamp=False)
			z, x, y = I * 100, Ct * 100, Cp * 100
		z -= maxz / 2.0
		return " ".join(["%.6f" % v for v in (x, y, z)])
	# Update point lists
	for item in re.findall(r"point\s*\[[^\]]+\]", vrml):
		item = item[:-1].rstrip()
		# Remove comments
		points = re.sub("#[^\n\r]*", "", item)
		# Get actual points
		points = re.match("point\s*\[(.+)", points, re.S).groups()[0]
		points = points.strip().split(",")
		for i, xyz in enumerate(points):
			xyz = xyz.strip()
			if xyz:
				points[i] = update_xyz(xyz)
		vrml = vrml.replace(item, "point [%s%s" %
								  (os.linesep, 
								   ("," +
									os.linesep).join(points).rstrip()))
	# Update spheres
	spheres = re.findall(r'Transform\s*\{\s*translation\s+[+\-0-9.]+\s*[+\-0-9.]+\s*[+\-0-9.]+\s+children\s*\[\s*Shape\s*\{\s*geometry\s+Sphere\s*\{[^}]*\}\s*appearance\s+Appearance\s*\{\s*material\s+Material\s*\{[^}]*\}\s*\}\s*\}\s*\]\s*\}', vrml)
	for i, sphere in enumerate(spheres):
		coords = re.search(r"translation\s+([+\-0-9.]+\s+[+\-0-9.]+\s+[+\-0-9.]+)",
						   sphere)
		if coords:
			vrml = vrml.replace(sphere,
								sphere.replace(coords.group(),
											   "translation " +
											   update_xyz(coords.groups()[0])))
	if colorspace.startswith("DIN99"):
		# Remove * from L*a*b* and add range

		# Pristine Argyll CMS VRML
		vrml = re.sub(r'(string\s*\[")(\+?)(L)\*("\])', r'\1\3", "\2\0$\4', vrml)
		vrml = vrml.replace("\0$", "100")
		vrml = re.sub(r'(string\s*\[")([+\-]?)(a)\*("\])',
					  r'\1\3", "\2\0$\4', vrml)
		vrml = re.sub(r'(string\s*\[")([+\-]?)(b)\*("\])',
					  r'\1\3 \2\0$\4', vrml)

		# DisplayCAL tweaked VRML created by worker.Worker.calculate_gamut()
		vrml = re.sub(r'(string\s*\["a)\*",\s*"([+\-]?)\d+("\])',
					  r'\1", "\2\0$\3', vrml)
		vrml = re.sub(r'(string\s*\["b)\*\s+([+\-]?)\d+("\])',
					  r'\1 \2\0$\3', vrml)

		vrml = vrml.replace("\0$", "%i" % round(100.0 / scale))

		# Add colorspace information
		vrml = re.sub(r"(Viewpoint\s*\{[^}]+\})",
					  r"""\1
Transform {
	translation %.6f %.6f %.6f
	children [
		Shape {
			geometry Text {
				string ["%s"]
				fontStyle FontStyle { family "SANS" style "BOLD" size 10.0 }
			}
			appearance Appearance {
				material Material { diffuseColor 0.7 0.7 0.7 }
			}
		}
	]
}""" % (maxz + offsetx, maxz + offsety, -maxz / 2.0, colorspace), vrml)
	elif colorspace == "Luv":
		# Replace a* b* labels with u* v*
		vrml = re.sub(r'(string\s*\["[+\-]?)a(\*)',
					  r"\1u\2", vrml)
		vrml = re.sub(r'(string\s*\["[+\-]?)b(\*)',
					  r"\1v\2", vrml)
	elif colorspace in ("Lu'v'", "xyY"):
		# Remove axes
		vrml = re.sub(r'Transform\s*\{\s*translation\s+[+\-0-9.]+\s*[+\-0-9.]+\s*[+\-0-9.]+\s+children\s*\[\s*Shape\s*\{\s*geometry\s+Box\s*\{[^}]*\}\s*appearance\s+Appearance\s*\{\s*material\s+Material\s*\{[^}]*\}\s*\}\s*\}\s*\]\s*\}', "", vrml)
		# Remove axis labels
		vrml = re.sub(r'Transform\s*\{\s*translation\s+[+\-0-9.]+\s*[+\-0-9.]+\s*[+\-0-9.]+\s+children\s*\[\s*Shape\s*\{\s*geometry\s+Text\s*\{\s*string\s*\[[^\]]*\]\s*fontStyle\s+FontStyle\s*\{[^}]*\}\s*\}\s*appearance\s+Appearance\s*\{\s*material\s+Material\s*{[^}]*\}\s*\}\s*\}\s*\]\s*\}', "", vrml)
		# Add new axes + labels
		if colorspace == "Lu'v'":
			xlabel, ylabel, zlabel = "u' 0.6", "v' 0.6", "L* 100"
		else:
			xlabel, ylabel, zlabel = "x 0.8", "y 0.8", "Y 100"
		vrml = re.sub(r"(Viewpoint\s*\{[^}]+\})",
					  r"\1\n" + get_vrml_axes(xlabel, ylabel, zlabel,
											  offsetx * scale, offsety * scale,
											  0, maxxy, maxxy, maxz),
					  vrml)
	elif colorspace == "ICtCp":
		# Replace L* a* b* labels with I Ct Cp
		vrml = re.sub(r'(string\s*\["[+\-]?)L\*?',
					  r"\1I", vrml)
		vrml = re.sub(r'(string\s*\["[+\-]?)a\*?',
					  r"\1Ct", vrml)
		vrml = re.sub(r'(string\s*\["[+\-]?)b\*?',
					  r"\1Cp", vrml)
		# Change axis colors
		axes = re.findall(r'Shape\s*\{\s*geometry\s*(?:Box|Text)\s*\{\s*(?:size\s+\d+\.0+\s+\d+\.0+\s+\d+\.0+|string\s+\["[^"]*"\]\s*fontStyle\s+FontStyle\s*\{[^}]+\})\s*\}\s*appearance\s+Appearance\s*\{\s*material\s*Material\s*\{[^}]+}\s*\}\s*\}', vrml)
		for i, axis in enumerate(axes):
			# Red -> purpleish blue
			vrml = vrml.replace(axis, re.sub("diffuseColor\s+1\.0+\s+0\.0+\s+0\.0+",
											 "diffuseColor 0.5 0.0 1.0", axis))
			# Green -> yellowish green
			vrml = vrml.replace(axis, re.sub("diffuseColor\s+0\.0+\s+1\.0+\s+0\.0+",
											 "diffuseColor 0.8 1.0 0.0", axis))
			# Yellow -> magentaish red
			vrml = vrml.replace(axis, re.sub("diffuseColor\s+1\.0+\s+1\.0+\s+0\.0+",
											 "diffuseColor 1.0 0.0 0.25", axis))
			# Blue -> cyan
			vrml = vrml.replace(axis, re.sub("diffuseColor\s+0\.0+\s+0\.0+\s+1\.0+",
											 "diffuseColor 0.0 1.0 1.0", axis))
	return vrml


def vrml2x3dom(vrml, worker=None):
	""" Convert VRML to X3D """
	x3d = Tag("X3D",  **{"xmlns:xsd": "http://www.w3.org/2001/XMLSchema-instance",
						 "profile": "Immersive",
						 "version": "3.0",
						 "xsd:noNamespaceSchemaLocation": "http://www.web3d.org/specifications/x3d-3.0.xsd"})
	tag = Tag("Scene")
	x3d.append_child(tag)
	token = ""
	valid_token_chars = string.ascii_letters + string.digits + "_"
	attribute = False
	quote = 0
	listing = False
	# Remove comments
	vrml = re.sub("#[^\n\r]*", "", vrml)
	# <class> <Token> { -> <Token> {
	vrml = re.sub("\w+[ \t]+(\w+\s*\{)", "\\1", vrml)
	# Remove commas
	vrml = re.sub(",\s*", " ", vrml)
	indent = ""
	maxi = len(vrml) - 1.0
	lastprogress = 0
	for i, c in enumerate(vrml):
		curprogress = int(i / maxi * 100)
		if worker:
			if curprogress > lastprogress:
				worker.lastmsg.write("%i%%\n" % curprogress)
			if getattr(worker, "thread_abort", False):
				return False
		if curprogress > lastprogress:
			lastprogress = curprogress
			if curprogress < 100:
				end = None
			else:
				end = "\n"
			_safe_print.write("\r%i%%" % curprogress, end=end)
		if ord(c) < 32 and c not in "\n\r\t":
			raise VRMLParseError("Parse error: Got invalid character %r" % c)
		elif c == "{":
			safe_print(indent, "start tag %r" % token)
			indent += "  "
			attribute = False
			if token:
				if token[0] not in string.ascii_letters:
					raise VRMLParseError("Invalid token", token)
			else:
				raise VRMLParseError("Parse error: Empty token")
			child = Tag(token)
			tag.append_child(child)
			tag = child
			token = ""
		elif c == "}":
			attribute = _attrchk(attribute, token, tag, indent)
			indent = indent[:-2]
			safe_print(indent, "end tag %r" % tag.tagname)
			if tag.parent:
				tag = tag.parent
			else:
				raise VRMLParseError("Parse error: Stray '}'")
			token = ""
		elif c == "[":
			if token:
				safe_print(indent, "listing %r" % token)
				listing = True
		elif c == "]":
			attribute = _attrchk(attribute, token, tag, indent)
			token = ""
			listing = False
		elif attribute:
			if c in ("\n", "\r"):
				if listing:
					if (tag.attributes.get(token) and
						tag.attributes[token][-1] != " "):
						tag.attributes[token] += " "
				else:
					attribute = _attrchk(attribute, token, tag, indent)
					token = ""
			else:
				if not token in tag.attributes:
					tag.attributes[token] = StrList()
				if not (c.strip() or tag.attributes[token]):
					continue
				if c == '"':
					quote += 1
				if c != '"' or tag.tagname != "FontStyle" or token != "style":
					if c != " " or (tag.attributes[token] and
									tag.attributes[token][-1] != " "):
						tag.attributes[token] += c
				if quote == 2:
					if not listing:
						attribute = _attrchk(attribute, token, tag, indent)
						token = ""
					quote = 0
		elif c not in (" ", "\n", "\r", "\t"):
			if c in valid_token_chars:
				token += c
			else:
				raise VRMLParseError("Parse error: Got invalid character %r" % c)
		elif token:
			if token[0] not in string.ascii_letters:
				raise VRMLParseError("Parse error: Invalid token", token)
			if token == "children":
				token = ""
			elif c in (" ", "\t"):
				if not attribute:
					attribute = True
					if token in tag.attributes:
						# Overwrite existing attribute
						tag.attributes[token] = StrList()
	return x3d


def vrmlfile2x3dfile(vrmlpath, x3dpath, html=True, embed=False, force=False,
					 cache=True, worker=None):
	"""
	Convert VRML file located at vrmlpath to HTML and write to x3dpath
	
	"""
	filename, ext = os.path.splitext(vrmlpath)
	if ext.lower() in (".gz", ".wrz"):
		cls = GzipFileProper
	else:
		cls = open
	with cls(vrmlpath, "rb") as vrmlfile:
		vrml = vrmlfile.read()
	if worker:
		worker.recent.write("%s %s\n" % (lang.getstr("converting"),
										 os.path.basename(vrmlpath)))
	_safe_print(lang.getstr("converting"), vrmlpath)
	filename, ext = os.path.splitext(x3dpath)
	try:
		x3d = vrml2x3dom(vrml, worker)
		if not x3d:
			_safe_print(lang.getstr("aborted"))
			return False
		if not html:
			_safe_print("Writing", x3dpath)
			with open(x3dpath, "wb") as x3dfile:
				x3dfile.write(x3d.x3d())
		else:
			html = x3d.html(title=os.path.basename(filename),
							embed=embed, force=force, cache=cache)
			_safe_print("Writing", x3dpath + ".html")
			with open(x3dpath + ".html", "wb") as htmlfile:
				htmlfile.write(html)
	except KeyboardInterrupt:
		x3d = False
	except VRMLParseError, exception:
		return exception
	except EnvironmentError, exception:
		return exception
	except Exception, exception:
		import traceback
		_safe_print(traceback.format_exc())
		return exception
	return True
