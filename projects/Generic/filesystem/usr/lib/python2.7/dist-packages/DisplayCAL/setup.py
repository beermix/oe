# -*- coding: utf-8 -*-

"""
DisplayCAL setup.py script

Can be used with setuptools or pure distutils (the latter can be forced 
with the --use-distutils option, otherwise it will try to use setuptools 
by default).

Also supported in addition to standard distutils/setuptools commands, 
are the bdist_bbfreeze, py2app and py2exe commands (if the appropriate 
packages are installed), which makes this file your all-around building/
bundling powerhouse for DisplayCAL. In the case of py2exe, special care 
is taken of Python 2.6+ and the Microsoft.VC90.CRT assembly dependency, 
so if building an executable on Windows with Python 2.6+ you should 
preferably use py2exe. Please note that bdist_bbfreeze and py2app 
*require* setuptools.

IMPORTANT NOTE:
If called from within the installed package, should only be used to 
uninstall (setup.py uninstall --record=INSTALLED_FILES), otherwise use 
the wrapper script in the root directory of the source tar.gz/zip

"""

from __future__ import with_statement
from ConfigParser import ConfigParser
from distutils.command.install import install
from distutils.util import change_root, get_platform
from fnmatch import fnmatch
import codecs
import ctypes.util
import distutils.core
import glob
import os
import platform
import re
import shutil
import subprocess as sp
import sys
from time import strftime
from types import StringType


# Borrowed from setuptools
def findall(dir=os.curdir):
	"""Find all files under 'dir' and return the list of full filenames
	(relative to 'dir').
	"""
	all_files = []
	for base, dirs, files in os.walk(dir, followlinks=True):
		if base == os.curdir or base.startswith(os.curdir + os.sep):
			base = base[2:]
		if base:
			files = [os.path.join(base, f) for f in files]
		all_files.extend(filter(os.path.isfile, files))
	return all_files

import distutils.filelist
distutils.filelist.findall = findall    # Fix findall bug in distutils


from defaultpaths import autostart, autostart_home
from meta import (author, author_ascii, description, longdesc, domain, name, 
				  py_maxversion, py_minversion, version, version_tuple, 
				  wx_minversion, author_email, script2pywname)
from util_os import relpath
appname = name

bits = platform.architecture()[0][:2]
pypath = os.path.abspath(__file__)
pydir = os.path.dirname(pypath)
basedir = os.path.dirname(pydir)

config = {"data": ["tests/*.icc"],
		  "doc": ["LICENSE.txt",
				  "README.html",
				  "README-fr.html",
				  "screenshots/*.png",
				  "theme/*.png",
				  "theme/*.css",
				  "theme/*.js",
				  "theme/icons/favicon.ico",
				  "theme/slimbox2/*.css",
				  "theme/slimbox2/*.js"],
		  # Excludes for .app/.exe builds
		  # numpy.lib.utils imports pydoc, which imports Tkinter, but 
		  # numpy.lib.utils is not even used by DisplayCAL, so omit all 
		  # Tk stuff
		  # Use pyglet with OpenAL as audio backend. We only need
		  # pyglet, pyglet.app and pyglet.media
		  "excludes": {"all": ["Tkconstants", "Tkinter", "pygame",
							   "pyglet.canvas", "pyglet.extlibs", "pyglet.font",
							   "pyglet.gl", "pyglet.graphics", "pyglet.image",
							   "pyglet.input", "pyglet.text",
							   "pyglet.window", "pyo", "setuptools", "tcl",
							   "test"],
					   "darwin": [],
					   "win32": ["win32com.client.genpy"]},
		  "package_data": {name: ["argyll_instruments.json",
								  "beep.wav",
								  "camera_shutter.wav",
								  "ColorLookupTable.fx",
								  "lang/*.json",
								  "linear.cal",
								  "pnp.ids",
								  "presets/*.icc",
								  "quirk.json",
								  "ref/*.cie",
								  "ref/*.gam",
								  "ref/*.icm",
								  "ref/*.ti1",
								  "report/*.css",
								  "report/*.html",
								  "report/*.js",
								  "technology_strings-1.7.0.json",
								  "technology_strings-1.7.1.json",
								  "test.cal",
								  "theme/*.png",
								  "theme/*.wav",
								  "theme/icons/10x10/*.png",
								  "theme/icons/16x16/*.png",
								  "theme/icons/32x32/*.png",
								  "theme/icons/72x72/*.png",
								  "theme/jet_anim/*.png",
								  "theme/patch_anim/*.png",
								  "theme/splash_anim/*.png",
								  "theme/shutter_anim/*.png",
								  "ti1/*.ti1",
								  "x3d-viewer/*.css",
								  "x3d-viewer/*.html",
								  "x3d-viewer/*.js",
								  "xrc/*.xrc"]},
		  "xtra_package_data": {name: {"win32": ["theme/icons/%s-uninstall.ico"
												 % name]}}}


def add_lib_excludes(key, excludebits):
	for exclude in excludebits:
		config["excludes"][key].extend([name + ".lib" + exclude,
										"lib" + exclude])
	for exclude in ("32", "64"):
		for pycompat in ("26", "27"):
			if (key == "win32" and
				(pycompat == sys.version[0] + sys.version[2] or
				 exclude == excludebits[0])):
				continue
			config["excludes"][key].extend([name + ".lib%s.python%s" %
											(exclude, pycompat),
											name + ".lib%s.python%s.RealDisplaySizeMM" %
											(exclude, pycompat)])


add_lib_excludes("darwin", ["64" if bits == "32" else "32"])
add_lib_excludes("win32", ["64" if bits == "32" else "32"])

msiversion = ".".join((str(version_tuple[0]), 
					   str(version_tuple[1]), 
					   str(version_tuple[2]) + 
					   str(version_tuple[3])))

plist_dict = {"CFBundleDevelopmentRegion": "English",
			  "CFBundleExecutable": name,
			  "CFBundleGetInfoString": version,
			  "CFBundleIdentifier": ".".join(reversed(domain.split("."))),
			  "CFBundleInfoDictionaryVersion": "6.0",
			  "CFBundleLongVersionString": version,
			  "CFBundleName": name,
			  "CFBundlePackageType": "APPL",
			  "CFBundleShortVersionString": version,
			  "CFBundleSignature": "????",
			  "CFBundleVersion": ".".join(map(str, version_tuple)),
			  "NSHumanReadableCopyright": u"© %s %s" % (strftime("%Y"), author),
			  "LSMinimumSystemVersion": "10.5.0"}


class Target:
	def __init__(self, **kwargs):
		self.__dict__.update(kwargs)


def create_app_symlinks(dist_dir, scripts):
	maincontents_rel = os.path.join(name + ".app", "Contents")
	# Create ref, tests, ReadMe and license symlinks in directory
	# containing the app bundle
	for src, tgt in [("ref", "Reference"),
					 ("tests", "Tests"),
					 ("README.html", "README.html"),
					 ("README-fr.html", "README-fr.html"),
					 ("LICENSE.txt", "LICENSE.txt")]:
		tgt = os.path.join(dist_dir, tgt)
		if os.path.islink(tgt):
			os.unlink(tgt)
		os.symlink(os.path.join(maincontents_rel, "Resources", src), tgt)
	# Create standalone tools app bundles by symlinking to the main bundle
	scripts = [(script2pywname(script), desc) for script, desc in scripts]
	toolscripts = filter(lambda script: script != name,
						 [script for script, desc in scripts])
	for script, desc in scripts:
		if script in (name, name + "-apply-profiles"):
			continue
		toolname = desc.replace(name, "").strip()
		toolapp = os.path.join(dist_dir, toolname + ".app")
		if os.path.isdir(toolapp):
			if raw_input('WARNING: The output directory "%s" and ALL ITS '
                         'CONTENTS will be REMOVED! Continue? (y/n)' % toolapp).lower() == 'y':
				print "Removing dir", toolapp
				shutil.rmtree(toolapp)
			else:
				raise SystemExit('User aborted')
		toolscript = os.path.join(dist_dir, maincontents_rel, 'MacOS', script)
		has_tool_script = os.path.exists(toolscript)
		if not has_tool_script:
			# Don't symlink, apps won't be able to run in parallel!
			shutil.copy(os.path.join(dist_dir, maincontents_rel, 'MacOS',
						appname), toolscript)
		toolcontents = os.path.join(toolapp, "Contents")
		os.makedirs(toolcontents)
		subdirs = ["Frameworks", "Resources"]
		if has_tool_script:
			# PyInstaller
			subdirs.append("MacOS")
		for entry in os.listdir(os.path.join(dist_dir, maincontents_rel)):
			if entry in subdirs:
				os.makedirs(os.path.join(toolcontents, entry))
				for subentry in os.listdir(os.path.join(dist_dir,
														maincontents_rel,
														entry)):
					src = os.path.join(dist_dir, maincontents_rel,
									   entry, subentry)
					tgt = os.path.join(toolcontents, entry, subentry)
					if subentry == "main.py":
						# py2app
						with open(src, "rb") as main_in:
							py = main_in.read()
						py = py.replace("main()",
										"main(%r)" %
										script[len(name) + 1:])
						with open(tgt, "wb") as main_out:
							main_out.write(py)
						continue
					if subentry == name + ".icns":
						shutil.copy(os.path.join(pydir, "theme",
												 "icons", 
												 "%s.icns" % script),
									os.path.join(toolcontents, entry, 
												 "%s.icns" % script))
						continue
					if subentry == script:
						# PyInstaller
						os.rename(src, tgt)
					elif subentry not in toolscripts:
						os.symlink(os.path.join("..", "..", "..",
												maincontents_rel, entry,
												subentry), tgt)
			elif entry == "Info.plist":
				with codecs.open(os.path.join(dist_dir, maincontents_rel,
											  entry), "r", "UTF-8") as info_in:
					infoxml = info_in.read()
				# CFBundleName / CFBundleDisplayName
				infoxml = re.sub("(Name</key>\s*<string>)%s" % name,
								 lambda match: match.group(1) +
											   toolname, infoxml)
				# CFBundleIdentifier
				infoxml = infoxml.replace(".%s</string>" % name,
										  ".%s</string>" % script)
				# CFBundleIconFile
				infoxml = infoxml.replace("%s.icns</string>" % name,
										  "%s.icns</string>" % script)
				# CFBundleExecutable
				infoxml = re.sub("(Executable</key>\s*<string>)%s" % name,
								 lambda match: match.group(1) +
											   script, infoxml)
				with codecs.open(os.path.join(toolcontents, entry), "w",
								 "UTF-8") as info_out:
					info_out.write(infoxml)
			else:
				os.symlink(os.path.join("..", "..", maincontents_rel, entry),
						   os.path.join(toolcontents, entry))


def get_data(tgt_dir, key, pkgname=None, subkey=None, excludes=None):
	""" Return configured data files """
	files = config[key]
	src_dir = basedir
	if pkgname:
		files = files[pkgname]
		src_dir = os.path.join(src_dir, pkgname)
		if subkey:
			if subkey in files:
				files = files[subkey]
			else:
				files = []
	data = []
	for pth in files:
		if not filter(lambda exclude: fnmatch(pth, exclude), excludes or []):
			data.append((os.path.normpath(os.path.join(tgt_dir, os.path.dirname(pth))),
						 glob.glob(os.path.join(src_dir, pth))))
	return data


def get_scripts(excludes=None):
	# It is required that each script has an accompanying .desktop file
	scripts = []
	desktopfiles = glob.glob(os.path.join(pydir, "..", "misc",
							 appname.lower() + "*.desktop"))
	def sortbyname(a, b):
		a, b = [os.path.splitext(v)[0] for v in (a, b)]
		if a > b:
			return 1
		elif a < b:
			return -1
		else:
			return 0
	desktopfiles.sort(sortbyname)
	for desktopfile in desktopfiles:
		if desktopfile.startswith("z-"):
			continue
		cfg = ConfigParser()
		cfg.read(desktopfile)
		script = cfg.get("Desktop Entry", "Exec").split()[0]
		if not filter(lambda exclude: fnmatch(script, exclude), excludes or []):
			scripts.append((script,
							cfg.get("Desktop Entry", "Name").decode("UTF-8")))
	return scripts


def setup():
	print "***", os.path.abspath(sys.argv[0]), " ".join(sys.argv[1:])

	bdist_bbfreeze = "bdist_bbfreeze" in sys.argv[1:]
	bdist_dumb = "bdist_dumb" in sys.argv[1:]
	bdist_win = "bdist_msi" in sys.argv[1:] or "bdist_wininst" in sys.argv[1:]
	debug = 0
	do_full_install = False
	do_install = False
	do_py2app = "py2app" in sys.argv[1:]
	do_py2exe = "py2exe" in sys.argv[1:]
	do_uninstall = "uninstall" in sys.argv[1:]
	doc_layout = "deb" if os.path.exists("/etc/debian_version") else ""
	dry_run = "-n" in sys.argv[1:] or "--dry-run" in sys.argv[1:]
	help = False
	install_data = None # data files install path (only if given)
	is_rpm_build = "bdist_rpm" in sys.argv[1:] or os.path.abspath(sys.argv[0]).endswith(
		os.path.join(os.path.sep, "rpm", "BUILD", name + "-" + version, 
		os.path.basename(os.path.abspath(sys.argv[0]))))
	prefix = ""
	recordfile_name = None # record installed files to this file
	sdist = "sdist" in sys.argv[1:]
	setuptools = None
	skip_instrument_conf_files = "--skip-instrument-configuration-files" in \
		sys.argv[1:]
	skip_postinstall = "--skip-postinstall" in sys.argv[1:]
	use_distutils = not bdist_bbfreeze and not do_py2app
	use_setuptools = not use_distutils or "--use-setuptools" in \
		sys.argv[1:] or (os.path.exists("use-setuptools") and 
						 not "--use-distutils" in sys.argv[1:])

	sys.path.insert(1, os.path.join(os.path.dirname(pydir), "util"))

	current_findall = distutils.filelist.findall

	if use_setuptools:
		if "--use-setuptools" in sys.argv[1:] and not \
		   os.path.exists("use-setuptools"):
			open("use-setuptools", "w").close()
		try:
			from ez_setup import use_setuptools as ez_use_setuptools
			ez_use_setuptools()
		except ImportError:
			pass
		try:
			from setuptools import setup, Extension
			setuptools = True
			print "using setuptools"
			current_findall = distutils.filelist.findall
		except ImportError:
			pass
	else:
		if os.path.exists("use-setuptools"):
			os.remove("use-setuptools")

	if distutils.filelist.findall is current_findall:
		# Fix traversing unneeded dirs which can take a long time (minutes)
		def findall(dir=os.curdir, original=distutils.filelist.findall, listdir=os.listdir,
					basename=os.path.basename):
			os.listdir = lambda path: filter(lambda entry: entry not in ("build",
																		 "dist") and
														   not entry.startswith("."),
											 listdir(path))
			try:
				return original(dir)
			finally:
				os.listdir = listdir

		distutils.filelist.findall = findall

	if not setuptools:
		from distutils.core import setup, Extension
		print "using distutils"
	
	if do_py2exe:
		import py2exe
		# ModuleFinder can't handle runtime changes to __path__, but win32com 
		# uses them
		try:
			# if this doesn't work, try import modulefinder
			import py2exe.mf as modulefinder
			import win32com
			for p in win32com.__path__[1:]:
				modulefinder.AddPackagePath("win32com", p)
			for extra in ["win32com.shell"]:
				__import__(extra)
				m = sys.modules[extra]
				for p in m.__path__[1:]:
					modulefinder.AddPackagePath(extra, p)
		except ImportError:
			# no build path setup, no worries.
			pass
	
	if do_py2exe:
		origIsSystemDLL = py2exe.build_exe.isSystemDLL
		systemroot = os.getenv("SystemRoot").lower()
		def isSystemDLL(pathname):
			if (os.path.basename(pathname).lower() in ("gdiplus.dll", 
													   "mfc90.dll") or
				os.path.basename(pathname).lower().startswith("python") or
				os.path.basename(pathname).lower().startswith("pywintypes")):
				return 0
			return pathname.lower().startswith(systemroot + "\\")
		py2exe.build_exe.isSystemDLL = isSystemDLL

		# Numpy DLL paths fix
		def numpy_dll_paths_fix():
			import numpy
			paths = set()
			numpy_path = numpy.__path__[0]
			for dirpath, dirnames, filenames in os.walk(numpy_path):
				for item in filenames:
					if item.lower().endswith(".dll"):
						paths.add(dirpath)
			sys.path.extend(paths)
		numpy_dll_paths_fix()

	if do_uninstall:
		i = sys.argv.index("uninstall")
		sys.argv = sys.argv[:i] + ["install"] + sys.argv[i + 1:]
		install.create_home_path = lambda self: None

	if skip_instrument_conf_files:
		i = sys.argv.index("--skip-instrument-configuration-files")
		sys.argv = sys.argv[:i] + sys.argv[i + 1:]
	
	if skip_postinstall:
		i = sys.argv.index("--skip-postinstall")
		sys.argv = sys.argv[:i] + sys.argv[i + 1:]

	if "--use-distutils" in sys.argv[1:]:
		i = sys.argv.index("--use-distutils")
		sys.argv = sys.argv[:i] + sys.argv[i + 1:]

	if "--use-setuptools" in sys.argv[1:]:
		i = sys.argv.index("--use-setuptools")
		sys.argv = sys.argv[:i] + sys.argv[i + 1:]

	argv = list(sys.argv[1:])
	for i, arg in enumerate(reversed(argv)):
		n = len(sys.argv) - i - 1
		if arg in ("install", "install_lib", "install_headers", 
				   "install_scripts", "install_data"):
			if arg == "install":
				do_full_install = True
			do_install = True
		elif arg == "-d" and len(sys.argv[1:]) > i:
			dist_dir = sys.argv[i + 2]
		else:
			arg = arg.split("=")
			if arg[0] == "--debug":
				debug = 1 if len(arg) == 1 else int(arg[1])
				sys.argv = sys.argv[:n] + sys.argv[n + 1:]
			elif len(arg) == 2:
				if arg[0] == "--dist-dir":
					dist_dir = arg[1]
				elif arg[0] == "--doc-layout":
					doc_layout = arg[1]
					sys.argv = sys.argv[:n] + sys.argv[n + 1:]
				elif arg[0] == "--install-data":
					install_data = arg[1]
				elif arg[0] == "--prefix":
					prefix = arg[1]
				elif arg[0] == "--record":
					recordfile_name = arg[1]
			elif arg[0] == "-h" or arg[0].startswith("--help"):
				help = True

	if not recordfile_name and (do_full_install or do_uninstall):
		recordfile_name = "INSTALLED_FILES"
		# if not do_uninstall:
			# sys.argv.append("--record=" + "INSTALLED_FILES")

	if sys.platform in ("darwin", "win32") or "bdist_egg" in sys.argv[1:]:
		doc = data = "." if do_py2app or do_py2exe or bdist_bbfreeze else name
	else:
		# Linux/Unix
		data = name
		if doc_layout.startswith("deb"):
			doc = os.path.join("doc", name.lower())
		elif "suse" in doc_layout:
			doc = os.path.join("doc", "packages", name)
		else:
			doc = os.path.join("doc", name + "-" + version)
		if not install_data:
			data = os.path.join("share", data)
			doc = os.path.join("share", doc)
			if is_rpm_build:
				doc = os.path.join(os.path.sep, "usr", doc)

	# on Mac OS X and Windows, we want data files in the package dir
	# (package_data will be ignored when using py2exe)
	package_data = {
		name: config["package_data"][name]
			  if sys.platform in ("darwin", "win32") and not do_py2app and not 
			  do_py2exe else []
	}
	if sdist and sys.platform in ("darwin", "win32"):
		package_data[name].extend(["theme/icons/22x22/*.png",
								   "theme/icons/24x24/*.png",
								   "theme/icons/48x48/*.png",
								   "theme/icons/128x128/*.png",
								   "theme/icons/256x256/*.png"])
	if sys.platform == "win32" and not do_py2exe:
		package_data[name].append("theme/icons/*.ico")
	# Scripts
	if sys.platform == 'darwin':
		scripts = get_scripts(excludes=[appname.lower() + '-apply-profiles'])
	else:
		scripts = get_scripts()
	# Doc files
	data_files = []
	if not is_rpm_build or doc_layout.startswith("deb"):
		data_files += get_data(doc, "doc", excludes=["LICENSE.txt"])
	if data_files:
		if doc_layout.startswith("deb"):
			data_files.append((doc, [os.path.join(pydir, "..", "dist", 
												  "copyright")]))
			data_files.append((os.path.join(os.path.dirname(data), "doc-base"), 
							   [os.path.join(pydir, "..", "misc", 
											 appname.lower() + "-readme")]))
		else:
			data_files.append((doc, [os.path.join(pydir, "..", "LICENSE.txt")]))
	if sys.platform not in ("darwin", "win32") or do_py2app or do_py2exe:
		# Linux/Unix or py2app/py2exe
		data_files += get_data(data, "package_data", name,
							   excludes=["theme/icons/*"])
		data_files += get_data(data, "data")
		data_files += get_data(data, "xtra_package_data", name, sys.platform)
		if sys.platform == "win32":
			# Add python and pythonw
			data_files.extend([(os.path.join(data, "lib"), [sys.executable,
				os.path.join(os.path.dirname(sys.executable), "pythonw.exe")])])
			# OpenAL DLLs for pyglet
			openal32 = ctypes.util.find_library("OpenAL32.dll")
			wrap_oal = ctypes.util.find_library("wrap_oal.dll")
			if openal32:
				oal = [openal32]
				if wrap_oal:
					oal.append(wrap_oal)
				else:
					print "WARNING: wrap_oal.dll not found!"
				data_files.append((data, oal))
			else:
				print "WARNING: OpenAL32.dll not found!"
		elif sys.platform != "darwin":
			# Linux
			data_files.append((os.path.join(os.path.dirname(data), "appdata"),
							   [os.path.join(pydir, "..", "dist", 
											 name + ".appdata.xml")]))
			data_files.append((os.path.join(os.path.dirname(data), 
											"applications"), 
							   [os.path.join(pydir, "..", "misc", name.lower() + 
											 ".desktop")] +
							   glob.glob(os.path.join(pydir, "..", "misc",
													  name.lower() + "-*.desktop"))))
			data_files.append((autostart if os.geteuid() == 0 or prefix.startswith("/")
							   else autostart_home, 
							   [os.path.join(pydir, "..", "misc", 
											 "z-%s-apply-profiles.desktop" % name.lower())]))
			data_files.append((os.path.join(os.path.dirname(data), "man", "man1"), 
							   glob.glob(os.path.join(pydir, "..", "man", "*.1"))))
			if not skip_instrument_conf_files:
				# device configuration / permission stuff
				if is_rpm_build:
					# RPM postinstall script will install these to the correct
					# locations. This allows us compatibility with Argyll
					# packages which may also contain same udev rules / hotplug
					# scripts, thus avoiding file conflicts
					data_files.append((os.path.join(data, "usb"), [os.path.join(
									   pydir, "..", "misc", "45-Argyll.rules")]))
					data_files.append((os.path.join(data, "usb"), [os.path.join(
									   pydir, "..", "misc", "55-Argyll.rules")]))
					data_files.append((os.path.join(data, "usb"), [os.path.join(
									   pydir, "..", "misc", "Argyll")]))
					data_files.append((os.path.join(data, "usb"), [os.path.join(
									   pydir, "..", "misc", "Argyll.usermap")]))
				else:
					devconf_files = []
					if os.path.isdir("/etc/udev/rules.d"):
						if glob.glob("/dev/bus/usb/*/*"):
							# USB and serial instruments using udev, where udev 
							# already creates /dev/bus/usb/00X/00X devices
							devconf_files.append(
								("/etc/udev/rules.d", [os.path.join(
									pydir, "..", "misc", "55-Argyll.rules")]))
						else:
							# USB using udev, where there are NOT /dev/bus/usb/00X/00X 
							# devices
							devconf_files.append(
								("/etc/udev/rules.d", [os.path.join(
									pydir, "..", "misc", "45-Argyll.rules")]))
					else:
						if os.path.isdir("/etc/hotplug"):
							# USB using hotplug and Serial using udev
							# (older versions of Linux)
							devconf_files.append(
								("/etc/hotplug/usb", [os.path.join(pydir, "..", "misc", 
																   fname) for fname in 
													  ["Argyll", "Argyll.usermap"]]))
					for entry in devconf_files:
						for fname in entry[1]:
							if os.path.isfile(fname):
								data_files.extend([(entry[0], [fname])])
		for dname in ("10x10", "16x16", "22x22", "24x24", "32x32", "48x48",
					  "72x72", "128x128", "256x256"):
			# Only the 10x10, 16x16, 32x32 and 72x72 icons are used exclusively
			# by the app, the other sizes of the app icon are used for the 
			# desktop entry under Linux
			icons = []
			desktopicons = []
			if sys.platform == "darwin":
				largest_icon_size = "128x128"
			else:
				largest_icon_size = "256x256"
			for iconpath in glob.glob(os.path.join(pydir, "theme", "icons", 
												   dname, "*.png")):
				if not os.path.basename(iconpath).startswith(name.lower()) or (
					sys.platform in ("darwin", "win32") and 
					dname in ("16x16", "32x32", "48x48", largest_icon_size)):
					# We need all the sizes we use in get_icon_bundle
					icons.append(iconpath)
				elif sys.platform not in ("darwin", "win32"):
					desktopicons.append(iconpath)
			if icons:
				data_files.append((os.path.join(data, "theme", "icons", dname), 
								   icons))
			if desktopicons:
				data_files.append((os.path.join(os.path.dirname(data), "icons", 
											 "hicolor", dname, "apps"), 
								   desktopicons))

	sources = [os.path.join(name, "RealDisplaySizeMM.c")]
	if sys.platform == "win32":
		macros = [("NT", None)]
		libraries = ["user32", "gdi32"]
		link_args = None
	elif sys.platform == "darwin":
		macros = [("__APPLE__", None), ("UNIX", None)]
		libraries = None
		link_args = ["-framework Carbon", "-framework CoreFoundation", 
						   "-framework Python", "-framework IOKit"]
		if not help and ("build" in sys.argv[1:] or 
						 "build_ext" in sys.argv[1:] or 
						 (("install" in sys.argv[1:] or 
						   "install_lib" in sys.argv[1:]) and 
						  not "--skip-build" in sys.argv[1:])):
			p = sp.Popen([sys.executable, '-c', '''import os
from distutils.core import setup, Extension

setup(ext_modules=[Extension("%s.lib%s.RealDisplaySizeMM", sources=%r, 
							 define_macros=%r, extra_link_args=%r)])''' % 
						  (name, bits, sources, macros, link_args)] + sys.argv[1:], 
						 stdout = sp.PIPE, stderr = sp.STDOUT)
			lines = []
			while True:
				o = p.stdout.readline()
				if o == '' and p.poll() != None:
					break
				if o[0:4] == 'gcc ':
					lines.append(o)
				print o.rstrip()
			if len(lines):
				os.environ['MACOSX_DEPLOYMENT_TARGET'] = '10.3'
				sp.call(lines[-1], shell = True)  # fix the library
	else:
		macros = [("UNIX", None)]
		libraries = ["X11", "Xinerama", "Xrandr", "Xxf86vm"]
		link_args = None
	if sys.platform == "darwin":
		extname = "%s.lib%s.RealDisplaySizeMM" % (name, bits)
	else:
		extname = "%s.lib%s.python%s%s.RealDisplaySizeMM" % ((name, bits) + 
															 sys.version_info[:2])
	RealDisplaySizeMM = Extension(extname, 
								  sources=sources, 
								  define_macros=macros, 
								  libraries=libraries,
								  extra_link_args=link_args)
	ext_modules = [RealDisplaySizeMM]

	requires = []
	if not setuptools or sys.platform != "win32":
		# wxPython windows installer doesn't add egg-info entry, so
		# a dependency check from pkg_resources would always fail
		requires.append(
			"wxPython (>= %s)" % ".".join(str(n) for n in wx_minversion))
	if sys.platform == "win32":
		requires.append("pywin32 (>= 213.0)")

	packages = [name, "%s.lib" % name, "%s.lib.agw" % name]
	if sdist:
		# For source desributions we want all libraries
		for tmpbits in ("32", "64"):
			for pycompat in ("26", "27"):
				packages.extend(["%s.lib%s" % (name, tmpbits),
								 "%s.lib%s.python%s" % (name, tmpbits, pycompat)])
	elif sys.platform == "darwin":
		# On Mac OS X we only want the universal binaries
		packages.append("%s.lib%s" % (name, bits))
	else:
		# On Linux/Windows we want separate libraries
		packages.extend(["%s.lib%s" % (name, bits),
						 "%s.lib%s.python%s%s" % ((name, bits) + sys.version_info[:2])])
		

	attrs = {
		"author": author_ascii,
		"author_email": author_email,
		"classifiers": [
			"Development Status :: 5 - Production/Stable",
			"Environment :: MacOS X",
			"Environment :: Win32 (MS Windows)",
			"Environment :: X11 Applications",
			"Intended Audience :: End Users/Desktop",
			"License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)",
			"Operating System :: OS Independent",
			"Programming Language :: Python :: 2.6",
			"Programming Language :: Python :: 2.7",
			"Topic :: Multimedia :: Graphics",
		],
		"data_files": data_files,
		"description": description,
		"download_url": "https://%(domain)s/download/"
						"%(name)s-%(version)s.tar.gz" % 
						{"domain": domain, "name": name, "version": version},
		"ext_modules": ext_modules,
		"license": "GPL v3",
		"long_description": longdesc,
		"name": name,
		"packages": packages,
		"package_data": package_data,
		"package_dir": {
			name: name
		},
		"platforms": [
			"Python >= %s <= %s" % (".".join(str(n) for n in py_minversion),
									".".join(str(n) for n in py_maxversion)), 
			"Linux/Unix with X11", 
			"Mac OS X >= 10.4", 
			"Windows 2000 and newer"
		],
		"requires": requires,
		"provides": [name],
		"scripts": [],
		"url": "https://%s/" % domain,
		"version": msiversion if "bdist_msi" in sys.argv[1:] else version
	}

	if setuptools:
		attrs["entry_points"] = {
			"gui_scripts": [
				"%s = %s.main:main%s" % (script, name,
					"" if script == name.lower()
					else script[len(name):].lower().replace("-", "_"))
				for script, desc in scripts
			]
		}
		attrs["exclude_package_data"] = {
			name: ["RealDisplaySizeMM.c"]
		}
		attrs["include_package_data"] = sys.platform in ("darwin", "win32")
		install_requires = [req.replace("(", "").replace(")", "") for req in 
							requires]
		attrs["install_requires"] = install_requires
		attrs["zip_safe"] = False
	else:
		attrs["scripts"].extend(os.path.join("scripts", script)
								for script, desc in
								filter(lambda (script, desc):
									   script != name.lower() + "-apply-profiles" or
									   sys.platform != "darwin",
									   scripts))
	
	if bdist_bbfreeze:
		attrs["setup_requires"] = ["bbfreeze"]

	if "bdist_wininst" in sys.argv[1:]:
		attrs["scripts"].append(os.path.join("util", name + "_postinstall.py"))
		
	if do_py2app:
		mainpy = os.path.join(basedir, "main.py")
		if not os.path.exists(mainpy):
			shutil.copy(os.path.join(basedir, "scripts", name.lower()), mainpy)
		attrs["app"] = [mainpy]
		dist_dir = os.path.join(pydir, "..", "dist", 
								"py2app.%s-py%s" % (get_platform(), 
													sys.version[:3]), 
								name + "-" + version)
		from py2app.build_app import py2app as py2app_cls
		py2app_cls._copy_package_data = py2app_cls.copy_package_data
		def copy_package_data(self, package, target_dir):
			# Skip package data which is already included as data files
			if package.identifier.split('.')[0] != name:
				self._copy_package_data(package, target_dir)
		py2app_cls.copy_package_data = copy_package_data
		attrs["options"] = {
			"py2app": {
				"argv_emulation": True,
				"dist_dir": dist_dir,
				"excludes": config["excludes"]["all"] +
							config["excludes"]["darwin"],
				"iconfile": os.path.join(pydir, "theme", "icons", 
										 name + ".icns"),
				"optimize": 0,
				"plist": plist_dict
			}
		}
		attrs["setup_requires"] = ["py2app"]

	if do_py2exe:
		import wx
		from winmanifest_util import getmanifestxml
		manifest_xml = getmanifestxml(os.path.join(pydir, "..", "misc", 
			name + (".exe.VC90.manifest" if hasattr(sys, "version_info") and 
			sys.version_info[:2] >= (2,6) else ".exe.manifest")))
		tmp_scripts_dir = os.path.join(basedir, "build", "temp.scripts")
		if not os.path.isdir(tmp_scripts_dir):
			os.makedirs(tmp_scripts_dir)
		apply_profiles_launcher = (appname.lower() + "-apply-profiles-launcher",
								   appname + " Profile Loader Launcher")
		for script, desc in scripts + [apply_profiles_launcher]:
			shutil.copy(os.path.join(basedir, "scripts", script),
						os.path.join(tmp_scripts_dir, script2pywname(script)))
		attrs["windows"] = [Target(**{
			"script": os.path.join(tmp_scripts_dir, script2pywname(script)),
			"icon_resources": [(1, os.path.join(pydir, "theme", "icons", 
												os.path.splitext(os.path.basename(script))[0] +
												".ico"))],
			"other_resources": [(24, 1, manifest_xml)],
			"copyright": u"© %s %s" % (strftime("%Y"), author),
			"description": desc
		}) for script, desc in scripts]
		# Add profile loader launcher
		attrs["windows"].append(Target(**{
			"script": os.path.join(tmp_scripts_dir,
								   script2pywname(apply_profiles_launcher[0])),
			"icon_resources": [(1, os.path.join(pydir, "theme", "icons", 
												appname.lower() + "-apply-profiles" +
												".ico"))],
			"other_resources": [(24, 1, manifest_xml)],
			"copyright": u"© %s %s" % (strftime("%Y"), author),
			"description": apply_profiles_launcher[1]
		}))
		console_scripts = [name + "-VRML-to-X3D-converter"]
		for console_script in console_scripts:
			console_script_path = os.path.join(tmp_scripts_dir,
											   console_script + "-console")
			if not os.path.isfile(console_script_path):
				shutil.copy(os.path.join(basedir, "scripts",
										 console_script.lower()),
							console_script_path)
		attrs["console"] = [Target(**{
			"script": os.path.join(tmp_scripts_dir,
								   script2pywname(script) + "-console"),
			"icon_resources": [(1, os.path.join(pydir, "theme", "icons", 
												os.path.splitext(os.path.basename(script))[0] +
												".ico"))],
			"other_resources": [(24, 1, manifest_xml)],
			"copyright": u"© %s %s" % (strftime("%Y"), author),
			"description": desc
		}) for script, desc in filter(lambda (script, desc):
									  script2pywname(script) in console_scripts,
									  scripts)]
		dist_dir = os.path.join(pydir, "..", "dist", "py2exe.%s-py%s" % 
								(get_platform(), sys.version[:3]), name + 
								"-" + version)
		attrs["options"] = {
			"py2exe": {
				"dist_dir": dist_dir,
				"dll_excludes": [
					"iertutil.dll", 
					"MPR.dll",
					"msvcm90.dll", 
					"msvcp90.dll", 
					"msvcr90.dll", 
					"mswsock.dll",
					"urlmon.dll",
					"w9xpopen.exe"
				],
				"excludes": config["excludes"]["all"] +
							config["excludes"]["win32"], 
				"bundle_files": 3 if wx.VERSION >= (2, 8, 10, 1) else 1,
				"compressed": 1,
				"optimize": 0  # 0 = don’t optimize (generate .pyc)
							   # 1 = normal optimization (like python -O) 
							   # 2 = extra optimization (like python -OO)
			}
		}
		if debug:
			attrs["options"]["py2exe"].update({
				"bundle_files": 3,
				"compressed": 0,
				"optimize": 0,
				"skip_archive": 1
			})
		if setuptools:
			attrs["setup_requires"] = ["py2exe"]
		attrs["zipfile"] = os.path.join("lib", "library.zip")

	if (do_uninstall or do_install or bdist_win or bdist_dumb) and not help:
		distutils.core._setup_stop_after = "commandline"
		dist = setup(**attrs)
		distutils.core._setup_stop_after = None
		cmd = install(dist).get_finalized_command("install")
		if debug > 0:
			for attrname in [
				"base", 
				"data", 
				"headers", 
				"lib", 
				"libbase", 
				"platbase", 
				"platlib", 
				"prefix", 
				"purelib", 
				"root", 
				"scripts", 
				"userbase"
			]:
				if attrname not in ["prefix", "root"]:
					attrname = "install_" + attrname
				if hasattr(cmd, attrname):
					print attrname, getattr(cmd, attrname)
		if debug > 1:
			try:
				from ppdir import ppdir
			except ImportError:
				pass
			else:
				ppdir(cmd, types=[dict, list, str, tuple, type, unicode])
		if not install_data and sys.platform in ("darwin", "win32"):
			# on Mac OS X and Windows, we want data files in the package dir
			data_basedir = cmd.install_lib
		else:
			data_basedir = cmd.install_data
		data = change_root(data_basedir, data)
		doc = change_root(data_basedir, doc)
		# determine in which cases we want to make data file paths relative to 
		# site-packages (on Mac and Windows) and when we want to make them 
		# absolute (Linux)
		linux = sys.platform not in ("darwin", "win32") and (not cmd.root and 
															 setuptools)
		dar_win = (sys.platform in ("darwin", "win32") and 
				   (cmd.root or not setuptools)) or bdist_win
		if not do_uninstall and not install_data and (linux or dar_win) and \
		   attrs["data_files"]:
			if data_basedir.startswith(cmd.install_data + os.path.sep):
				data_basedir = relpath(data_basedir, cmd.install_data)
			print "*** changing basedir for data_files:", data_basedir
			for i, f in enumerate(attrs["data_files"]):
				if type(f) is StringType:
					attrs["data_files"][i] = change_root(data_basedir, f)
				else:
					attrs["data_files"][i] = (change_root(data_basedir, f[0]), 
											  f[1])

	if do_uninstall and not help:

		# Quick and dirty uninstall

		if dry_run:
			print "dry run - nothing will be removed"
		else:
			from postinstall import postuninstall
			# Yeah, yeah - its actually pre-uninstall
			if cmd.root:
				postuninstall(prefix=change_root(cmd.root, cmd.prefix))
			else:
				postuninstall(prefix=cmd.prefix)

		removed = []
		visited = []

		if os.path.exists(recordfile_name):
			paths = [(change_root(cmd.root, line.rstrip("\n")) if cmd.root else 
				line.rstrip("\n")) for line in open(recordfile_name, "r")]
		else:
			paths = []
		if not paths:
			# If the installed files have not been recorded, use some fallback 
			# logic to find them
			paths = glob.glob(os.path.join(cmd.install_scripts, name))
			if sys.platform == "win32":
				if setuptools:
					paths += glob.glob(os.path.join(cmd.install_scripts, 
													name + ".exe"))
					paths += glob.glob(os.path.join(cmd.install_scripts, 
													name + "-script.py"))
				else:
					paths += glob.glob(os.path.join(cmd.install_scripts, 
													name + ".cmd"))
			paths += glob.glob(os.path.join(cmd.install_scripts, name + 
											"_postinstall.py"))
			for attrname in [
				"data", 
				"headers", 
				"lib", 
				"libbase", 
				"platlib", 
				"purelib"
			]:
				path = os.path.join(getattr(cmd, "install_" + attrname), name)
				if not path in paths:
					# Using sys.version in this way is consistent with 
					# setuptools
					paths += glob.glob(path) + glob.glob(path + 
						("-%(version)s-py%(pyversion)s*.egg" % {
							"version": version, 
							"pyversion": sys.version[:3]
						})
					) + glob.glob(path + 
						("-%(version)s-py%(pyversion)s*.egg-info" % {
							"version": version, 
							"pyversion": sys.version[:3]
						})
					)
			if os.path.isabs(data) and not data in paths:
				for fname in [
					"lang",
					"presets",
					"ref",
					"report",
					"screenshots",
					"tests",
					"theme",
					"ti1",
					"x3d-viewer",
					"LICENSE.txt",
					"README.html",
					"README-fr.html",
					"argyll_instruments.json",
					"beep.wav",
					"camera_shutter.wav",
					"ColorLookupTable.fx",
					name.lower() + ".desktop",
					name.lower() + "-3dlut-maker.desktop",
					name.lower() + "-curve-viewer.desktop",
					name.lower() + "-profile-info.desktop",
					name.lower() + "-scripting-client.desktop",
					name.lower() + "-synthprofile.desktop",
					name.lower() + "-testchart-editor.desktop",
					"pnp.ids",
					"quirk.json",
					"linear.cal",
					"technology_strings-1.7.0.json",
					"technology_strings-1.7.1.json",
					"test.cal"
				]:
					path = os.path.join(data, fname)
					if not path in paths:
						paths += glob.glob(path)
			if os.path.isabs(doc) and not doc in paths:
				for fname in [
					"screenshots",
					"theme",
					"LICENSE.txt",
					"README.html",
					"README-fr.html"
				]:
					path = os.path.join(doc, fname)
					if not path in paths:
						paths += glob.glob(path)
			if sys.platform == "win32":
				from postinstall import get_special_folder_path
				startmenu_programs_common = get_special_folder_path(
					"CSIDL_COMMON_PROGRAMS")
				startmenu_programs = get_special_folder_path("CSIDL_PROGRAMS")
				for path in (startmenu_programs_common, startmenu_programs):
					if path:
						for filename in (name, "LICENSE", "README", 
										 "Uninstall"):
							paths += glob.glob(os.path.join(path, name, 
															filename + ".lnk"))

		for path in paths:
			if os.path.exists(path):
				if path in visited:
					continue
				else:
					visited.append(path)
				if dry_run:
					print path
					continue
				try:
					if os.path.isfile(path):
						os.remove(path)
					elif os.path.isdir(path):
						os.rmdir(path)
				except Exception, exception:
					print "could'nt remove", path
					print "   ", exception
				else:
					print "removed", path
					removed.append(path)
			while path != os.path.dirname(path):
				# remove parent directories if empty
				# could also use os.removedirs(path) but we want some status 
				# info
				path = os.path.dirname(path)
				if os.path.isdir(path):
					if len(os.listdir(path)) == 0:
						if path in visited:
							continue
						else:
							visited.append(path)
						if dry_run:
							print path
							continue
						try:
							os.rmdir(path)
						except Exception, exception:
							print "could'nt remove", path
							print "   ", exception
						else:
							print "removed", path
							removed.append(path)
					else:
						break

		if not removed:
			print len(visited), "entries found"
		else:
			print len(removed), "entries removed"

	else:

		# To have a working sdist and bdist_rpm when using distutils,
		# we go to the length of generating MANIFEST.in from scratch everytime, 
		# using the information available from setup.
		manifest_in = ["# This file will be re-generated by setup.py - do not"
					   "edit"]
		manifest_in.extend(["include LICENSE.txt", "include MANIFEST", 
							"include MANIFEST.in", "include README.html", 
							"include README-fr.html",
							"include *.pyw", "include use-distutils"])
		manifest_in.append("include " + os.path.basename(sys.argv[0]))
		manifest_in.append("include " + 
						   os.path.splitext(os.path.basename(sys.argv[0]))[0] + 
						   ".cfg")
		for datadir, datafiles in attrs.get("data_files", []):
			for datafile in datafiles:
				manifest_in.append("include " + (
								   relpath(os.path.sep.join(datafile.split("/")), 
										   basedir) or datafile))
		for extmod in attrs.get("ext_modules", []):
			manifest_in.extend("include " + os.path.sep.join(src.split("/")) 
							   for src in extmod.sources)
		for pkg in attrs.get("packages", []):
			pkg = os.path.join(*pkg.split("."))
			pkgdir = os.path.sep.join(attrs.get("package_dir", 
												{}).get(pkg, pkg).split("/"))
			manifest_in.append("include " + os.path.join(pkgdir, "*.py"))
			manifest_in.append("include " + os.path.join(pkgdir, "*.pyd"))
			manifest_in.append("include " + os.path.join(pkgdir, "*.so"))
			for obj in attrs.get("package_data", {}).get(pkg, []):
				manifest_in.append("include " + os.path.sep.join([pkgdir] + 
																 obj.split("/")))
		for pymod in attrs.get("py_modules", []):
			manifest_in.append("include " + os.path.join(*pymod.split(".")))
		manifest_in.append("include " + 
						   os.path.join(name, "theme", "theme-info.txt"))
		manifest_in.append("recursive-include %s %s %s" % 
						   (os.path.join(name, "theme", "icons"), 
						   "*.icns", "*.ico"))
		manifest_in.append("recursive-include %s %s" % ("autopackage", "*"))
		manifest_in.append("include " + os.path.join("man", "*.1"))
		manifest_in.append("recursive-include %s %s" % ("misc", "*"))
		if skip_instrument_conf_files:
			manifest_in.extend([
				"exclude misc/Argyll",
				"exclude misc/*.rules",
				"exclude misc/*.usermap",
			])
		manifest_in.append("include " + os.path.join("screenshots", "*.png"))
		manifest_in.append("include " + os.path.join("scripts", "*"))
		manifest_in.append("include " + os.path.join("tests", "*"))
		manifest_in.append("recursive-include %s %s" % ("theme", "*"))
		manifest_in.append("recursive-include %s %s" % ("util", 
														"*.cmd *.py *.sh"))
		if sys.platform == "win32" and not setuptools:
			# Only needed under Windows
			manifest_in.append("global-exclude .svn/*")
		manifest_in.append("global-exclude *~")
		manifest_in.append("global-exclude *.backup")
		manifest_in.append("global-exclude *.bak")
		if not dry_run:
			manifest = open("MANIFEST.in", "w")
			manifest.write("\n".join(manifest_in))
			manifest.close()
			if os.path.exists("MANIFEST"):
				os.remove("MANIFEST")

		if bdist_bbfreeze:
			i = sys.argv.index("bdist_bbfreeze")
			if not "-d" in sys.argv[i + 1:] and \
			   not "--dist-dir" in sys.argv[i + 1:]:
				dist_dir = os.path.join(pydir, "..", "dist", 
										"bbfreeze.%s-py%s" % (get_platform(), 
															  sys.version[:3]))
				sys.argv.insert(i + 1, "--dist-dir=" + dist_dir)
			if not "egg_info" in sys.argv[1:i]:
				sys.argv.insert(i, "egg_info")

		if do_py2app or do_py2exe:
			sys.path.insert(1, pydir)
			i = sys.argv.index("py2app" if do_py2app else "py2exe")
			if not "build_ext" in sys.argv[1:i]:
				sys.argv.insert(i, "build_ext")

		setup(**attrs)
		
		if dry_run or help:
			return
		
		if do_py2app:
			create_app_symlinks(dist_dir, scripts)
		
		if do_py2exe:
			shutil.copy(os.path.join(dist_dir, "python%s.dll" %
											   (sys.version[0] + sys.version[2])),
						os.path.join(dist_dir, "lib", "python%s.dll" %
											   (sys.version[0] + sys.version[2])))

		if ((bdist_bbfreeze and sys.platform == "win32") or do_py2exe) and \
		   sys.version_info[:2] >= (2,6):
			from vc90crt import name as vc90crt_name, vc90crt_copy_files
			if do_py2exe:
				vc90crt_copy_files(dist_dir)
				vc90crt_copy_files(os.path.join(dist_dir, 
												"lib"))
			else:
				vc90crt_copy_files(os.path.join(dist_dir, 
												name + "-" + version))
		
		if do_full_install and not is_rpm_build and not skip_postinstall:
			from postinstall import postinstall
			if sys.platform == "win32":
				path = os.path.join(cmd.install_lib, name)
				# Using sys.version in this way is consistent with setuptools
				for path in glob.glob(path) + glob.glob(
					os.path.join(path + (
						"-%(version)s-py%(pyversion)s*.egg" % 
						{
							"version": version, 
							"pyversion": sys.version[:3]
						}
					), name)
				):
					if cmd.root:
						postinstall(prefix=change_root(cmd.root, path))
					else:
						postinstall(prefix=path)
						
			elif cmd.root:
				postinstall(prefix=change_root(cmd.root, cmd.prefix))
			else:
				postinstall(prefix=cmd.prefix)

if __name__ == "__main__":
	setup()
