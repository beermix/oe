# -*- coding: utf-8 -*-

"""
DisplayCAL

A graphical user interface for the Argyll CMS display calibration utilities

Copyright (C) 2008, 2009 Florian Hoech

This program is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation; either version 3 of the License, or (at your 
option) any later version.

This program is distributed in the hope that it will be useful, but 
WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
General Public License for more details.

You should have received a copy of the GNU General Public License along 
with this program; if not, see <http://www.gnu.org/licenses/>
"""

from __future__ import with_statement
import sys

# Standard modules

import datetime
import decimal
Decimal = decimal.Decimal
import glob
import math
import os
import platform
if sys.platform == "darwin":
	from platform import mac_ver
import re
import shutil
import socket
import subprocess as sp
import threading
import traceback
import urllib2
import zipfile
if sys.platform == "win32":
	import _winreg
from hashlib import md5
from time import gmtime, localtime, sleep, strftime, strptime, struct_time
from zlib import crc32

# 3rd party modules

import demjson

# Config
import config
from config import (appbasename, autostart, autostart_home, build, 
					script_ext, defaults, enc, 
					exe, exe_ext, fs_enc, getbitmap, geticon, 
					get_ccxx_testchart, get_current_profile,
					get_display_profile, get_data_path, getcfg,
					get_total_patches,
					get_verified_path, hascfg, is_ccxx_testchart, is_profile,
					initcfg, isapp, isexe, profile_ext,
					pydir, resfiles, setcfg,
					writecfg)

# Custom modules

import CGATS
import ICCProfile as ICCP
import audio
import ccmx
import colord
import colormath
import localization as lang
import madvr
import pyi_md5pickuphelper
import report
if sys.platform == "win32":
	import util_win
import wexpect
from argyll_cgats import (cal_to_fake_profile, can_update_cal, 
						  ti3_to_ti1, vcgt_to_cal,
						  verify_ti1_rgb_xyz)
from argyll_instruments import (get_canonical_instrument_name, instruments)
from argyll_names import viewconds
from colormath import (CIEDCCT2xyY, planckianCT2xyY, xyY2CCT, XYZ2CCT, XYZ2Lab, 
					   XYZ2xyY)
from debughelpers import ResourceError, getevtobjname, getevttype, handle_error
from edid import pnpidcache, get_manufacturer_name
from log import log, logbuffer, safe_print
from meta import (VERSION, VERSION_BASE, author, name as appname, domain,
				  version, version_short)
from options import debug, test, verbose
from ordereddict import OrderedDict
from trash import trash, TrashAborted, TrashcanUnavailableError
from util_decimal import float2dec, stripzeros
from util_io import StringIOu as StringIO, TarFileProper
from util_list import index_fallback_ignorecase, intlist, natsort
from util_os import (expanduseru, get_program_file, getenvu, is_superuser,
					 launch_file, listdir_re, waccess, whereis, which)
from util_str import (ellipsis, make_filename_safe, safe_str, safe_unicode,
					  strtr, universal_newlines, wrap)
import util_x
from worker import (Error, Info, UnloggedError, UnloggedInfo, UnloggedWarning,
					Warn, Worker, check_create_dir, check_file_isfile,
					check_set_argyll_bin, check_ti3, check_ti3_criteria1,
					check_ti3_criteria2, get_arg, get_argyll_util,
					get_cfg_option_from_args, get_options_from_cal,
					get_argyll_version, get_current_profile_path,
					get_options_from_profile, get_options_from_ti3,
					make_argyll_compatible_path,
					parse_argument_string, set_argyll_bin, show_result_dialog,
					technology_strings_170, technology_strings_171,
					check_argyll_bin, http_request)
from wxLUT3DFrame import LUT3DFrame
try:
	from wxLUTViewer import LUTFrame
except ImportError:
	LUTFrame = None
if sys.platform in ("darwin", "win32") or isexe:
	from wxMeasureFrame import MeasureFrame
from wxDisplayUniformityFrame import DisplayUniformityFrame
from wxProfileInfo import ProfileInfoFrame
from wxReportFrame import ReportFrame
from wxSynthICCFrame import SynthICCFrame
from wxTestchartEditor import TestchartEditor
from wxVisualWhitepointEditor import VisualWhitepointEditor
from wxaddons import (wx, BetterWindowDisabler, CustomEvent,
					  CustomGridCellEvent)
from wxfixes import (ThemedGenButton, BitmapWithThemedButton, PlateButton,
					 set_bitmap_labels, TempXmlResource, wx_Panel)
from wxwindows import (AboutDialog, AuiBetterTabArt, BaseApp, BaseFrame,
					   BetterStaticFancyText, BetterLinkCtrl, BorderGradientButton,
					   BitmapBackgroundPanel, BitmapBackgroundPanelText,
					   ConfirmDialog, CustomGrid, CustomCellBoolRenderer,
					   FileDrop, HyperLinkCtrl, InfoDialog,
					   LogWindow, ProgressDialog, TooltipWindow,
					   get_gradient_panel)
import floatspin
import xh_fancytext
import xh_filebrowsebutton
import xh_floatspin
import xh_hstretchstatbmp
import xh_bitmapctrls

# wxPython
try:
	# Only wx.lib.aui.AuiNotebook looks reasonable across _all_ platforms.
	# Other tabbed book controls like wx.Notebook or wx.aui.AuiNotebook are
	# impossible to get to look right under GTK because there's no way to
	# set the correct background color for the pages.
	from wx.lib.agw import aui
except ImportError:
	# Fall back to wx.aui under ancient wxPython versions
	from wx import aui
from wx import xrc
from wx.lib import delayedresult, platebtn
from wx.lib.art import flagart
from wx.lib.scrolledpanel import ScrolledPanel
import wx.html


def swap_dict_keys_values(mydict):
	""" Swap dictionary keys and values """
	return dict([(v, k) for (k, v) in mydict.iteritems()])


def app_update_check(parent=None, silent=False, snapshot=False, argyll=False):
	""" Check for application update. Show an error dialog if a failure
	occurs. """
	if argyll:
		if parent and hasattr(parent, "worker"):
			argyll_version = parent.worker.argyll_version
		else:
			argyll_version = intlist(getcfg("argyll.version").split("."))
		curversion_tuple = tuple(argyll_version)
		version_file = "Argyll/VERSION"
		readme_file = "Argyll/ChangesSummary.html"
	elif snapshot:
		# Snapshot
		curversion_tuple = VERSION
		version_file = "SNAPSHOT_VERSION"
		readme_file = "SNAPSHOT_README.html"
	else:
		# Stable
		safe_print(lang.getstr("update_check"))
		curversion_tuple = VERSION_BASE
		version_file = "VERSION"
		readme_file = "README.html"
	resp = http_request(parent, domain, "GET", "/" + version_file,
						failure_msg=lang.getstr("update_check.fail"),
						silent=silent)
	if resp is False:
		if silent:
			# Check if we need to run instrument setup
			wx.CallAfter(parent.check_instrument_setup, check_donation,
						 (parent, snapshot))
		return
	data = resp.read()
	if not wx.GetApp():
		return
	try:
		newversion_tuple = tuple(int(n) for n in data.split("."))
	except ValueError:
		safe_print(lang.getstr("update_check.fail.version", domain))
		if not silent:
			wx.CallAfter(InfoDialog, parent, 
						 msg=lang.getstr("update_check.fail.version",
										 domain),
						 ok=lang.getstr("ok"), 
						 bitmap=geticon(32, "dialog-error"), log=False)
			return
		newversion_tuple = (0, 0, 0, 0)
	if newversion_tuple > curversion_tuple:
		# Get changelog
		resp = http_request(parent, domain, "GET", "/" + readme_file,
							silent=True)
		chglog = None
		if resp:
			readme = safe_unicode(resp.read(), "utf-8")
			if argyll:
				chglog = readme
			else:
				chglog = re.search('<div id="(?:changelog|history)">'
								   '.+?<h2>.+?</h2>'
								   '.+?<dl>.+?</dd>', readme, re.S)
				if chglog:
					chglog = chglog.group()
					chglog = re.sub('<div id="(?:changelog|history)">', "", chglog)
					chglog = re.sub("<\/?d[l|d]>", "", chglog)
					chglog = re.sub("<(?:h2|dt)>.+?</(?:h2|dt)>", "", chglog)
					chglog = re.sub("<h3>.+?</h3>", "", chglog)
			if chglog:
				chglog = re.sub(re.compile(r"<h\d>(.+?)</h\d>",
										   flags=re.I | re.S),
								r"<p><strong>\1</strong></p>", chglog)
				chglog = re.sub(re.compile('href="(#[^"]+)"', flags=re.I),
								r'href="https://%s/\1"' % domain, chglog)
		if not wx.GetApp():
			return
		wx.CallAfter(app_update_confirm, parent, newversion_tuple, chglog,
					 snapshot, argyll, silent)
	elif not argyll and not snapshot and VERSION > VERSION_BASE:
		app_update_check(parent, silent, True)
	elif not argyll:
		if silent:
			safe_print(lang.getstr("update_check.uptodate", appname))
		if check_argyll_bin():
			app_update_check(parent, silent, argyll=True)
		elif silent:
			wx.CallAfter(parent.set_argyll_bin_handler, True, silent,
						 parent.check_instrument_setup, (check_donation,
														 (parent, snapshot)))
		else:
			wx.CallAfter(parent.set_argyll_bin_handler, True)
	elif not silent:
		wx.CallAfter(app_uptodate, parent)
	else:
		safe_print(lang.getstr("update_check.uptodate", "Argyll CMS"))
		# Check if we need to run instrument setup
		wx.CallAfter(parent.check_instrument_setup, check_donation,
					 (parent, snapshot))


def check_donation(parent, snapshot):
	# Show donation popup if user did not choose "don't show again".
	# Reset donation popup after a major update.
	if (not snapshot and
		VERSION[0] > tuple(intlist(getcfg("last_launch").split(".")))[0]):
		setcfg("show_donation_message", 1)
	setcfg("last_launch", version)
	if getcfg("show_donation_message"):
		wx.CallAfter(donation_message, parent)


def app_uptodate(parent=None):
	""" Show a dialog confirming application is up-to-date """
	dlg = InfoDialog(parent, 
					 msg=lang.getstr("update_check.uptodate",
									 appname),
					 ok=lang.getstr("ok"), 
					 bitmap=geticon(32, "dialog-information"), show=False)
	update_check = wx.CheckBox(dlg, -1, 
							   lang.getstr("update_check.onstartup"))
	update_check.SetValue(getcfg("update_check"))
	dlg.Bind(wx.EVT_CHECKBOX, lambda event: setcfg("update_check", 
												   int(event.IsChecked())), 
			 id=update_check.GetId())
	dlg.sizer3.Add(update_check, flag=wx.TOP | wx.ALIGN_LEFT, border=12)
	dlg.sizer0.SetSizeHints(dlg)
	dlg.sizer0.Layout()
	dlg.ShowModalThenDestroy()
	if parent and getattr(parent, "menuitem_app_auto_update_check", None):
		parent.menuitem_app_auto_update_check.Check(bool(getcfg("update_check")))


def app_update_confirm(parent=None, newversion_tuple=(0, 0, 0, 0), chglog=None,
					   snapshot=False, argyll=False, silent=False):
	""" Show a dialog confirming application update, with cancel option """
	zeroinstall = (not argyll and
				   os.path.exists(os.path.normpath(os.path.join(pydir, "..",
																appname +
																".pyw"))) and
				   re.match("sha\d+(?:new)?",
							os.path.basename(os.path.dirname(pydir))) and
				   (which("0install-win.exe") or which("0install")))
	download = argyll and not check_argyll_bin()
	if zeroinstall or sys.platform in ("darwin", "win32") or argyll:
		ok = lang.getstr("download" if download else "update_now")
		alt = lang.getstr("go_to_website")
	else:
		ok = lang.getstr("go_to_website")
		alt = None
	newversion = ".".join(str(n) for n in newversion_tuple)
	if argyll:
		newversion_desc = "Argyll CMS"
	else:
		newversion_desc = appname
	newversion_desc += " " + newversion
	if snapshot:
		newversion_desc += " Beta"
	if download:
		msg = lang.getstr("download") + " " + newversion_desc
	else:
		msg = lang.getstr("update_check.new_version", newversion_desc)
	dlg = ConfirmDialog(parent,
						msg=msg, 
						ok=ok, alt=alt,
						cancel=lang.getstr("cancel"), 
						bitmap=geticon(32, "dialog-information"), 
						log=True)
	scale = getcfg("app.dpi") / config.get_default_dpi()
	if scale < 1:
		scale = 1
	if (argyll and sys.platform not in ("darwin", "win32") and
		not whereis("libXss.so")):
		sizer = wx.BoxSizer(wx.HORIZONTAL)
		dlg.sizer3.Insert(0, sizer, flag=wx.BOTTOM | wx.ALIGN_LEFT,
						  border=12)
		sizer.Add(wx.StaticBitmap(dlg, -1, geticon(16, "dialog-warning")))
		warning_text = lang.getstr("library.not_found.warning",
								   (lang.getstr("libXss.so"), "libXss.so"))
		warning = wx.StaticText(dlg, -1, warning_text)
		warning.ForegroundColour = "#F07F00"
		sizer.Add(warning, flag=wx.LEFT, border=8)
		warning.Wrap((500 - 16 - 8) * scale)
	if chglog:
		htmlwnd = wx.html.HtmlWindow(dlg, -1, size=(500 * scale, 300 * scale),
									 style=wx.BORDER_THEME)
		if "gtk3" in wx.PlatformInfo:
			size = int(round(dlg.message.Font.PointSize * scale))
		else:
			size = -1
		htmlwnd.SetStandardFonts(size)
		htmlwnd.SetPage(chglog)
		htmlwnd.Bind(wx.html.EVT_HTML_LINK_CLICKED,
					 lambda event: launch_file(event.GetLinkInfo().Href))
		dlg.sizer3.Add(htmlwnd, 1, flag=wx.TOP | wx.ALIGN_LEFT | wx.EXPAND, border=12)
	update_check = wx.CheckBox(dlg, -1, 
							   lang.getstr("update_check.onstartup"))
	update_check.SetValue(getcfg("update_check"))
	dlg.Bind(wx.EVT_CHECKBOX, lambda event: setcfg("update_check", 
												   int(event.IsChecked())), 
			 id=update_check.GetId())
	dlg.sizer3.Add(update_check, flag=wx.TOP | wx.ALIGN_LEFT, border=12)
	dlg.sizer0.SetSizeHints(dlg)
	dlg.sizer0.Layout()
	dlg.Center()
	result = dlg.ShowModal()
	dlg.Destroy()
	if parent and getattr(parent, "menuitem_app_auto_update_check", None):
		parent.menuitem_app_auto_update_check.Check(bool(getcfg("update_check")))
	if result == wx.ID_OK and (zeroinstall or
							   (sys.platform in ("darwin", "win32")
							    or argyll)):
		if parent and hasattr(parent, "worker"):
			worker = parent.worker
		else:
			worker = Worker()
		if snapshot:
			# Snapshot
			folder = "/snapshot"
		else:
			# Stable
			folder = ""
		if zeroinstall:
			if parent:
				parent.Close()
			else:
				wx.GetApp().ExitMainLoop()
			if sys.platform == "win32":
				kwargs = dict(stdin=sp.PIPE, stdout=sp.PIPE, stderr=sp.PIPE)
			else:
				kwargs = {}
			sp.Popen([zeroinstall.encode(fs_enc), "run", "--refresh",
					  "--version", newversion, "http://%s/0install/%s.xml" %
												  (domain.lower(), appname)],
					 **kwargs)
		else:
			consumer = worker.process_download
			dlname = appname
			if argyll:
				consumer = worker.process_argyll_download
				dlname = "Argyll"
				if sys.platform == "win32":
					# Determine 32 or 64 bit OS
					key = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE,
										  r"SYSTEM\CurrentControlSet\Control"
										  r"\Session Manager\Environment")
					try:
						value = _winreg.QueryValueEx(key,
													 "PROCESSOR_ARCHITECTURE")[0]
					except WindowsError:
						value = "x86"
					finally:
						_winreg.CloseKey(key)
					if value.lower() == "amd64":
						suffix = "_win64_exe.zip"
					else:
						# Assume win32
						suffix = "_win32_exe.zip"
				elif sys.platform == "darwin":
					# We only support OS X 10.5+
					suffix = "_osx10.6_x86_64_bin.tgz"
				else:
					# Linux
					if platform.architecture()[0] == "64bit":
						# Assume x86_64
						suffix = "_linux_x86_64_bin.tgz"
					else:
						# Assume x86
						suffix = "_linux_x86_bin.tgz"
			elif sys.platform == "win32":
				if snapshot:
					# Snapshots are only avaialble as ZIP
					suffix = "-win32.zip"
				else:
					# Regular stable versions are available as setup
					suffix = "-Setup.exe"
			else:
				suffix = ".dmg"
			worker.start(consumer, worker.download,
						 ckwargs={"exit": dlname == appname},
						 wargs=("http://%s/download%s/%s-%s%s" %
								(domain.lower(), folder, dlname, newversion,
								 suffix),),
						 progress_msg=lang.getstr("downloading"),
						 fancy=False)
		return
	elif result != wx.ID_CANCEL:
		path = "/"
		if argyll:
			path += "argyll"
			if sys.platform == "darwin":
				path += "-mac"
			elif sys.platform == "win32":
				path += "-win"
			else:
				# Linux
				path += "-linux"
		launch_file("https://" + domain + path)
	elif not argyll:
		# Check for Argyll update
		if check_argyll_bin():
			parent.app_update_check_handler(None, silent, True)
		elif silent:
			parent.set_argyll_bin_handler(True, silent,
										  parent.check_instrument_setup,
										  (check_donation, (parent, snapshot)))
		else:
			parent.set_argyll_bin_handler(True)
		return
	if silent:
		# Check if we need to run instrument setup
		parent.check_instrument_setup(check_donation, (parent, snapshot))


def donation_message(parent=None):
	""" Show donation message """
	dlg = ConfirmDialog(parent,
						title=lang.getstr("welcome"),
						msg=lang.getstr("donation_message"), 
						ok=lang.getstr("contribute"), 
						cancel=lang.getstr("not_now"), 
						bitmap=getbitmap("theme/headericon"),
						bitmap_margin=0)
	header = wx.StaticText(dlg, -1, lang.getstr("donation_header"))
	font = header.Font
	font.PointSize += 4
	header.SetFont(font)
	dlg.sizer3.Insert(0, header, flag=wx.BOTTOM | wx.EXPAND, border=14)
	if sys.platform == "win32":
		font = dlg.message.Font
		font.PointSize += 1
		dlg.message.SetFont(font)
	chkbox = wx.CheckBox(dlg.buttonpanel, -1, lang.getstr("dialog.do_not_show_again"))
	dlg.sizer2.Insert(0, chkbox, flag=wx.ALIGN_LEFT | wx.ALIGN_CENTER_VERTICAL |
									  wx.RIGHT,
					  border=max(dlg.sizer3.MinSize[0] - dlg.sizer2.MinSize[0] -
								 chkbox.Size[0], 12))
	dlg.sizer2.Insert(0, (88, -1))
	dlg.buttonpanel.Layout()
	dlg.sizer0.SetSizeHints(dlg)
	dlg.sizer0.Layout()
	if dlg.ShowModal() == wx.ID_OK:
		launch_file("https://" + domain + "/#donate")
		show_again = False
	else:
		show_again = not chkbox.Value
	setcfg("show_donation_message", int(show_again))
	dlg.Destroy()


def colorimeter_correction_web_check_choose(resp, parent=None):
	""" Let user choose a colorimeter correction and confirm overwrite """
	if resp is not False:
		data = resp.read()
		if data.strip().startswith("CC"):
			cgats = CGATS.CGATS(data)
		else:
			InfoDialog(parent, 
						 msg=lang.getstr("colorimeter_correction.web_check.failure"),
						 ok=lang.getstr("ok"), 
						 bitmap=geticon(32, "dialog-information"))
			return
	else:
		return
	dlg = ConfirmDialog(parent,
						title=lang.getstr("colorimeter_correction.web_check"),
						msg=lang.getstr("colorimeter_correction.web_check.choose"), 
						ok=lang.getstr("ok"), 
						cancel=lang.getstr("cancel"), 
						bitmap=geticon(32, "dialog-information"), nowrap=True)
	scale = getcfg("app.dpi") / config.get_default_dpi()
	if scale < 1:
		scale = 1
	dlg_list_ctrl = wx.ListCtrl(dlg, -1, size=(640 * scale, 150 * scale), style=wx.LC_REPORT | 
																wx.LC_SINGLE_SEL,
								name="colorimeter_corrections")
	dlg_list_ctrl.InsertColumn(0, lang.getstr("type"))
	dlg_list_ctrl.InsertColumn(1, lang.getstr("description"))
	dlg_list_ctrl.InsertColumn(2, lang.getstr("display.manufacturer"))
	dlg_list_ctrl.InsertColumn(3, lang.getstr("display"))
	dlg_list_ctrl.InsertColumn(4, lang.getstr("instrument"))
	dlg_list_ctrl.InsertColumn(5, lang.getstr("reference"))
	dlg_list_ctrl.InsertColumn(6, lang.getstr("observer"))
	dlg_list_ctrl.InsertColumn(7, lang.getstr("created"))
	dlg_list_ctrl.SetColumnWidth(0, 50)
	dlg_list_ctrl.SetColumnWidth(1, 250)
	dlg_list_ctrl.SetColumnWidth(2, 150)
	dlg_list_ctrl.SetColumnWidth(3, 100)
	dlg_list_ctrl.SetColumnWidth(4, 75)
	dlg_list_ctrl.SetColumnWidth(5, 75)
	dlg_list_ctrl.SetColumnWidth(6, 75)
	dlg_list_ctrl.SetColumnWidth(7, 150)
	types = {"CCSS": lang.getstr("spectral").replace(":", ""),
			 "CCMX": lang.getstr("matrix").replace(":", "")}
	for i in cgats:
		index = dlg_list_ctrl.InsertStringItem(i, "")
		ccxx_type = cgats[i].type.strip()
		dlg_list_ctrl.SetStringItem(index, 0, types.get(ccxx_type, ccxx_type))
		dlg_list_ctrl.SetStringItem(index, 1, get_canonical_instrument_name(cgats[i].queryv1("DESCRIPTOR") or ""))
		dlg_list_ctrl.SetStringItem(index, 2, cgats[i].queryv1("MANUFACTURER") or "")
		dlg_list_ctrl.SetStringItem(index, 3, cgats[i].queryv1("DISPLAY"))
		dlg_list_ctrl.SetStringItem(index, 4, get_canonical_instrument_name(cgats[i].queryv1("INSTRUMENT") or ""))
		dlg_list_ctrl.SetStringItem(index, 5, get_canonical_instrument_name(cgats[i].queryv1("REFERENCE") or ""))
		created = cgats[i].queryv1("CREATED")
		if created:
			try:
				created = strptime(created)
			except ValueError:
				datetmp = re.search("\w+ (\w{3}) (\d{2}) (\d{2}(?::[0-5][0-9]){2}) (\d{4})",
									created)
				if datetmp:
					datetmp = "%s-%s-%s %s" % (datetmp.groups()[3],
											   {"Jan": "01",
												"Feb": "02",
												"Mar": "03",
												"Apr": "04",
												"May": "05",
												"Jun": "06",
												"Jul": "07",
												"Aug": "08",
												"Sep": "09",
												"Oct": "10",
												"Nov": "11",
												"Dec": "12"}.get(datetmp.groups()[0]),
												datetmp.groups()[1],
												datetmp.groups()[2])
					try:
						created = strptime(datetmp, "%Y-%m-%d %H:%M:%S")
					except ValueError:
						pass
			if isinstance(created, struct_time):
				created = strftime("%Y-%m-%d %H:%M:%S", created)
		dlg_list_ctrl.SetStringItem(index, 6,
									parent.observers_ab.get(cgats[i].queryv1("REFERENCE_OBSERVER"),
															lang.getstr("unknown" if ccxx_type == "CCMX"
																		else "not_applicable")))
		dlg_list_ctrl.SetStringItem(index, 7, created or "")
	dlg.Bind(wx.EVT_LIST_ITEM_SELECTED, lambda event: dlg.ok.Enable(),
			 dlg_list_ctrl)
	dlg.Bind(wx.EVT_LIST_ITEM_DESELECTED, lambda event: dlg.ok.Disable(),
			 dlg_list_ctrl)
	dlg.Bind(wx.EVT_LIST_ITEM_ACTIVATED, lambda event: dlg.EndModal(wx.ID_OK),
			 dlg_list_ctrl)
	dlg.sizer3.Add(dlg_list_ctrl, 1, flag=wx.TOP | wx.ALIGN_LEFT, border=12)
	lstr = lang.getstr("colorimeter_correction.web_check.info")
	lstr_en = lang.getstr("colorimeter_correction.web_check.info", lcode="en")
	if lstr != lstr_en or lang.getcode() == "en":
		info_txt = wx.StaticText(dlg, -1, lstr)
		info_txt.Wrap(640 * scale)
		dlg.sizer3.Add(info_txt, 1, flag=wx.TOP | wx.ALIGN_LEFT, border=12)
	if len(cgats) > 1:
		# We got several matches
		dlg.ok.Disable()
	else:
		item = dlg_list_ctrl.GetItem(0)
		dlg_list_ctrl.SetItemState(item.GetId(), wx.LIST_STATE_SELECTED, 
								   wx.LIST_STATE_SELECTED)
	dlg.sizer0.SetSizeHints(dlg)
	dlg.sizer0.Layout()
	dlg.Center()
	result = dlg.ShowModal()
	index = dlg_list_ctrl.GetNextItem(-1, wx.LIST_NEXT_ALL, 
										  wx.LIST_STATE_SELECTED)
	dlg.Destroy()
	if result != wx.ID_OK:
		return False
	# Important: Do not use parsed CGATS, order of keywords may be 
	# different than raw data so MD5 will be different
	cgats = re.sub("\n(CCMX|CCSS)( *\n)", "\n<>\n\\1\\2", data).split("\n<>\n")
	colorimeter_correction_check_overwrite(parent, cgats[index])


def colorimeter_correction_check_overwrite(parent=None, cgats=None,
										   update_comports=False):
	""" Check if a colorimeter correction file will be overwritten and 
	present a dialog to confirm or cancel the operation. Write the file. """
	result = check_create_dir(config.get_argyll_data_dir())
	if isinstance(result, Exception):
		show_result_dialog(result, parent)
		return
	path = get_cgats_path(cgats)
	if os.path.isfile(path):
		dlg = ConfirmDialog(parent,
							msg=lang.getstr("dialog.confirm_overwrite", path), 
							ok=lang.getstr("ok"), 
							cancel=lang.getstr("cancel"), 
							bitmap=geticon(32, "dialog-information"))
		result = dlg.ShowModal()
		dlg.Destroy()
		if result != wx.ID_OK:
			return False
	try:
		cgatsfile = open(path, 'wb')
		cgatsfile.write(cgats)
		cgatsfile.close()
	except EnvironmentError, exception:
		show_result_dialog(exception, parent)
		return False
	if getcfg("colorimeter_correction_matrix_file").split(":")[0] != "AUTO":
		setcfg("colorimeter_correction_matrix_file", ":" + path)
	if update_comports:
		cgats = CGATS.CGATS(cgats)
		instrument = (cgats.queryv1("INSTRUMENT") or
					  getcfg("colorimeter_correction.instrument"))
		if instrument:
			instrument = get_canonical_instrument_name(instrument)
	else:
		instrument = None
	if instrument and instrument in parent.worker.instruments:
		setcfg("comport.number", parent.worker.instruments.index(instrument) +
								 1)
		parent.update_comports(force=True)
	else:
		parent.update_colorimeter_correction_matrix_ctrl_items(True)
	return True


def get_cgats_measurement_mode(cgats, instrument):
	base_id = cgats.queryv1("DISPLAY_TYPE_BASE_ID")
	refresh = cgats.queryv1("DISPLAY_TYPE_REFRESH")
	mode = None
	if base_id:
		# IMPORTANT: Make changes aswell in the following locations:
		# - DisplayCAL.MainFrame.create_colorimeter_correction_handler
		# - DisplayCAL.MainFrame.get_ccxx_measurement_modes
		# - DisplayCAL.MainFrame.set_ccxx_measurement_mode
		# - worker.Worker.check_add_display_type_base_id
		# - worker.Worker.instrument_can_use_ccxx
		if instrument in ("ColorHug", "ColorHug2"):
			mode = {1: "F",
					2: "R"}.get(base_id)
		elif instrument == "ColorMunki Smile":
			mode = {1: "f"}.get(base_id)
		elif instrument == "Colorimtre HCFR":
			mode = {1: "R"}.get(base_id)
		elif instrument == "K-10":
			mode = {1: "F"}.get(base_id)
		else:
			mode = {1: "l",
					2: "c",
					3: "g"}.get(base_id)
	elif refresh == "NO":
		mode = "l"
	elif refresh == "YES":
		mode = "c"
	return mode


def get_cgats_path(cgats):
	descriptor = re.search('\nDESCRIPTOR\s+"(.+?)"\n', cgats)
	if descriptor:
		descriptor = descriptor.groups()[0]
	description = safe_unicode(descriptor or 
							   lang.getstr("unnamed"), "UTF-8")
	name = re.sub(r"[\\/:;*?\"<>|]+", "_", 
				  make_argyll_compatible_path(description))[:255]
	return os.path.join(config.get_argyll_data_dir(), 
						"%s.%s" % (name, cgats[:7].strip().lower()))


def get_header(parent, bitmap=None, label=None, size=(-1, 64), x=80, y=44,
			   repeat_sub_bitmap_h=(220, 0, 2, 64)):
	w, h = 222, 64
	scale = getcfg("app.dpi") / config.get_default_dpi()
	if scale > 1:
		size = tuple(int(math.floor(v * scale)) if v > 0 else v for v in size)
		x, y = [int(round(v * scale)) if v else v for v in (x, y)]
		repeat_sub_bitmap_h = tuple(int(math.floor(v * scale))
									for v in repeat_sub_bitmap_h)
		w, h = [int(round(v * scale)) for v in (w, h)]
	header = BitmapBackgroundPanelText(parent)
	header.label_x = x
	header.label_y = y
	header.scalebitmap = (False, ) * 2
	header.textshadow = False
	header.SetBackgroundColour("#0e59a9")
	header.SetForegroundColour("#FFFFFF")
	header.SetMaxFontSize(11)
	label = label or lang.getstr("header")
	if not bitmap:
		bitmap = getbitmap("theme/header", False)
		if bitmap.Size[0] >= w and bitmap.Size[1] >= h:
			bitmap = bitmap.GetSubBitmap((0, 0, w, h))
	header.MinSize = size
	header.repeat_sub_bitmap_h = repeat_sub_bitmap_h
	header.SetBitmap(bitmap)
	header.SetLabel(label)
	return header


def get_profile_load_on_login_label(os_cal):
	label = lang.getstr("profile.load_on_login")
	if sys.platform == "win32" and not os_cal:
		lstr = lang.getstr("calibration.preserve")
		if getcfg("lang") != "de":
			lstr = lstr[0].lower() + lstr[1:]
		label += u" && " + lstr
	return label


def upload_colorimeter_correction(parent=None, params=None):
	""" Upload colorimeter correction to online database """
	path = "/index.php"
	failure_msg = lang.getstr("colorimeter_correction.upload.failure")
	# Check for duplicate
	resp = http_request(parent, "colorimetercorrections." + domain, "GET", path,
						# Remove CREATED date for calculating hash
						{"get": True, "hash": md5(re.sub('\nCREATED\s+".+?"\n', "\n\n",
														 safe_str(params['cgats'],
																  "UTF-8")).strip()).hexdigest()},
						silent=True)
	if resp and resp.read().strip().startswith("CC"):
		wx.CallAfter(InfoDialog, parent, 
					 msg=lang.getstr("colorimeter_correction.upload.exists"),
					 ok=lang.getstr("ok"), 
					 bitmap=geticon(32, "dialog-information"))
		return
	else:
		# Upload
		params['put'] = True
		resp = http_request(parent, "colorimetercorrections." + domain, "POST",
							path, params, failure_msg=failure_msg)
	if resp is not False:
		if resp.status == 201:
			wx.CallAfter(InfoDialog, parent, 
						 msg=lang.getstr("colorimeter_correction.upload.success"),
						 ok=lang.getstr("ok"), 
						 bitmap=geticon(32, "dialog-information"))
		else:
			wx.CallAfter(InfoDialog, parent, 
						 msg="\n\n".join([failure_msg, resp.read().strip()]),
						 ok=lang.getstr("ok"), 
						 bitmap=geticon(32, "dialog-error"))


def install_scope_handler(event=None, dlg=None):
	dlg = dlg or event.EventObject.TopLevelParent
	auth_needed = dlg.install_systemwide.GetValue()
	if hasattr(dlg.ok, "SetAuthNeeded"):
		dlg.ok.SetAuthNeeded(auth_needed)
		if hasattr(dlg, "alt"):
			dlg.alt.SetAuthNeeded(auth_needed)
	dlg.buttonpanel.Layout()


class Dummy(object):
	""" Useful if we need an object to attach arbitrary attributes."""
	pass


class ExtraArgsFrame(BaseFrame):

	""" Extra commandline arguments window. """
	
	def __init__(self, parent):
		self.res = TempXmlResource(get_data_path(os.path.join("xrc", 
															  "extra.xrc")))
		self.res.InsertHandler(xh_floatspin.FloatSpinCtrlXmlHandler())
		self.res.InsertHandler(xh_hstretchstatbmp.HStretchStaticBitmapXmlHandler())
		self.res.InsertHandler(xh_bitmapctrls.BitmapButton())
		self.res.InsertHandler(xh_bitmapctrls.StaticBitmap())
		if hasattr(wx, "PreFrame"):
			# Classic
			pre = wx.PreFrame()
			self.res.LoadOnFrame(pre, parent, "extra_args")
			self.PostCreate(pre)
		else:
			# Phoenix
			wx.Frame.__init__(self)
			self.res.LoadFrame(self, parent, "extra_args")
		self.init()
		self.Bind(wx.EVT_CLOSE, self.OnClose, self)
		
		self.SetIcons(config.get_icon_bundle([256, 48, 32, 16], appname))
		
		self.set_child_ctrls_as_attrs(self)

		child = self.environment_label
		font = child.Font
		font.SetWeight(wx.BOLD)
		child.Font = font

		# Bind event handlers
		self.Bind(wx.EVT_TEXT, self.extra_args_handler, 
				   id=self.extra_args_dispcal_ctrl.GetId())
		self.Bind(wx.EVT_TEXT, self.extra_args_handler, 
				   id=self.extra_args_dispread_ctrl.GetId())
		self.Bind(wx.EVT_TEXT, self.extra_args_handler, 
				   id=self.extra_args_spotread_ctrl.GetId())
		self.Bind(wx.EVT_TEXT, self.extra_args_handler, 
				   id=self.extra_args_colprof_ctrl.GetId())
		self.Bind(wx.EVT_TEXT, self.extra_args_handler, 
				   id=self.extra_args_collink_ctrl.GetId())
		self.Bind(wx.EVT_TEXT, self.extra_args_handler, 
				   id=self.extra_args_targen_ctrl.GetId())
		
		self.setup_language()
		self.update_controls()

	def OnClose(self, event):
		self.Hide()
	
	def extra_args_handler(self, event):
		mapping = {self.extra_args_dispcal_ctrl.GetId(): "extra_args.dispcal",
				   self.extra_args_dispread_ctrl.GetId(): "extra_args.dispread",
				   self.extra_args_spotread_ctrl.GetId(): "extra_args.spotread",
				   self.extra_args_colprof_ctrl.GetId(): "extra_args.colprof",
				   self.extra_args_collink_ctrl.GetId(): "extra_args.collink",
				   self.extra_args_targen_ctrl.GetId(): "extra_args.targen"}
		pref = mapping.get(event.GetId())
		if pref:
			ctrl = self.FindWindowById(event.GetId())
			value = ctrl.GetValue()
			setcfg(pref, value)
	
	def update_controls(self):
		self.extra_args_dispcal_ctrl.ChangeValue(getcfg("extra_args.dispcal"))
		self.extra_args_dispread_ctrl.ChangeValue(getcfg("extra_args.dispread"))
		self.extra_args_spotread_ctrl.ChangeValue(getcfg("extra_args.spotread"))
		self.extra_args_colprof_ctrl.ChangeValue(getcfg("extra_args.colprof"))
		self.extra_args_collink_ctrl.ChangeValue(getcfg("extra_args.collink"))
		self.extra_args_targen_ctrl.ChangeValue(getcfg("extra_args.targen"))
		self.Sizer.SetSizeHints(self)
		self.Sizer.Layout()


class GamapFrame(BaseFrame):

	""" Gamut mapping options window. """
	
	def __init__(self, parent):
		self.res = TempXmlResource(get_data_path(os.path.join("xrc", 
															  "gamap.xrc")))
		self.res.InsertHandler(xh_filebrowsebutton.FileBrowseButtonWithHistoryXmlHandler())
		self.res.InsertHandler(xh_hstretchstatbmp.HStretchStaticBitmapXmlHandler())
		self.res.InsertHandler(xh_bitmapctrls.BitmapButton())
		self.res.InsertHandler(xh_bitmapctrls.StaticBitmap())
		if hasattr(wx, "PreFrame"):
			# Classic
			pre = wx.PreFrame()
			self.res.LoadOnFrame(pre, parent, "gamapframe")
			self.PostCreate(pre)
		else:
			# Phoenix
			wx.Frame.__init__(self)
			self.res.LoadFrame(self, parent, "gamapframe")
		self.init()
		self.Bind(wx.EVT_CLOSE, self.OnClose, self)
		
		self.SetIcons(config.get_icon_bundle([256, 48, 32, 16], appname))

		self.panel = self.FindWindowByName("panel")
		
		self.set_child_ctrls_as_attrs(self)

		child = self.gamut_mapping_ciecam02_label
		font = child.Font
		font.SetWeight(wx.BOLD)
		child.Font = font

		self.gamap_profile = self.FindWindowByName("gamap_profile")
		self.gamap_profile.changeCallback = self.gamap_profile_handler
		self.gamap_profile.SetHistory(get_data_path("ref", "\.(icm|icc)$"))
		self.gamap_profile.SetMaxFontSize(11)
		self.droptarget = FileDrop(self)
		self.droptarget.drophandlers = {
			".icc": self.drop_handler,
			".icm": self.drop_handler
		}
		self.gamap_profile.SetDropTarget(self.droptarget)

		# Bind event handlers
		self.Bind(wx.EVT_CHECKBOX, self.gamap_perceptual_cb_handler, 
				   id=self.gamap_perceptual_cb.GetId())
		self.Bind(wx.EVT_CHOICE, self.gamap_perceptual_intent_handler, 
				   id=self.gamap_perceptual_intent_ctrl.GetId())
		self.Bind(wx.EVT_CHECKBOX, self.gamap_saturation_cb_handler, 
				   id=self.gamap_saturation_cb.GetId())
		self.Bind(wx.EVT_CHOICE, self.gamap_saturation_intent_handler, 
				   id=self.gamap_saturation_intent_ctrl.GetId())
		self.Bind(wx.EVT_CHOICE, self.gamap_src_viewcond_handler, 
				   id=self.gamap_src_viewcond_ctrl.GetId())
		self.Bind(wx.EVT_CHOICE, self.gamap_out_viewcond_handler, 
				   id=self.gamap_out_viewcond_ctrl.GetId())
		self.Bind(wx.EVT_CHOICE, self.gamap_default_intent_handler, 
				   id=self.gamap_default_intent_ctrl.GetId())
		self.Bind(wx.EVT_CHECKBOX, self.profile_quality_b2a_ctrl_handler, 
				  id=self.low_quality_b2a_cb.GetId())
		self.Bind(wx.EVT_CHECKBOX, self.profile_quality_b2a_ctrl_handler, 
				  id=self.b2a_hires_cb.GetId())
		for v in config.valid_values["profile.b2a.hires.size"]:
			if v > -1:
				v = "%sx%sx%s" % ((v, ) * 3)
			else:
				v = lang.getstr("auto")
			self.b2a_size_ctrl.Append(v)
		self.Bind(wx.EVT_CHOICE, self.b2a_size_ctrl_handler, 
				  id=self.b2a_size_ctrl.GetId())
		self.Bind(wx.EVT_CHECKBOX, self.profile_quality_b2a_ctrl_handler, 
				  id=self.b2a_smooth_cb.GetId())

		self.viewconds_ab = OrderedDict()
		self.viewconds_ba = {}
		self.viewconds_out_ab = OrderedDict()
		
		self.intents_ab = OrderedDict()
		self.intents_ba = OrderedDict()
		
		self.default_intent_ab = {}
		self.default_intent_ba = {}
		for i, ri in enumerate(config.valid_values["gamap_default_intent"]):
			self.default_intent_ab[i] = ri
			self.default_intent_ba[ri] = i
		
		self.setup_language()
		self.update_controls()
		self.update_layout()

	def OnClose(self, event):
		self.Hide()
	
	def b2a_size_ctrl_handler(self, event):
		v = config.valid_values["profile.b2a.hires.size"][self.b2a_size_ctrl.GetSelection()]
		if v != getcfg("profile.b2a.hires.size") and self.Parent and \
		   hasattr(self.Parent, "profile_settings_changed"):
			self.Parent.profile_settings_changed()
		setcfg("profile.b2a.hires.size", v)

	def drop_handler(self, path):
		self.gamap_profile.SetPath(path)
		self.gamap_profile_handler()

	def gamap_profile_handler(self, event=None):
		v = self.gamap_profile.GetPath()
		p = bool(v) and os.path.exists(v)
		if p:
			try:
				profile = ICCP.ICCProfile(v)
			except (IOError, ICCP.ICCProfileInvalidError), exception:
				p = False
				InfoDialog(self, msg=lang.getstr("profile.invalid") + "\n" + v, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				self.gamap_profile.SetPath("")
				v = None
			else:
				if event:
					# pre-select suitable viewing condition
					if profile.profileClass == "prtr":
						self.gamap_src_viewcond_ctrl.SetStringSelection(
							lang.getstr("gamap.viewconds.pp"))
					else:
						self.gamap_src_viewcond_ctrl.SetStringSelection(
							lang.getstr("gamap.viewconds.mt"))
					self.gamap_src_viewcond_handler()
		enable_gamap = getcfg("profile.type") in ("l", "x", "X")
		self.gamap_perceptual_cb.Enable(enable_gamap)
		self.gamap_perceptual_intent_ctrl.Enable(self.gamap_perceptual_cb.GetValue())
		self.gamap_saturation_cb.Enable(enable_gamap)
		self.gamap_saturation_intent_ctrl.Enable(self.gamap_saturation_cb.GetValue())
		c = self.gamap_perceptual_cb.GetValue() or \
			self.gamap_saturation_cb.GetValue()
		self.gamap_profile.Enable(c)
		self.gamap_src_viewcond_ctrl.Enable(p and c)
		self.gamap_out_viewcond_ctrl.Enable(p and c)
		if not ((p and c) or getcfg("profile.b2a.hires")):
			setcfg("gamap_default_intent", "p")
		self.gamap_default_intent_ctrl.SetSelection(self.default_intent_ba[getcfg("gamap_default_intent")])
		self.gamap_default_intent_ctrl.Enable((p and c) or
											   (getcfg("profile.b2a.hires") and
												enable_gamap))
		if v != getcfg("gamap_profile") and self.Parent and \
		   hasattr(self.Parent, "profile_settings_changed"):
			self.Parent.profile_settings_changed()
		setcfg("gamap_profile", v or None)

	def gamap_perceptual_cb_handler(self, event=None):
		v = self.gamap_perceptual_cb.GetValue()
		if not v:
			self.gamap_saturation_cb.SetValue(False)
			self.gamap_saturation_cb_handler()
		if int(v) != getcfg("gamap_perceptual") and self.Parent and \
		   hasattr(self.Parent, "profile_settings_changed"):
			self.Parent.profile_settings_changed()
		setcfg("gamap_perceptual", int(v))
		self.gamap_profile_handler()

	def gamap_perceptual_intent_handler(self, event=None):
		v = self.intents_ba[self.gamap_perceptual_intent_ctrl.GetStringSelection()]
		if v != getcfg("gamap_perceptual_intent") and self.Parent and \
		   hasattr(self.Parent, "profile_settings_changed"):
			self.Parent.profile_settings_changed()
		setcfg("gamap_perceptual_intent", v)

	def gamap_saturation_cb_handler(self, event=None):
		v = self.gamap_saturation_cb.GetValue()
		if v:
			self.gamap_perceptual_cb.SetValue(True)
			self.gamap_perceptual_cb_handler()
		if int(v) != getcfg("gamap_saturation") and self.Parent and \
		   hasattr(self.Parent, "profile_settings_changed"):
			self.Parent.profile_settings_changed()
		setcfg("gamap_saturation", int(v))
		self.gamap_profile_handler()

	def gamap_saturation_intent_handler(self, event=None):
		v = self.intents_ba[self.gamap_saturation_intent_ctrl.GetStringSelection()]
		if v != getcfg("gamap_saturation_intent") and self.Parent and \
		   hasattr(self.Parent, "profile_settings_changed"):
			self.Parent.profile_settings_changed()
		setcfg("gamap_saturation_intent", v)

	def gamap_src_viewcond_handler(self, event=None):
		v = self.viewconds_ba[self.gamap_src_viewcond_ctrl.GetStringSelection()]
		if v != getcfg("gamap_src_viewcond") and self.Parent and \
		   hasattr(self.Parent, "profile_settings_changed"):
			self.Parent.profile_settings_changed()
		setcfg("gamap_src_viewcond", v)

	def gamap_out_viewcond_handler(self, event=None):
		v = self.viewconds_ba[self.gamap_out_viewcond_ctrl.GetStringSelection()]
		if v != getcfg("gamap_out_viewcond") and self.Parent and \
		   hasattr(self.Parent, "profile_settings_changed"):
			self.Parent.profile_settings_changed()
		setcfg("gamap_out_viewcond", v)
	
	def gamap_default_intent_handler(self, event=None):
		v = self.gamap_default_intent_ctrl.GetSelection()
		if (self.default_intent_ab[v] != getcfg("gamap_default_intent") and
			self.Parent and hasattr(self.Parent, "profile_settings_changed")):
			self.Parent.profile_settings_changed()
		setcfg("gamap_default_intent", self.default_intent_ab[v])

	def profile_quality_b2a_ctrl_handler(self, event):
		if (event.GetId() == self.low_quality_b2a_cb.GetId() and
			self.low_quality_b2a_cb.GetValue()):
			self.b2a_hires_cb.Enable(False)
		else:
			self.b2a_hires_cb.Enable(getcfg("profile.type") in ("l", "x", "X"))
		hires = self.b2a_hires_cb.GetValue()
		self.low_quality_b2a_cb.Enable(not hires)
		if hires:
			if event.GetId() == self.b2a_smooth_cb.GetId():
				setcfg("profile.b2a.hires.smooth",
					   int(self.b2a_smooth_cb.GetValue()))
			else:
				self.b2a_smooth_cb.SetValue(bool(getcfg("profile.b2a.hires.smooth")))
		else:
			self.b2a_smooth_cb.SetValue(False)
		if self.low_quality_b2a_cb.GetValue():
			v = "l"
		else:
			v = None
		if (v != getcfg("profile.quality.b2a") or
			hires != getcfg("profile.b2a.hires")) and self.Parent:
			self.Parent.profile_settings_changed()
		setcfg("profile.quality.b2a", v)
		setcfg("profile.b2a.hires", int(hires))
		self.b2a_size_ctrl.Enable(hires)
		self.b2a_smooth_cb.Enable(hires)
		self.gamap_profile_handler()
		if self.Parent:
			self.Parent.update_bpc()
			self.Parent.lut3d_update_b2a_controls()
			if hasattr(self.Parent, "lut3dframe"):
				self.Parent.lut3dframe.update_controls()
	
	def setup_language(self):
		"""
		Substitute translated strings for menus, controls, labels and tooltips.
		
		"""
		BaseFrame.setup_language(self)
		
		self.gamap_profile.dialogTitle = lang.getstr("gamap.profile")
		self.gamap_profile.fileMask = lang.getstr("filetype.icc") + "|*.icc;*.icm"
		
		intents = list(config.intents)
		if (self.Parent and hasattr(self.Parent, "worker") and
			self.Parent.worker.argyll_version < [1, 3, 3]):
			intents.remove("pa")
		if (self.Parent and hasattr(self.Parent, "worker") and
			self.Parent.worker.argyll_version < [1, 8, 3]):
			intents.remove("lp")
		for v in intents:
			lstr = lang.getstr("gamap.intents.%s" % v)
			self.intents_ab[v] = lstr
			self.intents_ba[lstr] = v
		
		self.gamap_perceptual_intent_ctrl.SetItems(
			self.intents_ab.values())
		self.gamap_saturation_intent_ctrl.SetItems(
			self.intents_ab.values())
		
		self.viewconds_ab[None] = lang.getstr("default")
		self.viewconds_ba[lang.getstr("default")] = None
		for v in viewconds:
			if self.Parent and hasattr(self.Parent, "worker") and (
				(v == "pc" and self.Parent.worker.argyll_version < [1, 1, 1]) or
				(v == "tv" and self.Parent.worker.argyll_version < [1, 6, 0])):
				continue
			lstr = lang.getstr("gamap.viewconds.%s" % v)
			self.viewconds_ab[v] = lstr
			self.viewconds_ba[lstr] = v
			if v not in ("pp", "pe", "pc", "pcd", "ob", "cx"):
				self.viewconds_out_ab[v] = lstr
		
		self.gamap_src_viewcond_ctrl.SetItems(
			self.viewconds_ab.values())
		self.gamap_out_viewcond_ctrl.SetItems(
			[lang.getstr("default")] + self.viewconds_out_ab.values())
		
		self.gamap_default_intent_ctrl.SetItems([lang.getstr("gamap.intents." + v)
												 for v in config.valid_values["gamap_default_intent"]])
	
	def update_controls(self):
		""" Update controls with values from the configuration """

		# B2A quality
		enable_gamap = getcfg("profile.type") in ("l", "x", "X")
		enable_b2a_extra = getcfg("profile.type") in ("l", "x", "X")
		b2a_hires = enable_b2a_extra and bool(getcfg("profile.b2a.hires"))
		self.low_quality_b2a_cb.SetValue(enable_gamap and
										 getcfg("profile.quality.b2a") in
										 ("l", "n") and not b2a_hires)
		self.low_quality_b2a_cb.Enable(enable_gamap and not b2a_hires)
		self.b2a_hires_cb.SetValue(b2a_hires)
		self.b2a_hires_cb.Enable(enable_b2a_extra and not
								 self.low_quality_b2a_cb.GetValue())
		self.b2a_size_ctrl.SetSelection(
			config.valid_values["profile.b2a.hires.size"].index(
				getcfg("profile.b2a.hires.size")))
		self.b2a_size_ctrl.Enable(b2a_hires)
		self.b2a_smooth_cb.SetValue(b2a_hires and
									bool(getcfg("profile.b2a.hires.smooth")))
		self.b2a_smooth_cb.Enable(b2a_hires)

		# CIECAM02
		self.gamap_profile.SetPath(getcfg("gamap_profile"))
		self.gamap_perceptual_cb.SetValue(enable_gamap and
										  bool(getcfg("gamap_perceptual")))
		self.gamap_perceptual_intent_ctrl.SetStringSelection(
			self.intents_ab.get(getcfg("gamap_perceptual_intent"), 
			self.intents_ab.get(defaults["gamap_perceptual_intent"])))
		self.gamap_saturation_cb.SetValue(enable_gamap and
										  bool(getcfg("gamap_saturation")))
		self.gamap_saturation_intent_ctrl.SetStringSelection(
			self.intents_ab.get(getcfg("gamap_saturation_intent"), 
			self.intents_ab.get(defaults["gamap_saturation_intent"])))
		self.gamap_src_viewcond_ctrl.SetStringSelection(
			self.viewconds_ab.get(getcfg("gamap_src_viewcond", False), 
			self.viewconds_ab.get(defaults.get("gamap_src_viewcond"))))
		self.gamap_out_viewcond_ctrl.SetStringSelection(
			self.viewconds_ab.get(getcfg("gamap_out_viewcond"), 
			self.viewconds_ab.get(defaults.get("gamap_out_viewcond"))))

		self.gamap_profile_handler()


class MainFrame(ReportFrame, BaseFrame):

	""" Display calibrator main application window. """

	lut3d_apply_cal_ctrl_handler = LUT3DFrame.__dict__["lut3d_apply_cal_ctrl_handler"]
	lut3d_bind_event_handlers = LUT3DFrame.__dict__["lut3d_bind_event_handlers"]
	lut3d_content_colorspace_handler = LUT3DFrame.__dict__["lut3d_content_colorspace_handler"]
	lut3d_content_colorspace_xy_handler = LUT3DFrame.__dict__["lut3d_content_colorspace_xy_handler"]
	lut3d_create_consumer = LUT3DFrame.__dict__["lut3d_create_consumer"]
	lut3d_create_handler = LUT3DFrame.__dict__["lut3d_create_handler"]
	lut3d_create_producer = LUT3DFrame.__dict__["lut3d_create_producer"]
	lut3d_bitdepth_input_ctrl_handler = LUT3DFrame.__dict__["lut3d_bitdepth_input_ctrl_handler"]
	lut3d_bitdepth_output_ctrl_handler = LUT3DFrame.__dict__["lut3d_bitdepth_output_ctrl_handler"]
	lut3d_encoding_input_ctrl_handler = LUT3DFrame.__dict__["lut3d_encoding_input_ctrl_handler"]
	lut3d_encoding_output_ctrl_handler = LUT3DFrame.__dict__["lut3d_encoding_output_ctrl_handler"]
	lut3d_enable_size_controls = LUT3DFrame.__dict__["lut3d_enable_size_controls"]
	lut3d_format_ctrl_handler = LUT3DFrame.__dict__["lut3d_format_ctrl_handler"]
	lut3d_gamut_mapping_mode_handler = LUT3DFrame.__dict__["lut3d_gamut_mapping_mode_handler"]
	lut3d_hdr_peak_luminance_handler = LUT3DFrame.__dict__["lut3d_hdr_peak_luminance_handler"]
	lut3d_hdr_maxcll_handler = LUT3DFrame.__dict__["lut3d_hdr_maxcll_handler"]
	lut3d_rendering_intent_ctrl_handler = LUT3DFrame.__dict__["lut3d_rendering_intent_ctrl_handler"]
	lut3d_setup_encoding_ctrl = LUT3DFrame.__dict__["lut3d_setup_encoding_ctrl"]
	lut3d_setup_language = LUT3DFrame.__dict__["lut3d_setup_language"]
	lut3d_show_bitdepth_controls = LUT3DFrame.__dict__["lut3d_show_bitdepth_controls"]
	lut3d_show_encoding_controls = LUT3DFrame.__dict__["lut3d_show_encoding_controls"]
	lut3d_show_trc_controls = LUT3DFrame.__dict__["lut3d_show_trc_controls"]
	lut3d_set_option = LUT3DFrame.__dict__["lut3d_set_option"]
	lut3d_size_ctrl_handler = LUT3DFrame.__dict__["lut3d_size_ctrl_handler"]
	lut3d_snap_size = LUT3DFrame.__dict__["lut3d_snap_size"]
	lut3d_trc_ctrl_handler = LUT3DFrame.__dict__["lut3d_trc_ctrl_handler"]
	lut3d_trc_gamma_ctrl_handler = LUT3DFrame.__dict__["lut3d_trc_gamma_ctrl_handler"]
	lut3d_trc_gamma_type_ctrl_handler = LUT3DFrame.__dict__["lut3d_trc_gamma_type_ctrl_handler"]
	lut3d_trc_black_output_offset_ctrl_handler = LUT3DFrame.__dict__["lut3d_trc_black_output_offset_ctrl_handler"]
	lut3d_update_encoding_controls = LUT3DFrame.__dict__["lut3d_update_encoding_controls"]
	lut3d_update_shared_controls = LUT3DFrame.__dict__["lut3d_update_shared_controls"]
	lut3d_update_trc_control = LUT3DFrame.__dict__["lut3d_update_trc_control"]
	lut3d_update_trc_controls = LUT3DFrame.__dict__["lut3d_update_trc_controls"]

	# XYZbpout will be set to the blackpoint of the selected profile. This is
	# used to determine if 3D LUT or measurement report black output offset
	# controls should be shown. Set a initial value slightly above zero so
	# output offset controls are shown if the selected profile doesn't exist
	# and "Create 3D LUT after profiling" is disabled.
	XYZbpout = [0.001, 0.001, 0.001]
	
	def __init__(self, worker):
		# Check for required resource files and get pre-canned testcharts
		self.dist_testcharts = []
		self.dist_testchart_names = []
		missing = []
		for filename in resfiles:
			path, ext = (get_data_path(os.path.sep.join(filename.split("/"))), 
				os.path.splitext(filename)[1])
			if (not path or not os.path.isfile(path)):
				missing.append(filename)
			elif ext.lower() == ".ti1":
				self.dist_testcharts.append(path)
				self.dist_testchart_names.append(os.path.basename(path))
		if missing:
			wx.CallAfter(show_result_dialog,
						 lang.getstr("resources.notfound.warning") +
						 "\n" + safe_unicode("\n".join(missing)), self)
		
		# Initialize GUI
		self.res = TempXmlResource(get_data_path(os.path.join("xrc", 
															  "main.xrc")))
		self.res.InsertHandler(xh_fancytext.StaticFancyTextCtrlXmlHandler())
		self.res.InsertHandler(xh_floatspin.FloatSpinCtrlXmlHandler())
		self.res.InsertHandler(xh_hstretchstatbmp.HStretchStaticBitmapXmlHandler())
		self.res.InsertHandler(xh_bitmapctrls.BitmapButton())
		self.res.InsertHandler(xh_bitmapctrls.StaticBitmap())
		if hasattr(wx, "PreFrame"):
			# Classic
			pre = wx.PreFrame()
			self.res.LoadOnFrame(pre, None, "mainframe")
			self.PostCreate(pre)
		else:
			# Phoenix
			wx.Frame.__init__(self)
			self.res.LoadFrame(self, None, "mainframe")
		self.init()
		self.worker = worker
		self.worker.owner = self
		result = self.worker.create_tempdir()
		if isinstance(result, Exception):
			safe_print(result)
		if sys.platform == "win32":
			self.maxprofilenamelength = 254 - len(self.worker.tempdir or "")
		else:
			self.maxprofilenamelength = 255
		self.init_frame()
		self.init_defaults()
		self.set_child_ctrls_as_attrs(self)
		self.init_infoframe()
		if sys.platform in ("darwin", "win32") or isexe:
			self.init_measureframe()
		self.init_menus()
		self.init_controls()
		self.show_advanced_options_handler()
		self.setup_language()
		self.update_displays(update_ccmx_items=False)
		self.update_comports()
		self.update_controls(update_ccmx_items=False)
		self.set_size(True, True)
		self.calpanel.SetScrollRate(2, 2)
		x, y = getcfg("position.x", False), getcfg("position.y", False)
		if not None in (x, y):
			self.SetSaneGeometry(x, y)
		else:
			self.Center()
		self.Bind(wx.EVT_MOVE, self.OnMove, self)
		if verbose >= 1:
			safe_print(lang.getstr("success"))
		
		# Check for and load default calibration
		if len(self.worker.displays):
			if getcfg("calibration.file", False):
				# Load LUT curves from last used .cal file
				self.load_cal(silent=True)
			else:
				# Load LUT curves from current display profile (if any, and 
				# if it contains curves)
				self.load_display_profile_cal(None)
		
		self.init_timers()
		
		if verbose >= 1:
			safe_print(lang.getstr("ready"))
	
	def log(self):
		""" Append log buffer contents to the log window. """
		# We do this after all initialization because the log.log() function 
		# expects the window to be fully created and accessible via 
		# wx.GetApp().frame.infoframe
		if not hasattr(self, "logoffset"):
			# Skip the very first line, which is just '=' * 80
			self.logoffset = 1
		else:
			self.logoffset = 0
		logbuffer.seek(0)
		self.infoframe.Log("".join([line.decode("UTF-8", "replace") 
								    for line in logbuffer][self.logoffset:]).rstrip())
		logbuffer.truncate(0)

	def init_defaults(self):
		""" Initialize GUI-specific defaults. """
		defaults.update({
			"position.info.x": self.GetDisplay().ClientArea[0] + 30,
			"position.info.y": self.GetDisplay().ClientArea[1] + 30,
			"position.lut_viewer.x": self.GetDisplay().ClientArea[0] + 40,
			"position.lut_viewer.y": self.GetDisplay().ClientArea[1] + 40,
			"position.progress.x": self.GetDisplay().ClientArea[0] + 30,
			"position.progress.y": self.GetDisplay().ClientArea[1] + 30,
			"position.x": self.GetDisplay().ClientArea[0] + 20,
			"position.y": self.GetDisplay().ClientArea[1] + 20
		})

		self.recent_cals = getcfg("recent_cals").split(os.pathsep)
		while "" in self.recent_cals:
			self.recent_cals.remove("")
		self.recent_cals.insert(0, "")
		
		self.presets = []
		presets = get_data_path("presets", ".*\.(?:icc|icm)$")
		if isinstance(presets, list):
			self.presets = natsort(presets)
			self.presets.reverse()
			for preset in self.presets:
				if not preset in self.recent_cals:
					self.recent_cals.insert(1, preset)
		
		self.static_labels = []
		
		self.updatingctrls = False
		
		# Left side - internal enumeration, right side - commmandline
		self.whitepoint_colortemp_loci_ab = {
			0: "t",
			1: "T"
		}
		
		# Left side - commmandline, right side - internal enumeration
		self.whitepoint_colortemp_loci_ba = {
			"t": 0,
			"T": 1
		}
		
		# Left side - commmandline, right side - internal enumeration
		self.quality_ab = {
			1: "v",
			2: "l",
			3: "m",
			4: "h",
			5: "u"
		}
		self.quality_b2a_ab = {
			0: "n",
			1: "l",
			2: "m",
			3: "h",
			4: "u"
		}
		
		# Left side - commmandline, right side - internal enumeration
		self.quality_ba = swap_dict_keys_values(self.quality_ab)
		
		self.testchart_defaults = config.testchart_defaults
		self.testcharts = []
		self.testchart_names = []
		
		# Left side - commmandline, right side - .cal file
		self.trc_ab = {
			"l": "L_STAR",
			"709": "REC709",
			"s": "sRGB",
			"240": "SMPTE240M"
		}
		
		# Left side - .cal file, right side - commmandline
		self.trc_ba = swap_dict_keys_values(self.trc_ab)
		
		# Left side - internal enumeration, right side - commmandline
		self.trc_types_ab = {
			0: "g",
			1: "G"
		}
		
		# Left side - commmandline, right side - internal enumeration
		self.trc_types_ba = swap_dict_keys_values(self.trc_types_ab)
		
		self.trc_presets = [
			"1.8",
			"2.0",
			"2.2",
			"2.4"
		]
		
		self.whitepoint_presets = [
			"5000",
			"5500",
			"6000",
			"6500"
		]

	def init_frame(self):
		"""
		Initialize the main window and its event handlers.
		
		Controls are initialized in a separate step (see init_controls).
		
		"""
		# UGLY HACK: This 'safe_print' call fixes a GTK assertion and 
		# segfault under Arch Linux when setting the window title
		safe_print("")
		title = "%s %s" % (appname, version_short)
		if VERSION > VERSION_BASE:
			title += " Beta"
		self.SetTitle(title)
		self.SetMaxSize((-1, -1))
		self.SetIcons(config.get_icon_bundle([256, 48, 32, 16], appname))
		self.Bind(wx.EVT_CLOSE, self.OnClose, self)
		self.Bind(wx.EVT_SIZE, self.OnResize, self)
		self.Bind(wx.EVT_DISPLAY_CHANGED, self.check_update_controls)
		self.droptarget = FileDrop(self)
		self.droptarget.drophandlers = {
			".7z": self.cal_drop_handler,
			".cal": self.cal_drop_handler,
			".ccmx": self.ccxx_drop_handler,
			".ccss": self.ccxx_drop_handler,
			".icc": self.cal_drop_handler,
			".icm": self.cal_drop_handler,
			".tar.gz": self.cal_drop_handler,
			".ti1": self.ti1_drop_handler,
			".ti3": self.ti3_drop_handler,
			".tgz": self.cal_drop_handler,
			".zip": self.cal_drop_handler
		}

		# Main panel
		self.panel = self.FindWindowByName("panel")
		self.panel.SetDropTarget(self.droptarget)
		
		# Header
		# Its width also determines the initial min width of the main window
		# after SetSizeHints and Layout
		self.headerbordertop = self.FindWindowByName("headerbordertop")
		self.header = get_header(self.panel)
		self.headerpanel = self.FindWindowByName("headerpanel")
		self.headerpanel.ContainingSizer.Insert(1, self.header, flag=wx.EXPAND)
		y = 64
		w = 80
		h = 120
		scale = getcfg("app.dpi") / config.get_default_dpi()
		if scale > 1:
			y, w, h = [int(math.floor(v * scale)) for v in (y, w, h)]
		self.header_btm = BitmapBackgroundPanel(self.headerpanel, size=(w, -1))
		self.header_btm.BackgroundColour = "#0e59a9"
		self.header_btm.scalebitmap = False, False
		header_bmp = getbitmap("theme/header", False)
		if header_bmp.Size[0] >= w and header_bmp.Size[1] >= h + y:
			header_bmp = header_bmp.GetSubBitmap((0, y, w, h))
			self.header_btm.SetBitmap(header_bmp)
		self.headerpanel.Sizer.Insert(0, self.header_btm, flag=wx.ALIGN_TOP |
															   wx.EXPAND)
		#separator = BitmapBackgroundPanel(self.panel, size=(-1, 1))
		#separator.SetBackgroundColour(wx.SystemSettings.GetColour(wx.SYS_COLOUR_3DSHADOW))
		#self.panel.Sizer.Insert(2, separator, flag=wx.EXPAND)
		
		# Calibration settings panel
		self.calpanel = self.FindWindowByName("calpanel")
		self.display_instrument_panel = self.FindWindowByName("display_instrument_panel")
		self.calibration_settings_panel = self.FindWindowByName("calibration_settings_panel")
		self.profile_settings_panel = self.FindWindowByName("profile_settings_panel")
		self.lut3d_settings_panel = self.FindWindowByName("lut3d_settings_panel")

		# Verification / measurement report
		res = TempXmlResource(get_data_path(os.path.join("xrc", "report.xrc")))
		res.InsertHandler(xh_fancytext.StaticFancyTextCtrlXmlHandler())
		res.InsertHandler(xh_filebrowsebutton.FileBrowseButtonWithHistoryXmlHandler())
		res.InsertHandler(xh_hstretchstatbmp.HStretchStaticBitmapXmlHandler())
		res.InsertHandler(xh_bitmapctrls.BitmapButton())
		res.InsertHandler(xh_bitmapctrls.StaticBitmap())
		self.mr_settings_panel = res.LoadPanel(self.calpanel, "panel")
		self.calpanel.Sizer.Add(self.mr_settings_panel, 1, flag=wx.EXPAND)

		# Make info panels use theme color
		for panel_name in ["display_instrument_info_panel",
						   "calibration_settings_info_panel",
						   "profile_settings_info_panel",
						   "lut3d_settings_info_panel",
						   "mr_settings_info_panel"]:
			panel = self.FindWindowByName(panel_name)
			panel.BackgroundColour = wx.SystemSettings.GetColour(wx.SYS_COLOUR_WINDOW)
		
		# Button panel
		self.buttonpanel = self.FindWindowByName("buttonpanel")
		sizer = self.buttonpanel.ContainingSizer
		if hasattr(sizer, "GetItemIndex"):
			# wxPython 2.8.12+
			separator = BitmapBackgroundPanel(self.panel, size=(-1, 1))
			separator.SetBackgroundColour(wx.SystemSettings.GetColour(wx.SYS_COLOUR_3DSHADOW))
			sizer.Insert(sizer.GetItemIndex(self.buttonpanel), separator,
						 flag=wx.EXPAND)
			self.buttonpanelheader = BitmapBackgroundPanel(self.panel,
														   size=(-1, 15))
			bmp = getbitmap("theme/gradient", False)
			if bmp.Size[0] >= 8 and bmp.Size[1] >= 96:
				bmp = bmp.GetSubBitmap((0, 1, 8, 15)).ConvertToImage().Mirror(False).ConvertToBitmap()
				image = bmp.ConvertToImage()
				databuffer = image.GetDataBuffer()
				for i, byte in enumerate(databuffer):
					if byte > "\0":
						databuffer[i] = chr(int(min(round(ord(byte) *
														  (255.0 / 223.0)), 255)))
				bmp = image.ConvertToBitmap()
				self.buttonpanelheader.SetBitmap(bmp)
			sizer.Insert(sizer.GetItemIndex(self.buttonpanel),
						 self.buttonpanelheader, flag=wx.EXPAND)
			bgcolor = self.buttonpanel.BackgroundColour
			self.buttonpanel.SetBackgroundColour(wx.Colour(*[int(v * .93)
															 for v in bgcolor]))
			self.buttonpanelheader.SetBackgroundColour(self.buttonpanel.BackgroundColour)
			self.buttonpanelheader.blend = True
		
		# Tab panel
		self.tabpanel = self.FindWindowByName("tabpanel")
		sizer = self.tabpanel.ContainingSizer
		if hasattr(sizer, "GetItemIndex"):
			# wxPython 2.8.12+
			separator = BitmapBackgroundPanel(self.panel, size=(-1, 1))
			separator.SetBackgroundColour(wx.SystemSettings.GetColour(wx.SYS_COLOUR_3DSHADOW))
			sizer.Insert(sizer.GetItemIndex(self.tabpanel) + 1, separator,
						 flag=wx.EXPAND)
			self.tabpanelheader = BitmapBackgroundPanel(self.panel,
														   size=(-1, 15))
			self.tabpanelfooter = BitmapBackgroundPanel(self.panel,
														   size=(-1, 15))
			bmp = getbitmap("theme/gradient", False)
			if bmp.Size[0] >= 8 and bmp.Size[1] >= 96:
				sub = bmp.GetSubBitmap((0, 1, 8, 15)).ConvertToImage()
				bmp = sub.Mirror(False).ConvertToBitmap()
				image2 = bmp.ConvertToImage()
				databuffer = image2.GetDataBuffer()
				for i, byte in enumerate(databuffer):
					if byte > "\0":
						databuffer[i] = chr(int(min(round((ord(byte) - 153) *
														  (255.0 / 70.0)), 255)))
				bmp = image2.ConvertToBitmap()
				self.tabpanelheader.SetBitmap(bmp)
				bmp = image.Mirror(False).ConvertToBitmap()
				self.tabpanelfooter.SetBitmap(bmp)
			sizer.Insert(sizer.GetItemIndex(self.tabpanel),
						 self.tabpanelheader, flag=wx.EXPAND)
			sizer.Insert(sizer.GetItemIndex(self.tabpanel) + 1,
						 self.tabpanelfooter, flag=wx.EXPAND)
			bgcolor = self.tabpanel.BackgroundColour
			self.tabpanel.SetBackgroundColour(wx.Colour(*[int(v * .2125)
															 for v in bgcolor]))
			self.tabpanel.ForegroundColour = "#EEEEEE"
			self.tabpanelheader.SetBackgroundColour(self.tabpanel.BackgroundColour)
			self.tabpanelheader.blend = True
			self.tabpanelfooter.SetBackgroundColour(self.tabpanel.BackgroundColour)
			self.tabpanelfooter.blend = True

		# Add tab buttons
		self.display_instrument_btn = PlateButton(self.tabpanel, -1,
													label="display-instrument",
													bmp=geticon(48, "display-instrument"),
													style=platebtn.PB_STYLE_GRADIENT |
														  platebtn.PB_STYLE_TOGGLE)
		self.display_instrument_btn.Bind(wx.EVT_TOGGLEBUTTON,
										 self.tab_select_handler)
		self.tabpanel.Sizer.Insert(1, self.display_instrument_btn,
								   flag=wx.LEFT, border=8)
		self.calibration_settings_btn = PlateButton(self.tabpanel, -1,
													label="calibration",
													bmp=geticon(48, "calibration"),
													style=platebtn.PB_STYLE_GRADIENT |
														  platebtn.PB_STYLE_TOGGLE)
		self.calibration_settings_btn.Bind(wx.EVT_TOGGLEBUTTON,
										   self.tab_select_handler)
		self.tabpanel.Sizer.Insert(2, self.calibration_settings_btn,
								   flag=wx.LEFT, border=8)
		self.profile_settings_btn = PlateButton(self.tabpanel, -1,
													label="profiling",
													bmp=geticon(48, "profiling"),
													style=platebtn.PB_STYLE_GRADIENT |
														  platebtn.PB_STYLE_TOGGLE)
		self.profile_settings_btn.Bind(wx.EVT_TOGGLEBUTTON,
									   self.tab_select_handler)
		self.tabpanel.Sizer.Insert(3, self.profile_settings_btn,
								   flag=wx.LEFT, border=8)
		self.lut3d_settings_btn = PlateButton(self.tabpanel, -1,
													label="3dlut",
													bmp=geticon(48, "3dlut"),
													style=platebtn.PB_STYLE_GRADIENT |
														  platebtn.PB_STYLE_TOGGLE)
		self.lut3d_settings_btn.Bind(wx.EVT_TOGGLEBUTTON,
									   self.tab_select_handler)
		self.tabpanel.Sizer.Insert(4, self.lut3d_settings_btn,
								   flag=wx.LEFT, border=8)
		self.mr_settings_btn = PlateButton(self.tabpanel, -1,
													label="verification",
													bmp=geticon(48, "dialog-ok"),
													style=platebtn.PB_STYLE_GRADIENT |
														  platebtn.PB_STYLE_TOGGLE)
		self.mr_settings_btn.Bind(wx.EVT_TOGGLEBUTTON,
									   self.tab_select_handler)
		self.tabpanel.Sizer.Insert(5, self.mr_settings_btn,
								   flag=wx.LEFT | wx.RIGHT, border=8)
		for btn in (self.display_instrument_btn,
					self.calibration_settings_btn,
					self.profile_settings_btn,
					self.lut3d_settings_btn,
					self.mr_settings_btn):
			set_bitmap_labels(btn, True, False, False)
			btn.SetPressColor(wx.Colour(0x66, 0x66, 0x66))
			btn.SetLabelColor(self.tabpanel.ForegroundColour,
							  wx.WHITE)
		self.tab_select_handler(self.display_instrument_btn)
		
		self.profile_info = {}
	
	def init_timers(self):
		"""
		Setup the timers for display/instrument detection and profile name.
		
		"""
		self.update_profile_name_timer = wx.Timer(self)
		self.Bind(wx.EVT_TIMER, self.update_profile_name, 
				  self.update_profile_name_timer)

	def OnMove(self, event=None):
		# When moving, check if we are on another screen and resize if needed.
		if self.IsShownOnScreen() and not self.IsMaximized() and not \
		   self.IsIconized():
			x, y = self.GetScreenPosition()
			setcfg("position.x", x)
			setcfg("position.y", y)
			display_client_rect = self.GetDisplay().ClientArea
			if (not hasattr(self, "display_client_rect") or 
				self.display_client_rect != display_client_rect):
				# We just moved to this workspace
				if sys.platform not in ("darwin", "win32"):
					# Linux
					safety_margin = 40
				else:
					safety_margin = 20
				resize = False
				if (self.Size[0] > display_client_rect[2] or
					self.Size[1] > display_client_rect[3] - safety_margin):
					# Our size is too large for that workspace, adjust
					resize = True
				elif (self.Size[0] < (self.Size[0] - self.calpanel.Size[0] +
									  self.calpanel.VirtualSize[0]) or
					  self.Size[1] < (self.Size[1] - self.calpanel.Size[1] +
									  self.calpanel.VirtualSize[1])):
					# Our full size fits on that workspace
					resize = True
				self.display_client_rect = display_client_rect
				if resize:
					wx.CallAfter(self.set_size, True)
		if event:
			event.Skip()
	
	def OnResize(self, event):
		# Hide the header bitmap on small screens
		scale = getcfg("app.dpi") / config.get_default_dpi()
		if scale < 1:
			scale = 1
		self.header.GetContainingSizer().Show(
			self.header, self.Size[1] > 480 * scale)
		if not hasattr(self, "header_btm_bmp"):
			self.header_btm_bmp = self.header_btm.GetBitmap()
			self.header_btm_min_bmp = getbitmap("theme/header_minimal", False)
		if self.Size[1] > 480 * scale:
			if self.header_btm.GetBitmap() is not self.header_btm_bmp:
				self.header_btm.SetBitmap(self.header_btm_bmp)
		elif self.header_btm.GetBitmap() is not self.header_btm_min_bmp:
			self.header_btm.SetBitmap(self.header_btm_min_bmp)
		event.Skip()

	def cal_drop_handler(self, path):
		"""
		Drag'n'drop handler for .cal files. 
		
		Settings and calibration are loaded from dropped files.
		
		"""
		if not self.worker.is_working():
			self.load_cal_handler(None, path)

	def ccxx_drop_handler(self, path):
		"""
		Drag'n'drop handler for .ccmx/.ccss files.
		
		"""
		if not self.worker.is_working():
			self.colorimeter_correction_matrix_ctrl_handler(None, path)

	def ti1_drop_handler(self, path):
		"""
		Drag'n'drop handler for .ti1 files.
		
		Dropped files are added to the testchart chooser and selected.
		
		"""
		if not self.worker.is_working():
			self.testchart_btn_handler(None, path)

	def ti3_drop_handler(self, path):
		"""
		Drag'n'drop handler for .ti3 files.
		
		Dropped files are used to create an ICC profile.
		
		"""
		if not self.worker.is_working():
			self.create_profile_handler(None, path)

	def init_gamapframe(self):
		"""
		Create & initialize the gamut mapping options window and its controls.
		
		"""
		self.gamapframe = GamapFrame(self)

	def init_infoframe(self, show=None):
		"""
		Create & initialize the info (log) window and its controls.
		
		"""
		self.infoframe = LogWindow(self)
		self.infoframe.Bind(wx.EVT_CLOSE, self.infoframe_close_handler, 
							self.infoframe)
		self.infoframe.SetIcons(config.get_icon_bundle([256, 48, 32, 16], 
													   appname))
		if show:
			self.infoframe_toggle_handler(show=show)

	def init_lut3dframe(self):
		"""
		Create & initialize the 3D LUT creation window and its controls.
		
		"""
		self.lut3dframe = LUT3DFrame(self)

	def init_reportframe(self):
		"""
		Create & initialize the measurement report creation window and its controls.
		
		"""
		self.reportframe = ReportFrame(self)
		self.reportframe.measurement_report_btn.Bind(wx.EVT_BUTTON,
										  self.measurement_report_handler)

	def init_synthiccframe(self):
		"""
		Create & initialize the 3D LUT creation window and its controls.
		
		"""
		self.synthiccframe = SynthICCFrame(self)
	
	def infoframe_close_handler(self, event):
		self.infoframe_toggle_handler(event)
	
	def setup_language(self):
		"""
		Substitute translated strings for menus, controls, labels and tooltips.
		
		"""
		# Set language specific defaults
		lang.update_defaults()
		
		# Translate controls and labels
		
		BaseFrame.setup_language(self)
		
		settings = [lang.getstr("settings.new")]
		for cal in self.recent_cals[1:]:
			lstr = lang.getstr(os.path.basename(cal))
			if cal == getcfg("calibration.file", False) and getcfg("settings.changed"):
				lstr = "* " + lstr
			settings.append(lstr)
		self.calibration_file_ctrl.SetItems(settings)

		self.observers_ab = OrderedDict()
		for observer in config.valid_values["observer"]:
			self.observers_ab[observer] = lang.getstr("observer." + observer)
		self.observers_ba = swap_dict_keys_values(self.observers_ab)
		self.observer_ctrl.SetItems(self.observers_ab.values())
		
		self.whitepoint_ctrl.SetItems([lang.getstr("as_measured"),
									   lang.getstr("whitepoint.colortemp"),
									   lang.getstr("whitepoint.xy")])
		
		self.whitepoint_colortemp_loci = [
			lang.getstr("whitepoint.colortemp.locus.daylight"),
			lang.getstr("whitepoint.colortemp.locus.blackbody")
		]
		self.whitepoint_colortemp_locus_ctrl.SetItems(
			self.whitepoint_colortemp_loci)
		
		self.luminance_ctrl.SetItems([lang.getstr("as_measured"),
									  lang.getstr("custom")])
		
		self.black_luminance_ctrl.SetItems([lang.getstr("as_measured"),
											lang.getstr("custom")])
		
		self.trc_ctrl.SetItems([lang.getstr("as_measured"),
								"Gamma 2.2",
								lang.getstr("trc.lstar"),
								lang.getstr("trc.rec709"),
								lang.getstr("trc.rec1886"),
								lang.getstr("trc.smpte240m"),
								lang.getstr("trc.srgb"),
								lang.getstr("custom")])
		
		self.trc_types = [
			lang.getstr("trc.type.relative"),
			lang.getstr("trc.type.absolute")
		]
		self.trc_type_ctrl.SetItems(self.trc_types)

		self.update_profile_type_ctrl_items()

		self.default_testchart_names = []
		for testcharts in self.testchart_defaults.values():
			for chart in testcharts.values():
				chart = lang.getstr(chart)
				if not chart in self.default_testchart_names:
					self.default_testchart_names.append(chart)

		self.lut3d_setup_language()
		self.mr_setup_language()

	def set_size(self, set_height=False, fit_width=False):
		if not self.IsFrozen():
			self.Freeze()
		self.SetMinSize((0, 0))
		if set_height:
			if sys.platform not in ("darwin", "win32"):
				# Linux
				safety_margin = 40
			else:
				safety_margin = 20
			borders_tb = self.Size[1] - self.ClientSize[1]
			height = min(self.GetDisplay().ClientArea[3] - borders_tb -
						 safety_margin,
						 self.headerbordertop.Size[1] +
						 self.header.Size[1] +
						 self.headerpanel.Sizer.MinSize[1] + 1 +
						 ((getattr(self, "tabpanelheader", None) and
						   self.tabpanelheader.Size[1] + 1) or 0) +
						 self.tabpanel.Sizer.MinSize[1] +
						 ((getattr(self, "tabpanelfooter", None) and
						   self.tabpanelfooter.Size[1] + 1) or 0) +
						 self.display_instrument_panel.Sizer.MinSize[1] +
						 ((getattr(self, "buttonpanelheader", None) and
						   self.buttonpanelheader.Size[1] + 1) or 0) +
						 self.buttonpanel.Sizer.MinSize[1])
		else:
			height = self.ClientSize[1]
		borders_lr = self.Size[0] - self.ClientSize[0]
		scale = getcfg("app.dpi") / config.get_default_dpi()
		margin = 34
		header_min_h = 64
		if scale > 1:
			margin = int(round(margin * scale))
			header_min_h = int(round(header_min_h * scale))
		size = (min(self.GetDisplay().ClientArea[2], 
					max(self.GetMinSize()[0],
					    max(self.display_instrument_panel.Sizer.MinSize[0],
							self.calibration_settings_panel.Sizer.MinSize[0],
							self.profile_settings_panel.Sizer.MinSize[0],
							self.lut3d_settings_panel.Sizer.MinSize[0],
							self.mr_settings_panel.Sizer.MinSize[0]) + margin,
					    self.tabpanel.GetSizer().GetMinSize()[0])), 
				height)
		self.SetMaxSize((-1, -1))
		if not self.IsMaximized() and not self.IsIconized():
			self.SetClientSize(((size[0] if fit_width
								 else max(size[0], self.Size[0])) - borders_lr,
								size[1]))
		self.SetMinSize((size[0], self.GetSize()[1] - 
								  self.calpanel.GetSize()[1] + header_min_h))
		if self.IsFrozen():
			self.Thaw()
		if self.IsShown():
			self.calpanel.Layout()

	def update_profile_type_ctrl(self):
		self.profile_type_ctrl.SetSelection(
			self.profile_types_ba.get(getcfg("profile.type"), 
			self.profile_types_ba.get(defaults["profile.type"], 0)))
	
	def update_profile_type_ctrl_items(self):
		""" Populate the profile type control with available choices
		depending on Argyll version. """
		self.profile_types = [
			lang.getstr("profile.type.lut.lab"),
			lang.getstr("profile.type.shaper_matrix"),
			lang.getstr("profile.type.single_shaper_matrix"),
			lang.getstr("profile.type.gamma_matrix"),
			lang.getstr("profile.type.single_gamma_matrix")
		]
		self.profile_types_ab = {}
		profile_types_index = 0
		if self.worker.argyll_version[0:3] > [1, 1, 0] or (
		   self.worker.argyll_version[0:3] == [1, 1, 0] 
		   and not "Beta" in self.worker.argyll_version_string 
		   and not "RC1" in self.worker.argyll_version_string 
		   and not "RC2" in self.worker.argyll_version_string 
		   and not "RC3" in self.worker.argyll_version_string):
			# Argyll 1.1.0_RC3 had a bug when using -aX
			# which was fixed in 1.1.0_RC4
			self.profile_types.insert(profile_types_index, 
									  lang.getstr("profile.type.lut_matrix.xyz"))
			self.profile_types_ab[profile_types_index] = "X"  # XYZ LUT + accurate matrix
			profile_types_index += 1
		if self.worker.argyll_version[0:3] > [1, 1, 0] or (
		   self.worker.argyll_version[0:3] == [1, 1, 0] 
		   and not "Beta" in self.worker.argyll_version_string
		   and not "RC1" in self.worker.argyll_version_string
		   and not "RC2" in self.worker.argyll_version_string):
			# Windows wants matrix tags in XYZ LUT profiles,
			# which is satisfied with Argyll >= 1.1.0_RC3
			self.profile_types.insert(profile_types_index, 
									  lang.getstr("profile.type.lut_rg_swapped_matrix.xyz"))
			self.profile_types_ab[profile_types_index] = "x"  # XYZ LUT + dummy matrix (R <-> G swapped)
			profile_types_index += 1
		elif sys.platform != "win32":
			self.profile_types.insert(profile_types_index, 
									  lang.getstr("profile.type.lut.xyz"))
			self.profile_types_ab[profile_types_index] = "x"  # XYZ LUT
			profile_types_index += 1
		self.profile_type_ctrl.SetItems(self.profile_types)
		self.profile_types_ab[profile_types_index] = "l"
		self.profile_types_ab[profile_types_index + 1] = "s"
		self.profile_types_ab[profile_types_index + 2] = "S"
		self.profile_types_ab[profile_types_index + 3] = "g"
		self.profile_types_ab[profile_types_index + 4] = "G"
		self.profile_types_ba = swap_dict_keys_values(self.profile_types_ab)

	def init_measureframe(self):
		""" Create & initialize the measurement window and its controls. """
		self.measureframe = MeasureFrame(self, -1)

	def init_menus(self):
		""" Initialize the menus and menuitem event handlers. """
		res = TempXmlResource(get_data_path(os.path.join("xrc", 
														 "mainmenu.xrc")))
		self.menubar = res.LoadMenuBar("menu")
		
		file_ = self.menubar.GetMenu(self.menubar.FindMenu("menu.file"))
		menuitem = file_.FindItemById(file_.FindItem("calibration.load"))
		self.Bind(wx.EVT_MENU, self.load_cal_handler, menuitem)
		menuitem = file_.FindItemById(file_.FindItem("testchart.set"))
		self.Bind(wx.EVT_MENU, self.testchart_btn_handler, menuitem)
		self.menuitem_testchart_edit = file_.FindItemById(file_.FindItem("testchart.edit"))
		self.Bind(wx.EVT_MENU, self.create_testchart_btn_handler,
			self.menuitem_testchart_edit)
		menuitem = file_.FindItemById(file_.FindItem("profile.set_save_path"))
		self.Bind(wx.EVT_MENU, self.profile_save_path_btn_handler, menuitem)
		self.menuitem_profile_info = file_.FindItemById(file_.FindItem("profile.info"))
		self.Bind(wx.EVT_MENU, self.profile_info_handler, self.menuitem_profile_info)
		self.menuitem_create_profile = file_.FindItemById(
			file_.FindItem("create_profile"))
		self.Bind(wx.EVT_MENU, self.create_profile_handler, 
				  self.menuitem_create_profile)
		self.menuitem_create_profile_from_edid = file_.FindItemById(
			file_.FindItem("create_profile_from_edid"))
		self.Bind(wx.EVT_MENU, self.create_profile_from_edid, 
				  self.menuitem_create_profile_from_edid)
		self.menuitem_install_display_profile = file_.FindItemById(
			file_.FindItem("install_display_profile"))
		self.Bind(wx.EVT_MENU, self.select_install_profile_handler, 
				  self.menuitem_install_display_profile)
		self.menuitem_profile_share = file_.FindItemById(
			file_.FindItem("profile.share"))
		self.Bind(wx.EVT_MENU, self.profile_share_handler, 
				  self.menuitem_profile_share)
		if sys.platform != "darwin" or wx.VERSION >= (2, 9):
			file_.AppendSeparator()
		self.menuitem_prefs = file_.Append(
			-1 if wx.VERSION < (2, 9) or sys.platform != "darwin"
			else wx.ID_PREFERENCES,
			"&" + "menuitem.set_argyll_bin")
		self.Bind(wx.EVT_MENU, self.set_argyll_bin_handler, self.menuitem_prefs)
		if sys.platform != "darwin" or wx.VERSION >= (2, 9):
			file_.AppendSeparator()
		self.menuitem_quit = file_.Append(
			-1 if wx.VERSION < (2, 9) else wx.ID_EXIT, "&menuitem.quit\tCtrl+Q")
		self.Bind(wx.EVT_MENU, self.OnClose, self.menuitem_quit)

		options = self.menubar.GetMenu(self.menubar.FindMenu("menu.options"))
		self.menuitem_advanced_options = options.FindItemById(options.FindItem("advanced"))
		options_advanced = self.menuitem_advanced_options.SubMenu
		self.menu_advanced_options = options_advanced
		self.menuitem_skip_legacy_serial_ports = options_advanced.FindItemById(
			options_advanced.FindItem("skip_legacy_serial_ports"))
		self.Bind(wx.EVT_MENU, self.skip_legacy_serial_ports_handler, 
				  self.menuitem_skip_legacy_serial_ports)
		self.menuitem_use_separate_lut_access = options_advanced.FindItemById(
			options_advanced.FindItem("use_separate_lut_access"))
		self.Bind(wx.EVT_MENU, self.use_separate_lut_access_handler, 
				  self.menuitem_use_separate_lut_access)
		self.menuitem_do_not_use_video_lut = options_advanced.FindItemById(
			options_advanced.FindItem("calibration.do_not_use_video_lut"))
		self.Bind(wx.EVT_MENU, self.do_not_use_video_lut_handler, 
				  self.menuitem_do_not_use_video_lut)
		self.menuitem_allow_skip_sensor_cal = options_advanced.FindItemById(
			options_advanced.FindItem("allow_skip_sensor_cal"))
		self.Bind(wx.EVT_MENU, self.allow_skip_sensor_cal_handler, 
				  self.menuitem_allow_skip_sensor_cal)
		self.menuitem_show_advanced_options = options.FindItemById(
			options.FindItem("show_advanced_options"))
		self.Bind(wx.EVT_MENU, self.show_advanced_options_handler, 
				  self.menuitem_show_advanced_options)
		self.menuitem_enable_3dlut_tab = options.FindItemById(
			options.FindItem("3dlut.tab.enable"))
		self.Bind(wx.EVT_MENU, self.enable_3dlut_tab_handler, 
				  self.menuitem_enable_3dlut_tab)
		menuitem = options_advanced.FindItemById(options_advanced.FindItem("extra_args"))
		self.Bind(wx.EVT_MENU, self.extra_args_handler, menuitem)
		self.menuitem_enable_argyll_debug = options_advanced.FindItemById(
			options_advanced.FindItem("enable_argyll_debug"))
		self.Bind(wx.EVT_MENU, self.enable_argyll_debug_handler, 
				  self.menuitem_enable_argyll_debug)
		self.menuitem_enable_dry_run = options_advanced.FindItemById(
			options_advanced.FindItem("dry_run"))
		self.Bind(wx.EVT_MENU, self.enable_dry_run_handler, 
				  self.menuitem_enable_dry_run)
		self.menuitem_startup_sound = options.FindItemById(
			options.FindItem("startup_sound.enable"))
		self.Bind(wx.EVT_MENU, self.startup_sound_enable_handler, 
				  self.menuitem_startup_sound)
		self.menuitem_use_fancy_progress = options.FindItemById(
			options.FindItem("use_fancy_progress"))
		self.Bind(wx.EVT_MENU, self.use_fancy_progress_handler, 
				  self.menuitem_use_fancy_progress)
		menuitem = options.FindItemById(options.FindItem("restore_defaults"))
		self.Bind(wx.EVT_MENU, self.restore_defaults_handler, menuitem)
		
		tools = self.menubar.GetMenu(self.menubar.FindMenu("menu.tools"))
		tools_vcgt = tools.FindItemById(tools.FindItem("video_card_gamma_table")).SubMenu
		tools_reports = tools.FindItemById(tools.FindItem("report")).SubMenu
		tools_advanced = tools.FindItemById(tools.FindItem("advanced")).SubMenu
		tools_instrument = tools.FindItemById(tools.FindItem("instrument")).SubMenu
		tools_ccxx = tools.FindItemById(tools.FindItem("colorimeter_correction_matrix_file")).SubMenu
		self.menuitem_load_lut_from_cal_or_profile = tools_vcgt.FindItemById(
			tools_vcgt.FindItem("calibration.load_from_cal_or_profile"))
		self.Bind(wx.EVT_MENU, self.load_profile_cal_handler, 
				  self.menuitem_load_lut_from_cal_or_profile)
		self.menuitem_load_lut_from_display_profile = tools_vcgt.FindItemById(
			tools_vcgt.FindItem("calibration.load_from_display_profile"))
		self.Bind(wx.EVT_MENU, self.load_display_profile_cal, 
				  self.menuitem_load_lut_from_display_profile)
		self.menuitem_lut_reset = tools_vcgt.FindItemById(
			tools_vcgt.FindItem("calibration.reset"))
		self.Bind(wx.EVT_MENU, self.reset_cal, self.menuitem_lut_reset)
		self.menuitem_report_uncalibrated = tools_reports.FindItemById(
			tools_reports.FindItem("report.uncalibrated"))
		self.Bind(wx.EVT_MENU, self.report_uncalibrated_handler, 
			self.menuitem_report_uncalibrated)
		self.menuitem_report_calibrated = tools_reports.FindItemById(
			tools_reports.FindItem("report.calibrated"))
		self.Bind(wx.EVT_MENU, self.report_calibrated_handler, 
				  self.menuitem_report_calibrated)
		self.menuitem_calibration_verify = tools_reports.FindItemById(
			tools_reports.FindItem("calibration.verify"))
		self.Bind(wx.EVT_MENU, self.verify_calibration_handler, 
				  self.menuitem_calibration_verify)
		menuitem = tools_reports.FindItemById(
			tools_reports.FindItem("measurement_report.update"))
		self.Bind(wx.EVT_MENU, self.update_measurement_report, 
				  menuitem)
		self.menuitem_measure_uniformity = tools_reports.FindItemById(
			tools_reports.FindItem("report.uniformity"))
		self.Bind(wx.EVT_MENU, self.measure_uniformity_handler, 
				  self.menuitem_measure_uniformity)

		self.menuitem_measure_testchart = tools_advanced.FindItemById(
			tools_advanced.FindItem("measure.testchart"))
		self.Bind(wx.EVT_MENU, self.measure_handler, 
				  self.menuitem_measure_testchart)

		self.menuitem_profile_hires_b2a = tools_advanced.FindItemById(
			tools_advanced.FindItem("profile.b2a.hires"))
		self.Bind(wx.EVT_MENU, self.profile_hires_b2a_handler, 
				  self.menuitem_profile_hires_b2a)

		self.menuitem_measurement_file_check = tools_advanced.FindItemById(
			tools_advanced.FindItem("measurement_file.check_sanity"))
		self.Bind(wx.EVT_MENU, self.measurement_file_check_handler, 
				  self.menuitem_measurement_file_check)

		self.menuitem_measurement_file_check_auto = tools_advanced.FindItemById(
			tools_advanced.FindItem("measurement_file.check_sanity.auto"))
		self.Bind(wx.EVT_MENU, self.measurement_file_check_auto_handler, 
				  self.menuitem_measurement_file_check_auto)

		self.menuitem_import_colorimeter_correction = tools_ccxx.FindItemById(
			tools_ccxx.FindItem("colorimeter_correction.import"))
		self.Bind(wx.EVT_MENU, self.import_colorimeter_corrections_handler, 
				  self.menuitem_import_colorimeter_correction)
		self.menuitem_create_colorimeter_correction = tools_ccxx.FindItemById(
			tools_ccxx.FindItem("colorimeter_correction.create"))
		self.Bind(wx.EVT_MENU, self.create_colorimeter_correction_handler, 
				  self.menuitem_create_colorimeter_correction)
		self.menuitem_upload_colorimeter_correction = tools_ccxx.FindItemById(
			tools_ccxx.FindItem("colorimeter_correction.upload"))
		self.Bind(wx.EVT_MENU, self.upload_colorimeter_correction_handler, 
				  self.menuitem_upload_colorimeter_correction)

		self.menuitem_synthicc_create = tools_advanced.FindItemById(
			tools_advanced.FindItem("synthicc.create"))
		self.Bind(wx.EVT_MENU, self.synthicc_create_handler, 
				  self.menuitem_synthicc_create)

		self.menuitem_install_argyll_instrument_conf = tools_instrument.FindItemById(
			tools_instrument.FindItem("argyll.instrument.configuration_files.install"))
		self.menuitem_uninstall_argyll_instrument_conf = tools_instrument.FindItemById(
			tools_instrument.FindItem("argyll.instrument.configuration_files.uninstall"))
		if sys.platform in ("darwin", "win32") and not test:
			tools_instrument.RemoveItem(self.menuitem_install_argyll_instrument_conf)
			tools_instrument.RemoveItem(self.menuitem_uninstall_argyll_instrument_conf)
		else:
			# Linux may need instrument access being setup
			self.Bind(wx.EVT_MENU, self.install_argyll_instrument_conf, 
					  self.menuitem_install_argyll_instrument_conf)
			self.Bind(wx.EVT_MENU, self.uninstall_argyll_instrument_conf, 
					  self.menuitem_uninstall_argyll_instrument_conf)
		self.menuitem_install_argyll_instrument_drivers = tools_instrument.FindItemById(
			tools_instrument.FindItem("argyll.instrument.drivers.install"))
		self.menuitem_uninstall_argyll_instrument_drivers = tools_instrument.FindItemById(
			tools_instrument.FindItem("argyll.instrument.drivers.uninstall"))
		if sys.platform == "win32" or test:
			# Windows may need an Argyll CMS instrument driver
			self.Bind(wx.EVT_MENU, self.install_argyll_instrument_drivers, 
					  self.menuitem_install_argyll_instrument_drivers)
		else:
			# Other OS do not need an Argyll CMS instrument driver
			tools_instrument.RemoveItem(self.menuitem_install_argyll_instrument_drivers)
		if (sys.platform == "win32" and sys.getwindowsversion() >= (6, )) or test:
			# Windows Vista and newer can uninstall Argyll CMS instrument driver
			self.Bind(wx.EVT_MENU, self.uninstall_argyll_instrument_drivers, 
					  self.menuitem_uninstall_argyll_instrument_drivers)
		else:
			# Other OS cannot uninstall Argyll CMS instrument driver
			tools_instrument.RemoveItem(self.menuitem_uninstall_argyll_instrument_drivers)
		self.menuitem_enable_spyder2 = tools_instrument.FindItemById(
			tools_instrument.FindItem("enable_spyder2"))
		self.Bind(wx.EVT_MENU, self.enable_spyder2_handler, 
				  self.menuitem_enable_spyder2)
		self.menuitem_calibrate_instrument = tools_instrument.FindItemById(
			tools_instrument.FindItem("calibrate_instrument"))
		self.Bind(wx.EVT_MENU, self.calibrate_instrument_handler, 
				  self.menuitem_calibrate_instrument)
		menuitem = tools.FindItemById(
			tools.FindItem("detect_displays_and_ports"))
		self.Bind(wx.EVT_MENU, self.check_update_controls, menuitem)
		self.menuitem_show_lut = tools.FindItemById(
			tools.FindItem("calibration.show_lut"))
		self.Bind(wx.EVT_MENU, self.init_lut_viewer, self.menuitem_show_lut)
		self.menuitem_show_log = tools.FindItemById(tools.FindItem("infoframe.toggle"))
		self.Bind(wx.EVT_MENU, self.infoframe_toggle_handler, 
				  self.menuitem_show_log)
		self.menuitem_log_autoshow = tools.FindItemById(
			tools.FindItem("log.autoshow"))
		self.Bind(wx.EVT_MENU, self.infoframe_autoshow_handler, 
				  self.menuitem_log_autoshow)

		languages = self.menubar.GetMenu(self.menubar.FindMenu("menu.language"))
		llist = [(lang.ldict[lcode].get("!language", ""), lcode) for lcode in 
				 lang.ldict]
		llist.sort()
		for lstr, lcode in llist:
			menuitem = languages.Append(-1, "&" + lstr, kind=wx.ITEM_RADIO)
			if (lcode.upper().replace("EN", "US") in flagart.catalog):
				if (sys.platform in ("darwin", "win32") or
					menuitem.GetKind() == wx.ITEM_NORMAL):
					# This can fail under Linux with wxPython 3.0
					# because only normal menu items can have bitmaps
					# there. Working fine on all other platforms.
					menuitem.SetBitmap(
						flagart.catalog[lcode.upper().replace("EN", 
															  "US")].getBitmap())
			if lang.getcode() == lcode:
				menuitem.Check()
				font = menuitem.Font
				font.SetWeight(wx.BOLD)
				menuitem.SetFont(font)
			# Map numerical event id to language string
			lang.ldict[lcode].menuitem_id = menuitem.GetId()
			self.Bind(wx.EVT_MENU, self.set_language_handler, menuitem)

		help = self.menubar.GetMenu(self.menubar.FindMenu("menu.help"))
		self.menuitem_about = help.Append(
			-1 if wx.VERSION < (2, 9) else wx.ID_ABOUT, "&menu.about")
		self.Bind(wx.EVT_MENU, self.aboutdialog_handler, self.menuitem_about)
		self.menuitem_readme = help.FindItemById(help.FindItem("readme"))
		self.menuitem_readme.Enable(isinstance(get_data_path("README.html"), 
											   basestring))
		self.Bind(wx.EVT_MENU, self.readme_handler, self.menuitem_readme)
		self.menuitem_license = help.FindItemById(help.FindItem("license"))
		self.menuitem_license.Enable(isinstance(get_data_path("LICENSE.txt"), 
												basestring) or 
									 os.path.isfile("/usr/share/common-licenses/GPL-3"))
		self.Bind(wx.EVT_MENU, self.license_handler, self.menuitem_license)
		menuitem = help.FindItemById(help.FindItem("go_to_website"))
		self.Bind(wx.EVT_MENU, lambda event: launch_file("https://%s/" %
														 domain), menuitem)
		menuitem = help.FindItemById(help.FindItem("help_support"))
		self.Bind(wx.EVT_MENU, self.help_support_handler, menuitem)
		menuitem = help.FindItemById(help.FindItem("bug_report"))
		self.Bind(wx.EVT_MENU, self.bug_report_handler, menuitem)
		self.menuitem_app_auto_update_check = help.FindItemById(
			help.FindItem("update_check.onstartup"))
		self.Bind(wx.EVT_MENU, self.app_auto_update_check_handler,
				  self.menuitem_app_auto_update_check)
		menuitem = help.FindItemById(help.FindItem("update_check"))
		self.Bind(wx.EVT_MENU, self.app_update_check_handler, menuitem)
		
		if sys.platform == "darwin":
			wx.GetApp().SetMacAboutMenuItemId(self.menuitem_about.GetId())
			wx.GetApp().SetMacPreferencesMenuItemId(self.menuitem_prefs.GetId())
			wx.GetApp().SetMacExitMenuItemId(self.menuitem_quit.GetId())
			wx.GetApp().SetMacHelpMenuTitleName(lang.getstr("menu.help"))
	
	def update_menus(self):
		"""
		Enable/disable menu items based on available Argyll functionality.
		
		"""
		self.menuitem_testchart_edit.Enable(self.create_testchart_btn.Enabled)
		self.menuitem_measure_testchart.Enable(bool(self.worker.displays) and 
											   bool(self.worker.instruments))
		self.menuitem_create_profile.Enable(bool(self.worker.displays))
		edid = self.worker.get_display_edid()
		self.menuitem_create_profile_from_edid.Enable(bool(self.worker.displays
														   and edid
														   and edid.get("monitor_name",
																		edid.get("ascii",
																				 edid["product_id"]))
														   and edid["red_x"]
														   and edid["red_y"]
														   and edid["green_x"]
														   and edid["green_y"]
														   and edid["blue_x"]
														   and edid["blue_y"]))
		self.menuitem_profile_hires_b2a.Enable(self.worker.argyll_version > [0, 0, 0])
		self.menuitem_install_display_profile.Enable(bool(self.worker.displays) and
			not config.is_virtual_display())
		calibration_loading_supported = self.worker.calibration_loading_supported
		self.menuitem_load_lut_from_cal_or_profile.Enable(
			bool(self.worker.displays) and calibration_loading_supported)
		self.menuitem_load_lut_from_display_profile.Enable(
			bool(self.worker.displays) and calibration_loading_supported)
		self.menuitem_skip_legacy_serial_ports.Check(bool(getcfg("skip_legacy_serial_ports")))
		has_separate_lut_access = self.worker.has_separate_lut_access()
		self.menuitem_use_separate_lut_access.Check(has_separate_lut_access or
													bool(getcfg("use_separate_lut_access")))
		self.menuitem_use_separate_lut_access.Enable(not has_separate_lut_access)
		has_lut_access = self.worker.has_lut_access()
		do_not_use_video_lut = (self.worker.argyll_version >= [1, 3, 3] and
								(not has_lut_access or
								 not getcfg("calibration.use_video_lut")))
		self.menuitem_do_not_use_video_lut.Check(do_not_use_video_lut)
		self.menuitem_do_not_use_video_lut.Enable(self.worker.argyll_version >=
												  [1, 3, 3] and has_lut_access)
		self.menuitem_allow_skip_sensor_cal.Check(bool(getcfg("allow_skip_sensor_cal")))
		self.menuitem_calibrate_instrument.Enable(
			bool(self.worker.get_instrument_features().get("sensor_cal")))
		self.menuitem_enable_3dlut_tab.Check(bool(getcfg("3dlut.tab.enable")))
		self.menuitem_enable_argyll_debug.Check(bool(getcfg("argyll.debug")))
		self.menuitem_enable_dry_run.Check(bool(getcfg("dry_run")))
		self.menuitem_startup_sound.Check(bool(getcfg("startup_sound.enable")))
		self.menuitem_use_fancy_progress.Check(bool(getcfg("use_fancy_progress")))
		self.menuitem_advanced_options.Enable(bool(getcfg("show_advanced_options")))
		spyd2en = get_argyll_util("spyd2en")
		spyder2_firmware_exists = self.worker.spyder2_firmware_exists()
		if sys.platform == "win32" or test:
			self.menuitem_install_argyll_instrument_drivers.Enable(bool(get_data_path("usb/ArgyllCMS.inf")))
		if sys.platform not in ("darwin", "win32") or test:
			installed = self.worker.get_argyll_instrument_conf("installed")
			installable = self.worker.get_argyll_instrument_conf()
			# Only enable if not yet installed and installable
			self.menuitem_install_argyll_instrument_conf.Enable(
				bool(not installed and installable))
			# Only enable if installed and (re-)installable
			self.menuitem_uninstall_argyll_instrument_conf.Enable(
				bool(installed and installable))
		self.menuitem_enable_spyder2.Enable(bool(spyd2en))
		self.menuitem_enable_spyder2.Check(bool(spyd2en) and  
										   spyder2_firmware_exists)
		self.menuitem_show_lut.Enable(bool(LUTFrame) and
									  self.worker.argyll_version > [0, 0, 0])
		self.menuitem_show_lut.Check(bool(getcfg("lut_viewer.show")))
		if hasattr(self, "lut_viewer"):
			self.lut_viewer.update_controls()
		self.menuitem_lut_reset.Enable(bool(self.worker.displays) and
									   calibration_loading_supported)
		self.menuitem_report_calibrated.Enable(bool(self.worker.displays) and 
											   bool(self.worker.instruments) and
											   not config.is_non_argyll_display())
		self.menuitem_report_uncalibrated.Enable(bool(self.worker.displays) and 
												 bool(self.worker.instruments) and
												 not config.is_non_argyll_display())
		self.menuitem_calibration_verify.Enable(bool(self.worker.displays) and 
												bool(self.worker.instruments) and
												not config.is_non_argyll_display())
		self.mr_settings_btn.Enable(bool(self.worker.displays) and 
											bool(self.worker.instruments))
		self.menuitem_measure_uniformity.Enable(bool(self.worker.displays) and 
												bool(self.worker.instruments))
		self.menuitem_measurement_file_check_auto.Check(bool(getcfg("ti3.check_sanity.auto")))
		self.menuitem_create_colorimeter_correction.Enable(bool(get_argyll_util("ccxxmake")))
		self.menuitem_show_log.Check(bool(getcfg("log.show")))
		self.menuitem_log_autoshow.Enable(not bool(getcfg("log.show")))
		self.menuitem_log_autoshow.Check(bool(getcfg("log.autoshow")))
		self.menuitem_app_auto_update_check.Check(bool(getcfg("update_check")))

	def init_controls(self):
		"""
		Initialize the main window controls and their event handlers.
		
		"""

		for child in (self.display_box_label, self.instrument_box_label,
					  self.calibration_settings_label,
					  self.profile_settings_label, self.lut3d_settings_label,
					  self.mr_settings_label):
			font = child.Font
			font.SetWeight(wx.BOLD)
			child.Font = font

		# Settings file controls
		# ======================
		
		# Settings file dropdown
		self.Bind(wx.EVT_CHOICE, self.calibration_file_ctrl_handler, 
				  id=self.calibration_file_ctrl.GetId())
		self.Bind(wx.EVT_BUTTON, self.load_cal_handler, 
				  id=self.calibration_file_btn.GetId())
		self.Bind(wx.EVT_BUTTON, self.create_session_archive_handler, 
				  id=self.create_session_archive_btn.GetId())
		self.Bind(wx.EVT_BUTTON, self.delete_calibration_handler, 
				  id=self.delete_calibration_btn.GetId())
		self.Bind(wx.EVT_BUTTON, self.install_profile_handler, 
				  id=self.install_profile_btn.GetId())
		self.Bind(wx.EVT_BUTTON, self.profile_info_handler, 
				  id=self.profile_info_btn.GetId())

		# Update calibration checkbox
		self.Bind(wx.EVT_CHECKBOX, self.calibration_update_ctrl_handler, 
				  id=self.calibration_update_cb.GetId())

		# Display
		self.Bind(wx.EVT_CHOICE, self.display_ctrl_handler, 
				  id=self.display_ctrl.GetId())
		self.Bind(wx.EVT_CHOICE, self.display_lut_ctrl_handler, 
				  id=self.display_lut_ctrl.GetId())
		self.Bind(wx.EVT_BUTTON, self.display_lut_link_ctrl_handler, 
				  id=self.display_lut_link_ctrl.GetId())

		# Instrument
		self.Bind(wx.EVT_CHOICE, self.comport_ctrl_handler, 
				  id=self.comport_ctrl.GetId())
		self.Bind(wx.EVT_CHOICE, self.measurement_mode_ctrl_handler, 
				  id=self.measurement_mode_ctrl.GetId())
		self.Bind(wx.EVT_BUTTON, self.check_update_controls, 
				  id=self.detect_displays_and_ports_btn.GetId())

		# Display update delay & settle time
		min_val, max_val = config.valid_ranges["measure.min_display_update_delay_ms"]
		self.min_display_update_delay_ms.SetRange(min_val, max_val)

		min_val, max_val = config.valid_ranges["measure.display_settle_time_mult"]
		self.display_settle_time_mult.SetDigits(len(str(stripzeros(min_val)).split(".")[-1]))
		self.display_settle_time_mult.SetIncrement(min_val)
		self.display_settle_time_mult.SetRange(min_val, max_val)
		self.Bind(wx.EVT_CHECKBOX, self.display_delay_handler, 
				   id=self.override_min_display_update_delay_ms.GetId())
		self.Bind(wx.EVT_TEXT, self.display_delay_handler, 
				   id=self.min_display_update_delay_ms.GetId())
		self.Bind(wx.EVT_CHECKBOX, self.display_delay_handler, 
				   id=self.override_display_settle_time_mult.GetId())
		self.Bind(floatspin.EVT_FLOATSPIN, self.display_delay_handler, 
				   id=self.display_settle_time_mult.GetId())

		# Observer
		self.observer_ctrl.Bind(wx.EVT_CHOICE, self.observer_ctrl_handler)
		
		# Colorimeter correction matrix
		self.Bind(wx.EVT_CHOICE, self.colorimeter_correction_matrix_ctrl_handler, 
				  id=self.colorimeter_correction_matrix_ctrl.GetId())
		self.Bind(wx.EVT_BUTTON, self.colorimeter_correction_matrix_ctrl_handler, 
				  id=self.colorimeter_correction_matrix_btn.GetId())
		self.Bind(wx.EVT_BUTTON, self.colorimeter_correction_web_handler, 
				  id=self.colorimeter_correction_web_btn.GetId())
		self.colorimeter_correction_create_btn.Bind(wx.EVT_BUTTON,
			self.create_colorimeter_correction_handler)

		# Calibration settings
		# ====================

		# Whitepoint
		self.Bind(wx.EVT_CHOICE, self.whitepoint_ctrl_handler, 
				  id=self.whitepoint_ctrl.GetId())
		self.Bind(wx.EVT_COMBOBOX, self.whitepoint_ctrl_handler, 
				  id=self.whitepoint_colortemp_textctrl.GetId())
		self.whitepoint_colortemp_textctrl.SetItems(self.whitepoint_presets)
		self.whitepoint_colortemp_textctrl.Bind(
			wx.EVT_KILL_FOCUS, self.whitepoint_ctrl_handler)
		self.Bind(wx.EVT_CHOICE, self.whitepoint_colortemp_locus_ctrl_handler, 
				  id=self.whitepoint_colortemp_locus_ctrl.GetId())
		self.whitepoint_x_textctrl.Bind(floatspin.EVT_FLOATSPIN, 
										self.whitepoint_ctrl_handler)
		self.whitepoint_y_textctrl.Bind(floatspin.EVT_FLOATSPIN, 
										self.whitepoint_ctrl_handler)
		self.Bind(wx.EVT_BUTTON, self.ambient_measure_handler, 
				  id=self.whitepoint_measure_btn.GetId())
		self.Bind(wx.EVT_BUTTON, self.visual_whitepoint_editor_handler, 
				  id=self.visual_whitepoint_editor_btn.GetId())

		# White luminance
		self.Bind(wx.EVT_CHOICE, self.luminance_ctrl_handler, 
				  id=self.luminance_ctrl.GetId())
		self.luminance_textctrl.Bind(floatspin.EVT_FLOATSPIN, 
									 self.luminance_ctrl_handler)
		self.Bind(wx.EVT_CHECKBOX, self.whitelevel_drift_compensation_handler, 
				  id=self.whitelevel_drift_compensation.GetId())

		# Black luminance
		self.Bind(wx.EVT_CHOICE, self.black_luminance_ctrl_handler, 
				  id=self.black_luminance_ctrl.GetId())
		self.black_luminance_textctrl.Bind(floatspin.EVT_FLOATSPIN, 
										   self.black_luminance_ctrl_handler)
		self.Bind(wx.EVT_CHECKBOX, self.blacklevel_drift_compensation_handler, 
				  id=self.blacklevel_drift_compensation.GetId())

		# Tonal response curve (TRC)
		self.Bind(wx.EVT_CHOICE, self.trc_ctrl_handler, 
				  id=self.trc_ctrl.GetId())
		self.trc_textctrl.SetItems(self.trc_presets)
		self.trc_textctrl.SetValue(str(defaults["gamma"]))
		self.Bind(wx.EVT_COMBOBOX, self.trc_ctrl_handler, 
				  id=self.trc_textctrl.GetId())
		self.trc_textctrl.Bind(wx.EVT_KILL_FOCUS, self.trc_ctrl_handler)
		self.Bind(wx.EVT_CHOICE, self.trc_type_ctrl_handler, 
				  id=self.trc_type_ctrl.GetId())

		# Viewing condition adjustment for ambient in Lux
		self.Bind(wx.EVT_CHECKBOX, self.ambient_viewcond_adjust_ctrl_handler, 
				  id=self.ambient_viewcond_adjust_cb.GetId())
		self.ambient_viewcond_adjust_textctrl.Bind(
			floatspin.EVT_FLOATSPIN, self.ambient_viewcond_adjust_ctrl_handler)
		self.Bind(wx.EVT_BUTTON, self.ambient_measure_handler,
				  id=self.ambient_measure_btn.GetId())

		# Black level output offset
		self.Bind(wx.EVT_SLIDER, self.black_output_offset_ctrl_handler, 
				  id=self.black_output_offset_ctrl.GetId())
		self.Bind(wx.EVT_TEXT, self.black_output_offset_ctrl_handler, 
				  id=self.black_output_offset_intctrl.GetId())

		# Black point hue correction
		self.Bind(wx.EVT_CHECKBOX, self.black_point_correction_auto_handler, 
				  id=self.black_point_correction_auto_cb.GetId())
		self.Bind(wx.EVT_SLIDER, self.black_point_correction_ctrl_handler, 
				  id=self.black_point_correction_ctrl.GetId())
		self.Bind(wx.EVT_TEXT, self.black_point_correction_ctrl_handler, 
				  id=self.black_point_correction_intctrl.GetId())

		# Black point correction rate
		self.Bind(wx.EVT_SLIDER, self.black_point_rate_ctrl_handler, 
				  id=self.black_point_rate_ctrl.GetId())
		self.Bind(floatspin.EVT_FLOATSPIN, self.black_point_rate_ctrl_handler, 
				  id=self.black_point_rate_floatctrl.GetId())

		# Calibration quality
		self.Bind(wx.EVT_SLIDER, self.calibration_quality_ctrl_handler, 
				  id=self.calibration_quality_ctrl.GetId())

		# Interactive display adjustment
		self.Bind(wx.EVT_CHECKBOX, 
				  self.interactive_display_adjustment_ctrl_handler, 
				  id=self.interactive_display_adjustment_cb.GetId())

		# Profiling settings
		# ==================

		# Testchart file
		self.Bind(wx.EVT_CHOICE, self.testchart_ctrl_handler, 
				  id=self.testchart_ctrl.GetId())
		self.Bind(wx.EVT_BUTTON, self.testchart_btn_handler, 
				  id=self.testchart_btn.GetId())
		self.Bind(wx.EVT_BUTTON, self.create_testchart_btn_handler, 
				  id=self.create_testchart_btn.GetId())
		self.testchart_patches_amount_ctrl.SetRange(config.valid_values["testchart.auto_optimize"][1],
													config.valid_values["testchart.auto_optimize"][-1])
		self.testchart_patches_amount_ctrl.Bind(wx.EVT_SLIDER,
			self.testchart_patches_amount_ctrl_handler)

		# Profile quality
		self.Bind(wx.EVT_SLIDER, self.profile_quality_ctrl_handler, 
				  id=self.profile_quality_ctrl.GetId())

		# Profile type
		self.Bind(wx.EVT_CHOICE, self.profile_type_ctrl_handler, 
				  id=self.profile_type_ctrl.GetId())

		# Advanced (gamut mapping)
		self.Bind(wx.EVT_BUTTON, self.gamap_btn_handler, 
				  id=self.gamap_btn.GetId())

		# Black point compensation
		self.Bind(wx.EVT_CHECKBOX, 
				  self.black_point_compensation_ctrl_handler, 
				  id=self.black_point_compensation_cb.GetId())

		# Profile name
		self.Bind(wx.EVT_TEXT, self.profile_name_ctrl_handler, 
				  id=self.profile_name_textctrl.GetId())
		self.profile_name_info_btn.Bind(wx.EVT_BUTTON,
										self.profile_name_info_btn_handler)
		self.profile_name_info_btn.SetToolTipString(lang.getstr("profile.name"))
		self.Bind(wx.EVT_BUTTON, self.profile_save_path_btn_handler, 
				  id=self.profile_save_path_btn.GetId())

		# 3D LUT controls
		# ===============

		self.lut3d_create_cb.Bind(wx.EVT_CHECKBOX, self.lut3d_create_cb_handler)
		self.lut3d_init_input_profiles()
		self.lut3d_input_profile_ctrl.Bind(wx.EVT_CHOICE,
									 self.lut3d_input_colorspace_handler)
		self.lut3d_bind_event_handlers()

		# Main buttons
		# ============

		for btn_name in ("calibrate_btn", "calibrate_and_profile_btn",
						 "profile_btn", "lut3d_create_btn",
						 "measurement_report_btn"):
			btn = getattr(self, btn_name)
			# wx.Button does not look correct when a custom background color is
			# set because the button label background inherits the button
			# background. Replace with ThemedGenButton which does not have
			# that issue
			subst = BorderGradientButton(btn.Parent,
										 bitmap=geticon(16, "start"),
										 label=btn.Label, name=btn.Name)
			subst.SetBackgroundColour(btn.Parent.BackgroundColour)
			subst.SetTopStartColour(wx.Colour(252, 252, 252))
			subst.SetTopEndColour(wx.Colour(224, 224, 224))
			subst.SetBottomStartColour(wx.Colour(224, 224, 224))
			subst.SetBottomEndColour(wx.Colour(166, 166, 166))
			subst.SetForegroundColour(wx.Colour(0, 0, 0))
			subst.SetPressedTopColour(wx.Colour(166, 166, 166))
			subst.SetPressedBottomColour(wx.Colour(224, 224, 224))
			setattr(self, btn_name, subst)
			btn.ContainingSizer.Replace(btn, subst)
			btn.Destroy()
		
		self.Bind(wx.EVT_BUTTON, self.calibrate_btn_handler, 
				  id=self.calibrate_btn.GetId())
		self.Bind(wx.EVT_BUTTON, self.calibrate_and_profile_btn_handler, 
				  id=self.calibrate_and_profile_btn.GetId())
		self.Bind(wx.EVT_BUTTON, self.profile_btn_handler, 
				  id=self.profile_btn.GetId())
		self.lut3d_create_btn.Bind(wx.EVT_BUTTON,
								   self.lut3d_create_handler)
		self.measurement_report_btn.Bind(wx.EVT_BUTTON,
										 self.measurement_report_handler)

	def set_language_handler(self, event):
		"""
		Set a new language globally and on-the-fly.
		
		"""
		for lcode in lang.ldict:
			if lang.ldict[lcode].menuitem_id == event.GetId():
				# Get the previously marked menu item
				menuitem = self.menubar.FindItemById(
					lang.ldict[lang.getcode()].menuitem_id)
				if hasattr(self, "tcframe"):
					if not self.tcframe.tc_close_handler():
						# Do not change language, mark previous menu item
						menuitem.Check()
						return
					self.tcframe.Destroy()
					del self.tcframe
				# Set the previously marked menu item's font weight to normal
				font = menuitem.Font
				font.SetWeight(wx.NORMAL)
				menuitem.SetFont(font)
				# Set the currently marked menu item's font weight to bold
				menuitem = self.menubar.FindItemById(lang.ldict[lcode].menuitem_id)
				font = menuitem.Font
				font.SetWeight(wx.BOLD)
				menuitem.SetFont(font)
				setcfg("lang", lcode)
				writecfg()
				self.panel.Freeze()
				self.header.SetLabel(lang.getstr("header"))
				self.setup_language()
				if hasattr(self, "extra_args"):
					self.extra_args.Sizer.SetSizeHints(self.extra_args)
					self.extra_args.Sizer.Layout()
				if hasattr(self, "gamapframe"):
					self.gamapframe.panel.Freeze()
					self.gamapframe.setup_language()
					self.gamapframe.update_layout()
					self.gamapframe.panel.Thaw()
				if getattr(self, "lut3dframe", None):
					self.lut3dframe.panel.Freeze()
					self.lut3dframe.setup_language()
					self.lut3dframe.update_controls()
					self.lut3dframe.update_layout()
					self.lut3dframe.panel.Thaw()
				if getattr(self, "reportframe", None):
					self.reportframe.panel.Freeze()
					self.reportframe.setup_language()
					self.reportframe.update_controls()
					self.reportframe.update_layout()
					self.reportframe.panel.Thaw()
				if getattr(self, "synthiccframe", None):
					self.synthiccframe.panel.Freeze()
					self.synthiccframe.setup_language()
					self.synthiccframe.update_controls()
					self.synthiccframe.update_layout()
					self.synthiccframe.panel.Thaw()
				self.update_measurement_modes()
				self.update_controls()
				self.update_displays()
				self.set_testcharts()
				self.update_layout()
				self.panel.Thaw()
				if hasattr(self, "aboutdialog"):
					self.aboutdialog.Destroy()
					del self.aboutdialog
				log_txt = self.infoframe.log_txt.GetValue().encode("UTF-8",
																   "replace")
				if log_txt:
					# Remember current log window contents
					if not self.infoframe.IsShownOnScreen():
						# Append buffer of non-shown log window
						logbuffer.seek(0)
						log_txt += logbuffer.read()
					logbuffer.truncate(0)
					logbuffer.write(log_txt)
				self.infoframe.Destroy()
				self.init_infoframe(show=getcfg("log.show"))
				if sys.platform in ("darwin", "win32") or isexe:
					self.measureframe.Destroy()
					self.init_measureframe()
				if hasattr(self, "lut_viewer"):
					self.lut_viewer.Destroy()
					del self.lut_viewer
					if getcfg("lut_viewer.show"):
						# Using wx.CallAfter fixes wrong positioning under wxGTK
						# with wxPython 3
						wx.CallAfter(self.init_lut_viewer, show=True)
				if hasattr(self, "profile_name_tooltip_window"):
					self.profile_name_tooltip_window.Destroy()
					del self.profile_name_tooltip_window
				for progress_wnd in self.worker.progress_wnds:
					progress_wnd.Destroy()
				wx.CallAfter(self.Raise)
				threading.Thread(target=self.set_remote_language).start()
				break

	def set_remote_language(self):
		# Set language of all running standalone tools (if supported)
		app_ip, app_port = sys._appsocket.getsockname()
		for host in self.get_scripting_hosts():
			ip_port, name = host.split(None, 1)
			ip, port = ip_port.split(":", 1)
			port = int(port)
			if ip == app_ip and port == app_port:
				continue
			try:
				conn = self.connect(ip, port)
				if isinstance(conn, Exception):
					safe_print("Warning - couldn't connect to", ip_port,
							   "(%s):" % name, conn)
					continue
				conn.send_command("getappname")
				remote_appname = conn.get_single_response()
				if remote_appname == appname:
					safe_print("Warning - connected to self, skipping")
					del conn
					continue
				conn.send_command("setlanguage %s" % getcfg("lang"))
				response = conn.get_single_response()
				if response not in ("ok", "invalid"):
					safe_print("Warning - couldn't set language for", name,
							   "(%s):" % ip_port, response)
				if remote_appname == appname + "-apply-profiles":
					# Update notification text of profile loader
					conn.send_command("notify '%s' silent sticky" %
										   lang.getstr("app.detected.calibration_loading_disabled",
													   appname))
					response = conn.get_single_response()
					if response != "ok":
						safe_print("Warning - couldn't update profile loader "
								   "notification text:", response)
				del conn
			except Exception, exception:
				safe_print("Warning - error while trying to set language for",
						   name, "(%s)" % ip_port, exception)
	
	def update_layout(self):
		""" Update main window layout. """
		self.set_size(False, True)

	def restore_defaults_handler(self, event=None, include=(), exclude=(),
								 override=None):
		if event:
			dlg = ConfirmDialog(self, 
								msg=lang.getstr("app.confirm_restore_defaults"), 
								ok=lang.getstr("ok"), 
								cancel=lang.getstr("cancel"), 
								bitmap=getbitmap(
									"theme/icons/32x32/dialog-warning"))
			result = dlg.ShowModal()
			dlg.Destroy()
			if result != wx.ID_OK: return
		if getcfg("settings.changed"):
			self.settings_discard_changes()
		skip = [
			"allow_skip_sensor_cal",
			"app.allow_network_clients",
			"app.port",
			"argyll.dir",
			"argyll.version",
			"calibration.autoload",
			"calibration.black_point_rate.enabled",
			"calibration.file.previous",
			"calibration.update",
			"colorimeter_correction.instrument",
			"colorimeter_correction.instrument.reference",
			"colorimeter_correction.measurement_mode",
			"colorimeter_correction.measurement_mode.reference",
			"colorimeter_correction.measurement_mode.reference.projector",
			"colorimeter_correction_matrix_file",
			"comport.number",
			"copyright",
			"dimensions.measureframe.whitepoint.visual_editor",
			"display.number",
			"display.technology",
			"display_lut.link",
			"display_lut.number",
			"displays",
			"dry_run",
			"enumerate_ports.auto",
			"gamma",
			"iccgamut.surface_detail",
			"instruments",
			"lang",
			"last_3dlut_path",
			"last_cal_path",
			"last_cal_or_icc_path",
			"last_colorimeter_ti3_path",
			"last_filedialog_path",
			"last_icc_path",
			"last_reference_ti3_path",
			"last_testchart_export_path",
			"last_ti1_path",
			"last_ti3_path",
			"last_vrml_path",
			"log.show",
			"lut_viewer.show",
			"lut_viewer.show_actual_lut",
			"measurement_mode",
			"measurement_mode.projector",
			"measurement.name.expanded",
			"measurement.play_sound",
			"measurement.save_path",
			"patterngenerator.apl",
			"patterngenerator.resolve",
			"patterngenerator.resolve.port",
			"patterngenerator.resolve.use_video_levels",
			"profile.b2a.hires.diagpng",
			"profile.create_gamut_views",
			"profile.install_scope",
			"profile.license",
			"profile.load_on_login",
			"profile.name",
			"profile.name.expanded",
			"profile.save_path",
			"profile_loader.check_gamma_ramps",
			"profile_loader.error.show_msg",
			"profile_loader.exceptions",
			"profile_loader.fix_profile_associations",
			"profile_loader.known_apps",
			"profile_loader.known_window_classes",
			"profile_loader.reset_gamma_ramps",
			"profile_loader.use_madhcnet",
			"profile_loader.verify_calibration",
			"profile.update",
			"position.x",
			"position.y",
			"position.info.x",
			"position.info.y",
			"position.lut_viewer.x",
			"position.lut_viewer.y",
			"position.lut3dframe.x",
			"position.lut3dframe.y",
			"position.synthiccframe.x",
			"position.synthiccframe.y",
			"position.profile_info.x",
			"position.profile_info.y",
			"position.progress.x",
			"position.progress.y",
			"position.reportframe.x",
			"position.reportframe.y",
			"position.scripting.x",
			"position.scripting.y",
			"position.tcgen.x",
			"position.tcgen.y",
			"recent_cals",
			"report.pack_js",
			"settings.changed",
			"show_advanced_options",
			"show_donation_message",
			"skip_legacy_serial_ports",
			"skip_scripts",
			"sudo.preserve_environment",
			"tc_precond_profile",
			"tc_vrml_cie",
			"tc_vrml_cie_colorspace",
			"tc_vrml_device",
			"tc_vrml_device_colorspace",
			"tc.show",
			"uniformity.measure.continuous",
			"untethered.measure.auto",
			"untethered.measure.manual.delay",
			"untethered.max_delta.chroma",
			"untethered.min_delta",
			"untethered.min_delta.lightness",
			"update_check",
			"webserver.portnumber",
			"whitepoint.visual_editor.bg_v",
			"whitepoint.visual_editor.b",
			"whitepoint.visual_editor.g",
			"whitepoint.visual_editor.r",
			"x3dom.cache",
			"x3dom.embed"
		]
		override_default = {
			"app.dpi": None,
			"calibration.black_luminance": None,
			"calibration.luminance": None,
			"gamap_src_viewcond": "mt",
			"gamap_out_viewcond": "mt",
			"testchart.file": "auto",
			"trc": defaults["gamma"],
			"whitepoint.colortemp": None,
			"whitepoint.x": None,
			"whitepoint.y": None
		}
		if override:
			override_default.update(override)
		override = override_default
		for name in defaults:
			if name not in skip and name not in override:
				if (len(include) == 0 or False in [name.find(item) != 0 for 
												   item in include]) and \
				   (len(exclude) == 0 or not (False in [name.find(item) != 0 for 
														item in exclude])):
					if name.endswith(".backup"):
						if name == "measurement_mode.backup":
							setcfg("measurement_mode",
								   getcfg("measurement_mode.backup"))
						default = None
					else:
						default = defaults[name]
					if verbose >= 3:
						safe_print("Restoring %s to %s" % (name, default))
					setcfg(name, default)
		for name in override:
			if (len(include) == 0 or False in [name.find(item) != 0 for item in 
											   include]) and \
			   (len(exclude) == 0 or not (False in [name.find(item) != 0 for 
													item in exclude])):
				setcfg(name, override[name])
		if event:
			writecfg()
			self.update_displays()
			self.update_controls()
			self.update_menus()
			if hasattr(self, "tcframe"):
				self.tcframe.tc_update_controls()

	def cal_changed(self, setchanged=True):
		"""
		Called internally when calibration settings controls are changed.
		
		Exceptions are the calibration quality and interactive display
		adjustment controls, which do not cause a 'calibration changed' event.
		
		"""
		if not self.updatingctrls and self.IsShownOnScreen():
			# update_controls which is called from cal_changed might cause a 
			# another cal_changed call, in which case we can skip it
			if debug:
				safe_print("[D] cal_changed")
			if setchanged:
				setcfg("settings.changed", 1)
			self.worker.options_dispcal = []
			if getcfg("calibration.file", False):
				setcfg("calibration.file", None)
				# Load LUT curves from current display profile (if any, and if 
				# it contains curves)
				self.load_display_profile_cal(None)
			self.calibration_file_ctrl.SetStringSelection(
				lang.getstr("settings.new"))
			self.calibration_file_ctrl.SetToolTip(None)
			self.create_session_archive_btn.Disable()
			self.delete_calibration_btn.Disable()
			self.install_profile_btn.Disable()
			do_update_controls = self.calibration_update_cb.GetValue()
			self.calibration_update_cb.SetValue(False)
			setcfg("calibration.update", 0)
			self.calibration_update_cb.Disable()
			setcfg("profile.update", 0)
			if do_update_controls:
				self.update_controls()
			self.settings_discard_changes(keep_changed_state=True)

	def update_displays(self, update_ccmx_items=False, set_height=False):
		""" Update the display selector controls. """
		if debug:
			safe_print("[D] update_displays")
		self.panel.Freeze()
		self.displays = []
		for item in self.worker.displays:
			self.displays.append(item.replace("[PRIMARY]", 
											  lang.getstr("display.primary")))
			self.displays[-1] = lang.getstr(self.displays[-1])
		self.display_ctrl.SetItems(self.displays)
		self.display_ctrl.Enable(len(self.worker.displays) > 1)
		display_lut_sizer = self.display_ctrl.GetContainingSizer()
		display_sizer = self.display_lut_link_ctrl.GetContainingSizer()
		comport_sizer = self.comport_ctrl.GetContainingSizer()
		use_lut_ctrl = self.worker.has_separate_lut_access() or \
					   bool(getcfg("use_separate_lut_access"))
		menubar = self.GetMenuBar()
		menuitem = self.menu_advanced_options.FindItemById(
			self.menu_advanced_options.FindItem(lang.getstr("use_separate_lut_access")))
		menuitem.Check(use_lut_ctrl)
		if use_lut_ctrl:
			self.display_lut_ctrl.Clear()
			for i, disp in enumerate(self.displays):
				if self.worker.lut_access[i]:
					self.display_lut_ctrl.Append(disp)
			comport_sizer.SetCols(1)
			comport_sizer.SetRows(2)
		else:
			comport_sizer.SetCols(2)
			comport_sizer.SetRows(1)
			setcfg("display_lut.link", 1)
		display_lut_sizer.Show(self.display_label, use_lut_ctrl)
		display_lut_sizer.Show(self.display_lut_label, use_lut_ctrl)
		display_lut_sizer.Show(self.display_lut_ctrl, use_lut_ctrl)
		display_sizer.Show(self.display_lut_link_ctrl, use_lut_ctrl)
		self.get_set_display(update_ccmx_items)
		self.calpanel.Layout()
		self.panel.Thaw()
		if self.IsShown():
			self.set_size(set_height)
		self.update_scrollbars()
	
	def update_scrollbars(self):
		self.Freeze()
		self.calpanel.SetVirtualSize(self.calpanel.GetBestVirtualSize())
		self.Thaw()

	def update_comports(self, force=False):
		""" Update the comport selector control. """
		self.comport_ctrl.Freeze()
		self.comport_ctrl.SetItems(self.worker.instruments)
		if self.worker.instruments:
			self.comport_ctrl.SetSelection(
				min(max(0, len(self.worker.instruments) - 1), 
					max(0, int(getcfg("comport.number")) - 1)))
		self.comport_ctrl.Enable(len(self.worker.instruments) > 1)
		self.comport_ctrl.Thaw()
		self.comport_ctrl_handler(force=force)

	def update_measurement_mode(self):
		""" Update the measurement mode control. """
		measurement_mode = getcfg("measurement_mode")
		instrument_features = self.worker.get_instrument_features()
		if instrument_features.get("adaptive_mode") and (
		   self.worker.argyll_version[0:3] > [1, 1, 0] or (
		   self.worker.argyll_version[0:3] == [1, 1, 0] and
		   not "Beta" in self.worker.argyll_version_string and
		   not "RC1" in self.worker.argyll_version_string and
		   not "RC2" in self.worker.argyll_version_string)) and \
		   getcfg("measurement_mode.adaptive"):
			measurement_mode += "V"
		if instrument_features.get("highres_mode") and \
		   getcfg("measurement_mode.highres"):
			measurement_mode += "H"
		self.measurement_mode_ctrl.SetSelection(
			min(self.measurement_modes_ba[self.get_instrument_type()].get(
					measurement_mode, 1), 
				len(self.measurement_mode_ctrl.GetItems()) - 1))
	
	def get_measurement_modes(self, instrument_name, instrument_type,
							  cfgname="measurement_mode"):
		measurement_mode = getcfg(cfgname)
		#if self.get_instrument_type() == "spect":
			#measurement_mode = strtr(measurement_mode, {"c": "", "l": ""})
		if instrument_name != "DTP92":
			measurement_modes = dict({instrument_type: [lang.getstr("measurement_mode.refresh"),
														lang.getstr("measurement_mode.lcd")]})
			measurement_modes_ab = dict({instrument_type: ["c", "l"]})
		else:
			measurement_modes = dict({instrument_type: [lang.getstr("measurement_mode.refresh")]})
			measurement_modes_ab = dict({instrument_type: ["c"]})
		if (instrument_name in ("Spyder4", "Spyder5") and
			self.worker.spyder4_cal_exists()):
			# Spyder4 Argyll CMS >= 1.3.6
			# Spyder5 Argyll CMS >= 1.7.0
			# See http://www.argyllcms.com/doc/instruments.html#spyd4
			# for description of supported modes
			measurement_modes[instrument_type].extend([lang.getstr("measurement_mode.lcd.ccfl"),
													   lang.getstr("measurement_mode.lcd.wide_gamut.ccfl"),
													   lang.getstr("measurement_mode.lcd.white_led"),
													   lang.getstr("measurement_mode.lcd.wide_gamut.rgb_led"),
													   lang.getstr("measurement_mode.lcd.ccfl.2")])
			if self.worker.argyll_version >= [1, 5, 0]:
				measurement_modes_ab[instrument_type].extend(["f", "L", "e",
															  "B", "x"])
			else:
				measurement_modes_ab[instrument_type].extend(["3", "4", "5",
															  "6", "7"])
		elif instrument_name in ("ColorHug", "ColorHug2"):
			# Argyll CMS 1.3.6, spectro/colorhug.c, colorhug_disptypesel
			# Note: projector mode (-yp) is not the same as ColorMunki
			# projector mode! (-p)
			# ColorHug2 needs Argyll CMS 1.7
			measurement_modes[instrument_type].extend([lang.getstr("projector"),
													   lang.getstr("measurement_mode.lcd.white_led"),
													   lang.getstr("measurement_mode.factory"),
													   lang.getstr("measurement_mode.raw"),
													   lang.getstr("auto")])
			measurement_modes_ab[instrument_type].extend(["p", "e", "F", "R", "auto"])
		elif (instrument_name == "DTP94" and
			  self.worker.argyll_version >= [1, 5, 0]):
			# Argyll CMS 1.5.x introduces new measurement mode
			measurement_modes[instrument_type].extend([lang.getstr("measurement_mode.generic")])
			measurement_modes_ab[instrument_type].append("g")
		elif instrument_name == "ColorMunki Smile":
			# Only supported in Argyll CMS 1.5.x and newer
			measurement_modes[instrument_type] = [lang.getstr("measurement_mode.lcd.ccfl"),
												  lang.getstr("measurement_mode.lcd.white_led")]
			measurement_modes_ab[instrument_type] = ["f", "e"]
		elif (instrument_name == "Colorimtre HCFR" and
			  self.worker.argyll_version >= [1, 5, 0]):
			# Argyll CMS 1.5.x introduces new measurement mode
			measurement_modes[instrument_type].extend([lang.getstr("measurement_mode.raw")])
			measurement_modes_ab[instrument_type].append("R")
		elif instrument_name == "K-10":
			measurement_modes[instrument_type] = []
			measurement_modes_ab[instrument_type] = []
			for mode, desc in self.worker.get_instrument_measurement_modes().iteritems():
				measurement_modes[instrument_type].append(lang.getstr(desc))
				measurement_modes_ab[instrument_type].append(mode)
			if not measurement_mode in measurement_modes_ab[instrument_type]:
				measurement_mode = "F"
		instrument_features = self.worker.get_instrument_features(instrument_name)
		if instrument_features.get("projector_mode") and \
		   self.worker.argyll_version >= [1, 1, 0]:
			# Projector mode introduced in Argyll 1.1.0 Beta
			measurement_modes[instrument_type].append(lang.getstr("projector"))
			measurement_modes_ab[instrument_type].append("p")
		if not measurement_mode in measurement_modes_ab[instrument_type]:
			if measurement_modes_ab[instrument_type]:
				measurement_mode = measurement_modes_ab[instrument_type][0]
			else:
				measurement_mode = defaults["measurement_mode"]
		if instrument_features.get("adaptive_mode") and (
		   self.worker.argyll_version[0:3] > [1, 1, 0] or (
		   self.worker.argyll_version[0:3] == [1, 1, 0] and
		   not "Beta" in self.worker.argyll_version_string and
		   not "RC1" in self.worker.argyll_version_string and
		   not "RC2" in self.worker.argyll_version_string)):
			# Adaptive mode introduced in Argyll 1.1.0 RC3
			for key in iter(measurement_modes):
				instrument_modes = list(measurement_modes[key])
				for i, mode in reversed(zip(xrange(0, len(instrument_modes)), 
										    instrument_modes)):
					if mode == lang.getstr("default"):
						mode = lang.getstr("measurement_mode.adaptive")
					else:
						mode = "%s %s" % (mode,
										  lang.getstr("measurement_mode.adaptive"))
					measurement_modes[key].insert(i + 1, mode)
					modesig = measurement_modes_ab[key][i]
					measurement_modes_ab[key].insert(i + 1, (modesig or "") + "V")
			if getcfg(cfgname + ".adaptive"):
				measurement_mode += "V"
		if instrument_features.get("highres_mode"):
			for key in iter(measurement_modes):
				instrument_modes = list(measurement_modes[key])
				for i, mode in reversed(zip(xrange(0, len(instrument_modes)), 
											instrument_modes)):
					if mode == lang.getstr("default"):
						mode = lang.getstr("measurement_mode.highres")
					else:
						mode = "%s %s" % (mode,
										  lang.getstr("measurement_mode.highres"))
					measurement_modes[key].insert(i + 1, mode)
					modesig = measurement_modes_ab[key][i]
					measurement_modes_ab[key].insert(i + 1, (modesig or "") + "H")
			if getcfg(cfgname + ".highres"):
				measurement_mode += "H"
		measurement_modes_ab = dict(zip(measurement_modes_ab.keys(), 
										[dict(zip(range(len(measurement_modes_ab[key])), 
												  measurement_modes_ab[key])) 
												  for key in measurement_modes_ab]))
		measurement_modes_ba = dict(zip(measurement_modes_ab.keys(), 
										[swap_dict_keys_values(measurement_modes_ab[key]) 
										 for key in measurement_modes_ab]))
		return (measurement_mode, measurement_modes, measurement_modes_ab,
				measurement_modes_ba)
	
	def update_measurement_modes(self):
		""" Populate the measurement mode control. """
		instrument_name = self.worker.get_instrument_name()
		instrument_type = self.get_instrument_type()
		(measurement_mode,
		 measurement_modes,
		 measurement_modes_ab,
		 measurement_modes_ba) = self.get_measurement_modes(instrument_name,
															instrument_type)
		self.measurement_modes_ab = measurement_modes_ab
		self.measurement_modes_ba = measurement_modes_ba
		self.measurement_mode_ctrl.Freeze()
		self.measurement_mode_ctrl.SetItems(measurement_modes[instrument_type])
		self.measurement_mode_ctrl.SetSelection(
			min(self.measurement_modes_ba[instrument_type].get(measurement_mode, 
															   1), 
				len(measurement_modes[instrument_type]) - 1))
		measurement_mode = self.get_measurement_mode() or "l"
		if measurement_mode != "auto":
			measurement_mode = measurement_mode[0]
		setcfg("measurement_mode", measurement_mode)
		self.measurement_mode_ctrl.Enable(
			bool(self.worker.instruments) and 
			len(measurement_modes[instrument_type]) > 1)
		self.measurement_mode_ctrl.Thaw()
	
	def update_colorimeter_correction_matrix_ctrl(self):
		""" Show or hide the colorimeter correction matrix controls """
		self.panel.Freeze()
		self.update_adjustment_controls()
		instrument_features = self.worker.get_instrument_features()
		show_control = (self.worker.instrument_can_use_ccxx(False) and
						not is_ccxx_testchart() and
						getcfg("measurement_mode") != "auto")
		self.colorimeter_correction_matrix_ctrl.GetContainingSizer().Show(
			self.colorimeter_correction_matrix_ctrl, show_control)
		self.colorimeter_correction_matrix_label.GetContainingSizer().Show(
			self.colorimeter_correction_matrix_label, show_control)
		self.colorimeter_correction_matrix_btn.GetContainingSizer().Show(
			self.colorimeter_correction_matrix_btn, show_control)
		self.colorimeter_correction_web_btn.GetContainingSizer().Show(
			self.colorimeter_correction_web_btn, show_control)
		self.colorimeter_correction_create_btn.ContainingSizer.Show(
			self.colorimeter_correction_create_btn, show_control)
		self.calpanel.Layout()
		self.panel.Thaw()
		if self.IsShown():
			wx.CallAfter(self.set_size, True)
			wx.CallLater(1, self.update_scrollbars)
	
	def delete_colorimeter_correction_matrix_ctrl_item(self, path):
		if path in self.ccmx_cached_paths:
			self.ccmx_cached_paths.remove(path)
		if path in self.ccmx_cached_descriptors:
			del self.ccmx_cached_descriptors[path]
		if path in self.ccmx_instruments:
			del self.ccmx_instruments[path]
		delete = False
		for key, value in self.ccmx_mapping.iteritems():
			if value == path:
				delete = True
				break
		if delete:
			del self.ccmx_mapping[key]
	
	def update_colorimeter_correction_matrix_ctrl_items(self, force=False,
														warn_on_mismatch=False,
														update_measurement_mode=True):
		"""
		Show the currently selected correction matrix and list all files
		in ccmx directories below
		
		force	If True, reads the ccmx directory again, otherwise uses a
				previously cached result if available
		
		"""
		items = [lang.getstr("colorimeter_correction.file.none"),
				 lang.getstr("auto")]
		self.ccmx_item_paths = []
		index = 0
		ccxx_path = None
		ccmx = getcfg("colorimeter_correction_matrix_file").split(":", 1)
		if len(ccmx) > 1 and not os.path.isfile(ccmx[1]):
			ccmx = ccmx[:1]
		if force or not getattr(self, "ccmx_cached_paths", None):
			ccmx_paths = self.get_argyll_data_files("lu", "*.ccmx")
			ccss_paths = self.get_argyll_data_files("lu", "*.ccss")
			ccmx_paths.sort(key=os.path.basename)
			ccss_paths.sort(key=os.path.basename)
			self.ccmx_cached_paths = ccmx_paths + ccss_paths
			self.ccmx_cached_descriptors = {}
			self.ccmx_instruments = {}
			self.ccmx_mapping = {}
		types = {"ccss": lang.getstr("spectral").replace(":", ""),
				 "ccmx": lang.getstr("matrix").replace(":", "")}
		add_basename_to_desc_on_mismatch = False
		for i, path in enumerate(self.ccmx_cached_paths):
			if self.ccmx_cached_descriptors.get(path):
				desc = self.ccmx_cached_descriptors[path]
			elif os.path.isfile(path):
				try:
					cgats = CGATS.CGATS(path)
				except (IOError, CGATS.CGATSError), exception:
					safe_print("%s:" % path, exception)
					continue
				desc = safe_unicode(cgats.get_descriptor(), "UTF-8")
				# If the description is not the same as the 'sane'
				# filename, add the filename after the description
				# (max 31 chars)
				# See also colorimeter_correction_check_overwite, the
				# way the filename is processed must be the same
				if (add_basename_to_desc_on_mismatch and
					re.sub(r"[\\/:;*?\"<>|]+", "_",
						   make_argyll_compatible_path(desc)) !=
					os.path.splitext(os.path.basename(path))[0]):
					desc = "%s <%s>" % (ellipsis(desc, 66, "m"),
										ellipsis(os.path.basename(path), 31,
												 "m"))
				else:
					desc = ellipsis(desc, 100, "m")
				self.ccmx_cached_descriptors[path] = desc
				self.ccmx_instruments[path] = get_canonical_instrument_name(
					str(cgats.queryv1("INSTRUMENT") or
									  ""), {"DTP94-LCD mode": "DTP94",
											"eye-one display": "i1 Display",
											"Spyder 2 LCD": "Spyder2",
											"Spyder 3": "Spyder3"})
				key = "%s\0%s" % (self.ccmx_instruments[path],
								  str(cgats.queryv1("DISPLAY") or ""))
				if (not self.ccmx_mapping.get(key) or
					(len(ccmx) > 1 and path == ccmx[1])):
					# Prefer the selected CCMX
					self.ccmx_mapping[key] = path
			else:
				continue
			if (self.worker.get_instrument_name().lower().replace(" ", "") in
				self.ccmx_instruments.get(path, "").lower().replace(" ", "") or
				(path.lower().endswith(".ccss") and
				 self.worker.instrument_supports_ccss())):
				# Only add the correction to the list if it matches the
				# currently selected instrument or if it is a CCSS
				if len(ccmx) > 1 and ccmx[0] != "AUTO" and ccmx[1] == path:
					ccxx_path = path
				items.append("%s: %s" %
							 (types.get(os.path.splitext(path)[1].lower()[1:]),
							  desc))
				self.ccmx_item_paths.append(path)
		items_paths = []
		for i, item in enumerate(items[2:]):
			items_paths.append({"item": item, "path": self.ccmx_item_paths[i]})
		items_paths.sort(key=lambda item_path: item_path["item"].lower())
		for i, item_path in enumerate(items_paths):
			items[i + 2] = item_path["item"]
			self.ccmx_item_paths[i] = item_path["path"]
		if ccxx_path:
			index = self.ccmx_item_paths.index(ccxx_path) + 2
		if (len(ccmx) > 1 and ccmx[1] and ccmx[1] not in self.ccmx_cached_paths
			and (not ccmx[1].lower().endswith(".ccss") or
				 self.worker.instrument_supports_ccss())):
			self.ccmx_cached_paths.insert(0, ccmx[1])
			desc = self.ccmx_cached_descriptors.get(ccmx[1])
			if not desc and os.path.isfile(ccmx[1]):
				try:
					cgats = CGATS.CGATS(ccmx[1])
				except (IOError, CGATS.CGATSError), exception:
					safe_print("%s:" % ccmx[1], exception)
				else:
					desc = safe_unicode(cgats.get_descriptor(), "UTF-8")
					# If the description is not the same as the 'sane'
					# filename, add the filename after the description
					# (max 31 chars)
					# See also colorimeter_correction_check_overwite, the
					# way the filename is processed must be the same
					if (add_basename_to_desc_on_mismatch and
						re.sub(r"[\\/:;*?\"<>|]+", "_",
							   make_argyll_compatible_path(desc)) !=
						os.path.splitext(os.path.basename(ccmx[1]))[0]):
						desc = "%s <%s>" % (ellipsis(desc, 66, "m"),
											ellipsis(os.path.basename(ccmx[1]),
													 31, "m"))
					else:
						desc = ellipsis(desc, 100, "m")
					self.ccmx_cached_descriptors[ccmx[1]] = desc
					self.ccmx_instruments[ccmx[1]] = get_canonical_instrument_name(
						str(cgats.queryv1("INSTRUMENT") or
										  ""), {"DTP94-LCD mode": "DTP94",
												"eye-one display": "i1 Display",
												"Spyder 2 LCD": "Spyder2",
												"Spyder 3": "Spyder3"})
					key = "%s\0%s" % (self.ccmx_instruments[ccmx[1]],
									  str(cgats.queryv1("DISPLAY") or ""))
					self.ccmx_mapping[key] = ccmx[1]
			if (desc and
				(self.worker.get_instrument_name().lower().replace(" ", "") in
				 self.ccmx_instruments.get(ccmx[1], "").lower().replace(" ", "") or
				 ccmx[1].lower().endswith(".ccss"))):
				# Only add the correction to the list if it matches the
				# currently selected instrument or if it is a CCSS
				items.insert(2, "%s: %s" %
								(types.get(os.path.splitext(ccmx[1])[1].lower()[1:]),
								 desc))
				self.ccmx_item_paths.insert(0, ccmx[1])
				if ccmx[0] != "AUTO":
					index = 2
		if ccmx[0] == "AUTO":
			if len(ccmx) < 2:
				ccmx.append("")
			display_name = self.worker.get_display_name(False, True, False)
			if self.worker.instrument_supports_ccss():
				# Prefer CCSS
				ccmx[1] = self.ccmx_mapping.get("\0%s" % display_name, "")
			if not self.worker.instrument_supports_ccss() or not ccmx[1]:
				ccmx[1] = self.ccmx_mapping.get("%s\0%s" %
												(self.worker.get_instrument_name(),
												 display_name), "")
		if (self.worker.instrument_can_use_ccxx() and len(ccmx) > 1 and
			ccmx[1] and ccmx[1] not in self.ccmx_item_paths):
			# CCMX does not match the currently selected instrument,
			# don't use
			ccmx = [""]
			if warn_on_mismatch:
				show_result_dialog(Warn(lang.getstr("colorimeter_correction.instrument_mismatch")), self)
		elif ccmx[0] == "AUTO":
			index = 1
			if ccmx[1]:
				items[1] += " (%s: %s)" % (types.get(os.path.splitext(ccmx[1])[1].lower()[1:]),
										   self.ccmx_cached_descriptors[ccmx[1]])
			else:
				items[1] += " (%s)" % lang.getstr("colorimeter_correction.file.none")
		use_ccmx = (self.worker.instrument_can_use_ccxx(False) and
					len(ccmx) > 1 and ccmx[1])
		tech = None
		observer = None
		if use_ccmx:
			mode = None
			try:
				cgats = CGATS.CGATS(ccmx[1])
			except (IOError, CGATS.CGATSError), exception:
				safe_print("%s:" % ccmx[1], exception)
			else:
				if getcfg("measurement_mode") != "auto":
					tech = cgats.queryv1("TECHNOLOGY")
					# Set appropriate measurement mode
					# IMPORTANT: Make changes aswell in the following locations:
					# - DisplayCAL.get_cgats_measurement_mode
					mode = get_cgats_measurement_mode(cgats,
						self.worker.get_instrument_name())
				observer = cgats.queryv1("OBSERVER")
				if observer in self.observers_ab:
					setcfg("observer", observer)
					self.update_observer_ctrl()
					self.observer_ctrl.Disable()
			if mode or (getcfg("measurement_mode") != "auto" and
						not self.worker.instrument_can_use_ccxx()):
				if (update_measurement_mode or
					mode == getcfg("measurement_mode")):
					setcfg("measurement_mode", mode)
					self.update_measurement_mode()
				else:
					ccmx = ["", ""]
					index = 0
					tech = None
		if not tech:
			tech = self.worker.get_instrument_measurement_modes().get(
				getcfg("measurement_mode"))
		setcfg("display.technology", tech)
		setcfg("colorimeter_correction_matrix_file", ":".join(ccmx))
		self.colorimeter_correction_matrix_ctrl.Freeze()
		self.colorimeter_correction_matrix_ctrl.SetItems(items)
		self.colorimeter_correction_matrix_ctrl.SetSelection(index)
		self.colorimeter_correction_matrix_ctrl.Thaw()
		if use_ccmx:
			tooltip = ccmx[1]
		else:
			tooltip = ""
		self.update_main_controls()
		self.colorimeter_correction_matrix_ctrl.SetToolTipString(tooltip)
		self.update_estimated_measurement_times()
		if not observer in self.observers_ab:
			self.observer_ctrl.Enable()
		self.show_observer_ctrl()

	def update_main_controls(self):
		""" Enable/disable the calibrate and profile buttons 
		based on available Argyll functionality. """
		self.panel.Freeze()
		
		update_cal = self.calibration_update_cb.GetValue()

		self.measurement_mode_ctrl.Enable(
			bool(self.worker.instruments) and 
			len(self.measurement_mode_ctrl.GetItems()) > 1)
		
		update_profile = update_cal and is_profile()

		self.visual_whitepoint_editor_btn.Enable(bool(self.worker.displays) and
												 bool(self.worker.instruments) and
												 not update_cal)
		self.whitepoint_measure_btn.Enable(bool(self.worker.instruments) and
										   not update_cal)
		self.ambient_measure_btn.Enable(bool(self.worker.instruments) and
										not update_cal)

		lut3d_create_btn_show = (self.lut3d_settings_panel.IsShown()
								 and not getcfg("3dlut.create"))
		mr_btn_show = self.mr_settings_panel.IsShown()
		enable_cal = (not config.is_uncalibratable_display() and
					  (self.interactive_display_adjustment_cb.GetValue() or
					   self.trc_ctrl.GetSelection() > 0))
		calibrate_and_profile_btn_show = (not lut3d_create_btn_show and
										  not mr_btn_show and
										  enable_cal and
										  not update_profile)
		calibrate_btn_show = (not lut3d_create_btn_show and
							  not mr_btn_show and
							  enable_cal)
		profile_btn_show = (not lut3d_create_btn_show and
							not mr_btn_show and
							not calibrate_and_profile_btn_show and
							not update_cal)
		if ((config.is_uncalibratable_display() and
			 self.calibration_settings_panel.IsShown()) or
			(not getcfg("3dlut.tab.enable") and
			 self.lut3d_settings_panel.IsShown())):
			self.tab_select_handler(self.display_instrument_btn)
		if (config.is_uncalibratable_display() and
			not self.calibration_settings_btn.IsEnabled()):
			self.calibration_settings_btn._pressed = False
			self.calibration_settings_btn._SetState(platebtn.PLATE_NORMAL)
		self.calibration_settings_btn.Enable(not config.is_uncalibratable_display())
		self.lut3d_settings_btn.Enable(bool(getcfg("3dlut.tab.enable")))
		self.calibrate_btn.Show(not calibrate_and_profile_btn_show and
							    calibrate_btn_show)
		self.calibrate_btn.Enable(not calibrate_and_profile_btn_show and
							      calibrate_btn_show and
							      not is_ccxx_testchart() and
								  bool(self.worker.displays) and 
								  bool(self.worker.instruments))
		self.calibrate_and_profile_btn.Show(calibrate_and_profile_btn_show)
		self.calibrate_and_profile_btn.Enable(calibrate_and_profile_btn_show and
											  not is_ccxx_testchart() and 
											  bool(self.worker.displays) and 
											  bool(self.worker.instruments))
		self.profile_btn.Show(profile_btn_show)
		self.profile_btn.Enable(profile_btn_show and 
								bool(self.worker.displays) and 
								bool(self.worker.instruments))
		self.lut3d_create_btn.Show(lut3d_create_btn_show)
		self.measurement_report_btn.Show(mr_btn_show)
		self.buttonpanel.Layout()

		self.lut3d_create_btn.Enable(is_profile() and
									 getcfg("calibration.file", False)
									 not in self.presets)
		if getcfg("calibration.file", False) in self.presets[1:]:
			self.measurement_report_btn.Disable()
		
		self.panel.Layout()
		self.panel.Thaw()

	def update_calibration_file_ctrl(self, silent=False):
		""" Update items shown in the calibration file control and set
		a tooltip with the path of the currently selected file """
		cal = getcfg("calibration.file", False)
		
		if cal:
			result = check_file_isfile(cal, silent=silent)
			if isinstance(result, Exception) and not silent:
				show_result_dialog(result, self)
		else:
			result = False
		if not isinstance(result, Exception) and result:
			filename, ext = os.path.splitext(cal)
			if not cal in self.recent_cals:
				self.recent_cals.append(cal)
				recent_cals = []
				for recent_cal in self.recent_cals:
					if recent_cal not in self.presets:
						recent_cals.append(recent_cal)
				setcfg("recent_cals", os.pathsep.join(recent_cals))
				self.calibration_file_ctrl.Append(
					lang.getstr(os.path.basename(cal)))
			# The case-sensitive index could fail because of 
			# case insensitive file systems, e.g. if the 
			# stored filename string is 
			# "C:\Users\Name\AppData\DisplayCAL\storage\MyFile"
			# but the actual filename is 
			# "C:\Users\Name\AppData\DisplayCAL\storage\myfile"
			# (maybe because the user renamed the file)
			idx = index_fallback_ignorecase(self.recent_cals, cal)
			self.calibration_file_ctrl.SetSelection(idx)
			self.calibration_file_ctrl.SetToolTipString(cal)
			if ext.lower() in (".icc", ".icm"):
				profile_path = cal
			else:
				profile_path = filename + profile_ext
			profile_exists = os.path.exists(profile_path)
		else:
			filename = None
			if cal in self.recent_cals[1:]:
				# The case-sensitive index could fail because of 
				# case insensitive file systems, e.g. if the 
				# stored filename string is 
				# "C:\Users\Name\AppData\DisplayCAL\storage\MyFile"
				# but the actual filename is 
				# "C:\Users\Name\AppData\DisplayCAL\storage\myfile"
				# (maybe because the user renamed the file)
				idx = index_fallback_ignorecase(self.recent_cals, cal)
				self.recent_cals.remove(cal)
				self.calibration_file_ctrl.Delete(idx)
			cal = None
			self.calibration_file_ctrl.SetStringSelection(
				lang.getstr("settings.new"))
			self.calibration_file_ctrl.SetToolTip(None)
			setcfg("calibration.file", None)
			setcfg("calibration.update", 0)
			profile_path = None
			profile_exists = False
		
		return cal, filename, profile_path, profile_exists

	def update_controls(self, update_profile_name=True, update_ccmx_items=True,
						silent=False):
		""" Update all controls based on configuration 
		and available Argyll functionality. """
		self.updatingctrls = True
		
		self.panel.Freeze()
		
		(cal, filename, profile_path,
		 profile_exists) = self.update_calibration_file_ctrl(silent)
		self.create_session_archive_btn.Enable(bool(cal) and 
											   cal not in self.presets)
		self.delete_calibration_btn.Enable(bool(cal) and 
										   cal not in self.presets)
		self.install_profile_btn.Enable(profile_exists and
										profile_path == cal and
										cal not in self.presets)
		is_profile_ = is_profile(include_display_profile=True)
		self.profile_info_btn.Enable(is_profile_)
		enable_update = (bool(cal) and os.path.exists(filename + ".cal") and
						 can_update_cal(filename + ".cal"))
		if not enable_update:
			setcfg("calibration.update", 0)
		update_cal = getcfg("calibration.update")
		self.calibration_update_cb.Enable(enable_update)
		self.calibration_update_cb.SetValue(bool(update_cal))

		if not update_cal or not profile_exists:
			setcfg("profile.update", 0)

		update_profile = update_cal and profile_exists
		enable_profile = not(update_profile)
		
		if update_ccmx_items:
			self.update_colorimeter_correction_matrix_ctrl_items()

		self.update_measurement_mode()

		self.update_observer_ctrl()

		for name in ("min_display_update_delay_ms",
					 "display_settle_time_mult"):
			value = bool(getcfg("measure.override_%s" % name))
			getattr(self, "override_%s" % name).SetValue(value)
			self.update_display_delay_ctrl(name, value)

		self.update_adjustment_controls()
		self.whitepoint_colortemp_textctrl.Enable(not update_cal)
		self.whitepoint_colortemp_locus_ctrl.Enable(not update_cal)
		self.whitepoint_x_textctrl.Enable(not update_cal)
		self.whitepoint_y_textctrl.Enable(not update_cal)
		self.luminance_textctrl.Enable(not update_cal)
		self.black_luminance_textctrl.Enable(not update_cal)
		self.trc_ctrl.Enable(not update_cal)
		self.trc_textctrl.Enable(not update_cal)
		self.trc_type_ctrl.Enable(not update_cal)
		self.ambient_viewcond_adjust_cb.Enable(not update_cal)
		self.black_output_offset_ctrl.Enable(not update_cal)
		self.black_output_offset_intctrl.Enable(not update_cal)
		self.black_point_correction_auto_cb.Enable(not update_cal)
		self.black_point_correction_ctrl.Enable(not update_cal)
		self.black_point_correction_intctrl.Enable(not update_cal)
		self.update_black_point_rate_ctrl()
		self.update_drift_compensation_ctrls()

		self.testchart_btn.Enable(enable_profile)
		self.testchart_patches_amount_ctrl.Enable(enable_profile)
		self.create_testchart_btn.Enable(enable_profile)
		self.profile_type_ctrl.Enable(enable_profile)

		self.whitepoint_colortemp_locus_ctrl.SetSelection(
			self.whitepoint_colortemp_loci_ba.get(
				getcfg("whitepoint.colortemp.locus"), 
			self.whitepoint_colortemp_loci_ba.get(
				defaults["whitepoint.colortemp.locus"])))
		
		self.whitelevel_drift_compensation.SetValue(
			bool(getcfg("drift_compensation.whitelevel")))
		
		self.blacklevel_drift_compensation.SetValue(
			bool(getcfg("drift_compensation.blacklevel")))

		trc = getcfg("trc")
		bt1886 = (trc == 2.4 and getcfg("trc.type") == "G" and
				  getcfg("calibration.black_output_offset") == 0)
		if trc in ("l", "709", "240", "s"):
			self.trc_type_ctrl.SetSelection(0)
		if trc == "l":
			self.trc_ctrl.SetSelection(2)
		elif trc == "709":
			self.trc_ctrl.SetSelection(3)
		elif trc == "240":
			self.trc_ctrl.SetSelection(5)
		elif trc == "s":
			self.trc_ctrl.SetSelection(6)
		elif bt1886:
			self.trc_ctrl.SetSelection(4)
			self.trc_textctrl.SetValue(str(trc))
			self.trc_type_ctrl.SetSelection(1)
		else:
			if trc:
				if (trc == 2.2 and getcfg("trc.type") == "g" and
					getcfg("calibration.black_output_offset") == 1):
					# Gamma 2.2 relative 100% output offset
					self.trc_ctrl.SetSelection(1)
				else:
					# Custom
					self.trc_ctrl.SetSelection(7)
				self.trc_textctrl.SetValue(str(trc))
			else:
				self.trc_ctrl.SetSelection(0)
			self.trc_type_ctrl.SetSelection(
				self.trc_types_ba.get(getcfg("trc.type"), 
				self.trc_types_ba.get(defaults["trc.type"])))
		self.show_trc_controls()

		self.ambient_viewcond_adjust_cb.SetValue(
			bool(int(getcfg("calibration.ambient_viewcond_adjust"))))
		self.ambient_viewcond_adjust_textctrl.SetValue(
			getcfg("calibration.ambient_viewcond_adjust.lux"))
		self.ambient_viewcond_adjust_textctrl.Enable(
			not update_cal and 
			bool(int(getcfg("calibration.ambient_viewcond_adjust"))))

		self.update_profile_type_ctrl()

		self.update_black_output_offset_ctrl()

		self.black_point_correction_ctrl.SetValue(
			int(Decimal(str(getcfg("calibration.black_point_correction"))) * 
							100))
		self.black_point_correction_intctrl.SetValue(
			int(Decimal(str(getcfg("calibration.black_point_correction"))) * 
							100))

		self.black_point_rate_ctrl.SetValue(
			int(Decimal(str(getcfg("calibration.black_point_rate"))) * 100))
		self.black_point_rate_floatctrl.SetValue(
			getcfg("calibration.black_point_rate"))

		q = self.quality_ba.get(getcfg("calibration.quality"), 
								self.quality_ba.get(
									defaults["calibration.quality"]))
		self.calibration_quality_ctrl.SetValue(q)
		self.set_calibration_quality_label(self.quality_ab[q])

		self.update_bpc(enable_profile)

		self.testchart_ctrl.Enable(enable_profile)
		if self.set_default_testchart() is None:
			self.set_testchart(update_profile_name=not update_profile_name)

		simple_gamma_model = self.get_profile_type() in ("g", "G")
		if simple_gamma_model:
			q = 3
		else:
			q = self.quality_ba.get(getcfg("profile.quality"), 
									self.quality_ba.get(
										defaults["profile.quality"])) - 1
		self.profile_quality_ctrl.SetValue(q)
		if q == 1:
			self.profile_quality_info.SetLabel(
				lang.getstr("calibration.quality.low"))
		elif q == 2:
			self.profile_quality_info.SetLabel(
				lang.getstr("calibration.quality.medium"))
		elif q == 3:
			self.profile_quality_info.SetLabel(
				lang.getstr("calibration.quality.high"))
		elif q == 4:
			self.profile_quality_info.SetLabel(
				lang.getstr("calibration.quality.ultra"))
		self.profile_quality_ctrl.Enable(enable_profile and not simple_gamma_model)

		enable_gamap = self.get_profile_type() in ("l", "x", "X")
		self.gamap_btn.Enable(enable_profile and enable_gamap)
		
		if getattr(self, "extra_args", None):
			self.extra_args.update_controls()

		if hasattr(self, "gamapframe"):
			self.gamapframe.update_controls()

		if (self.lut3d_settings_panel.IsShown() or
			self.mr_settings_panel.IsShown()):
			if self.mr_settings_panel.IsShown():
				self.mr_update_controls()
			else:
				self.set_profile("output")

		self.lut3d_update_controls()
		if getattr(self, "lut3dframe", None):
			self.lut3dframe.update_controls()

		if getattr(self, "reportframe", None):
			self.reportframe.update_controls()

		if update_profile_name:
			self.profile_name_textctrl.ChangeValue(getcfg("profile.name"))
			self.update_profile_name()

		self.update_main_controls()
		
		self.panel.Thaw()

		self.updatingctrls = False

	def update_trc_control(self):
		if self.trc_ctrl.GetSelection() in (1, 4, 7):
			if (getcfg("trc.type") == "G" and
				getcfg("calibration.black_output_offset") == 0 and
				getcfg("trc") == 2.4):
				self.trc_ctrl.SetSelection(4)  # BT.1886
			elif (getcfg("trc.type") == "g" and
				getcfg("calibration.black_output_offset") == 1 and
				getcfg("trc") == 2.2):
				# Gamma 2.2 relative 100% output offset
				self.trc_ctrl.SetSelection(1)
			else:
				self.trc_ctrl.SetSelection(7)  # Custom

	def show_trc_controls(self, freeze=False):
		show_advanced_options = bool(getcfg("show_advanced_options"))
		if freeze:
			self.panel.Freeze()
		for ctrl in (self.trc_gamma_label,
					 self.trc_textctrl,
					 self.trc_type_ctrl):
			ctrl.Show(self.trc_ctrl.GetSelection() == 7 or
					  (self.trc_ctrl.GetSelection() in (1, 4) and
					   show_advanced_options))
		for ctrl in (self.black_output_offset_label,
					 self.black_output_offset_ctrl,
					 self.black_output_offset_intctrl,
					 self.black_output_offset_intctrl_label):
			ctrl.Show(self.trc_ctrl.GetSelection() == 7 or
					  (self.trc_ctrl.GetSelection() > 0 and
					   show_advanced_options))
		for ctrl in (self.ambient_viewcond_adjust_cb,
					 self.ambient_viewcond_adjust_textctrl,
					 self.ambient_viewcond_adjust_textctrl_label,
					 self.ambient_measure_btn,
					 self.black_point_correction_label,
					 self.black_point_correction_auto_cb):
			ctrl.GetContainingSizer().Show(ctrl,
										   self.trc_ctrl.GetSelection() > 0 and
										   show_advanced_options)
		self.update_black_point_rate_ctrl()
		for ctrl in (self.calibration_quality_label,
					 self.calibration_quality_ctrl,
					 self.calibration_quality_info,
					 self.cal_meas_time):
			ctrl.GetContainingSizer().Show(ctrl,
										   self.trc_ctrl.GetSelection() > 0)
		# Make the height of the last row in the calibration settings sizer
		# match the other rows
		if self.trc_ctrl.GetSelection() > 0:
			minheight = self.trc_ctrl.Size[1] + 8
		else:
			minheight = 0
		self.calibration_quality_ctrl.ContainingSizer.SetMinSize((0, minheight))
		self.black_point_correction_auto_handler()
		if freeze:
			self.panel.Thaw()
	
	def update_black_output_offset_ctrl(self):
		self.black_output_offset_ctrl.SetValue(
			int(Decimal(str(getcfg("calibration.black_output_offset"))) * 100))
		self.black_output_offset_intctrl.SetValue(
			int(Decimal(str(getcfg("calibration.black_output_offset"))) * 100))
	
	def update_black_point_rate_ctrl(self):
		self.panel.Freeze()
		enable = not(self.calibration_update_cb.GetValue())
		show = (self.trc_ctrl.GetSelection() > 0 and
				bool(getcfg("show_advanced_options")) and
				defaults["calibration.black_point_rate.enabled"])
		self.black_point_rate_label.GetContainingSizer().Show(
			self.black_point_rate_label,
			show)
		self.black_point_rate_ctrl.GetContainingSizer().Show(
			self.black_point_rate_ctrl,
			show)
		self.black_point_rate_ctrl.Enable(
			enable and 
			getcfg("calibration.black_point_correction") < 1 and 
			defaults["calibration.black_point_rate.enabled"])
		self.black_point_rate_floatctrl.GetContainingSizer().Show(
			self.black_point_rate_floatctrl,
			show)
		self.black_point_rate_floatctrl.Enable(
			enable  and 
			getcfg("calibration.black_point_correction") < 1 and 
			defaults["calibration.black_point_rate.enabled"])
		self.calpanel.Layout()
		self.panel.Thaw()
	
	def update_bpc(self, enable_profile=True):
		enable_bpc = ((self.get_profile_type() in ("s", "S") or
					   (self.get_profile_type() in ("l", "x", "X") and
						(getcfg("profile.b2a.hires") or
						 getcfg("profile.quality.b2a") in ("l", "n")))) and
					  enable_profile)
		self.black_point_compensation_cb.Enable(enable_bpc)
		self.black_point_compensation_cb.SetValue(enable_bpc and
			bool(int(getcfg("profile.black_point_compensation"))))
	
	def update_drift_compensation_ctrls(self):
		self.panel.Freeze()
		self.blacklevel_drift_compensation.GetContainingSizer().Show(
			self.blacklevel_drift_compensation,
			self.worker.argyll_version >= [1, 3, 0])
		self.whitelevel_drift_compensation.GetContainingSizer().Show(
			self.whitelevel_drift_compensation,
			self.worker.argyll_version >= [1, 3, 0])
		self.calpanel.Layout()
		self.panel.Thaw()

	def update_estimated_measurement_time(self, which):
		""" Update the estimated measurement time shown """
		if which == "testchart":
			patches = int(self.testchart_patches_amount.Label)
		elif which == "cal":
			# See dispcal.c
			if getcfg("calibration.quality") == "v":
				# Very low
				isteps = 10
				rsteps = 16
				maxits = 1
				mxrpts = 10
			elif getcfg("calibration.quality") == "l":
				# Low
				isteps = 12
				rsteps = 32
				maxits = 2
				mxrpts = 10
			elif getcfg("calibration.quality") == "m":
				# Medium
				isteps = 16
				rsteps = 64
				maxits = 3
				mxrpts = 12
			elif getcfg("calibration.quality") == "h":
				# High
				isteps = 20
				rsteps = 96
				maxits = 4
				mxrpts = 16
			elif getcfg("calibration.quality") == "u":
				# Ultra
				isteps = 24
				rsteps = 128
				maxits = 5
				mxrpts = 24
			# 1st iteration
			rsteps /= 1 << (maxits - 1)
			patches = rsteps
			# 2nd..nth iteration
			for i in xrange(maxits - 1):
				rsteps *= 2
				patches += rsteps
			# Multiply by estimated repeats
			patches *= mxrpts / 1.5
			# Amount of precal patches is always 9
			patches += 9
			# Initial amount of cal patches is always isteps * 4
			patches += isteps * 4
		elif which == "chart":
			patches = int(self.chart_patches_amount.Label)
		ReportFrame.update_estimated_measurement_time(self, which, patches)

	def update_estimated_measurement_times(self):
		self.update_estimated_measurement_time("cal")
		self.update_estimated_measurement_time("testchart")
		self.update_estimated_measurement_time("chart")
	
	def blacklevel_drift_compensation_handler(self, event):
		setcfg("drift_compensation.blacklevel", 
			   int(self.blacklevel_drift_compensation.GetValue()))
		self.update_estimated_measurement_times()
	
	def whitelevel_drift_compensation_handler(self, event):
		setcfg("drift_compensation.whitelevel", 
			   int(self.whitelevel_drift_compensation.GetValue()))
		self.update_estimated_measurement_times()

	def calibration_update_ctrl_handler(self, event):
		if debug:
			safe_print("[D] calibration_update_ctrl_handler called for ID %s "
					   "%s event type %s %s" % (event.GetId(), 
												getevtobjname(event, self), 
												event.GetEventType(), 
												getevttype(event)))
		setcfg("calibration.update", 
			   int(self.calibration_update_cb.GetValue()))
		setcfg("profile.update", 
			   int(self.calibration_update_cb.GetValue() and is_profile()))
		self.update_controls()

	def enable_spyder2_handler(self, event, check_instrument_setup=False,
							   callafter=None, callafter_args=None):
		self.update_menus()
		if check_set_argyll_bin():
			msg = lang.getstr("oem.import.auto")
			if sys.platform == "win32":
				msg = " ".join([lang.getstr("oem.import.auto_windows"),
								msg])
			dlg = ConfirmDialog(self,
								title=lang.getstr("enable_spyder2"),
								msg=msg,
								ok=lang.getstr("auto"),
								cancel=lang.getstr("cancel"),
								bitmap=geticon(32, "dialog-information"),
								alt=lang.getstr("file.select"))
			needroot = self.worker.argyll_version < [1, 2, 0]
			dlg.install_user = wx.RadioButton(dlg, -1, lang.getstr("install_user"), 
											  style=wx.RB_GROUP)
			dlg.install_user.Enable(not needroot)
			dlg.install_user.SetValue(not needroot)
			dlg.sizer3.Add(dlg.install_user, flag=wx.TOP | wx.ALIGN_LEFT,
						   border=16)
			dlg.install_systemwide = wx.RadioButton(dlg, -1,
													lang.getstr("install_local_system"))
			dlg.install_user.Enable(not needroot)
			dlg.install_systemwide.SetValue(needroot)
			dlg.install_user.Bind(wx.EVT_RADIOBUTTON, install_scope_handler)
			dlg.install_systemwide.Bind(wx.EVT_RADIOBUTTON,
										install_scope_handler)
			install_scope_handler(dlg=dlg)
			dlg.sizer3.Add(dlg.install_systemwide, flag=wx.TOP | wx.ALIGN_LEFT,
						   border=4)
			dlg.sizer0.SetSizeHints(dlg)
			dlg.sizer0.Layout()
			if event:
				choice = dlg.ShowModal()
			else:
				choice = wx.ID_OK
			asroot = dlg.install_systemwide.GetValue()
			dlg.Destroy()
			if choice == wx.ID_CANCEL:
				return
			if choice == wx.ID_OK:
				# Auto
				path = None
				if sys.platform in ("darwin", "win32"):
					# Look for Spyder.lib/CVSpyder.dll ourself because spyd2en 
					# will only try some fixed paths
					if sys.platform == "darwin":
						wildcard = os.path.join(os.path.sep, "Applications", 
												"Spyder2*", "Spyder2*.app", 
												"Contents", "MacOSClassic", 
												"Spyder.lib")
					else:
						wildcard = os.path.join(getenvu("PROGRAMFILES", ""), 
												"ColorVision", "Spyder2*", 
												"CVSpyder.dll")
					for path in glob.glob(wildcard):
						break
			else:
				# Prompt for installer executable
				defaultDir, defaultFile = expanduseru("~"), ""
				dlg = wx.FileDialog(self, lang.getstr("file.select"),
									defaultDir=defaultDir, 
									defaultFile=defaultFile, 
									wildcard=lang.getstr("filetype.any") + "|*", 
									style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
				dlg.Center(wx.BOTH)
				result = dlg.ShowModal()
				path = dlg.GetPath()
				dlg.Destroy()
				if result != wx.ID_OK:
					return
			if asroot:
				result = self.worker.authenticate(get_argyll_util("spyd2en"),
												  lang.getstr("enable_spyder2"),
												  self)
				if result not in (True, None):
					if isinstance(result, Exception):
						show_result_dialog(result, self)
					return
			self.worker.start(self.enable_spyder2_consumer,
							  self.enable_spyder2_producer,
							  cargs=(check_instrument_setup, callafter,
									 callafter_args),
							  wargs=(path, asroot),
							  progress_msg=lang.getstr("enable_spyder2"),
							  fancy=False)
			return (event and None) or True
	
	def enable_spyder2(self, path, asroot):
		cmd, args = get_argyll_util("spyd2en"), ["-v"]
		if asroot and self.worker.argyll_version >= [1, 2, 0]:
			args.append("-Sl")
		if path:
			args.append(path)
		result = self.worker.exec_cmd(cmd, args, 
									  capture_output=True, 
									  skip_scripts=True, 
									  silent=False,
									  asroot=asroot,
									  title=lang.getstr("enable_spyder2"))
		if asroot and sys.platform == "win32":
			# Wait for async process
			sleep(1)
			result = self.get_argyll_data_files("l", "spyd2PLD.bin")
		return result
	
	def enable_spyder2_producer(self, path, asroot):
		if not path:
			result = self.enable_spyder2(path, asroot)
			if result and not isinstance(result, Exception):
				return result
			if getcfg("dry_run"):
				return
			path = self.worker.download("http://%s/spyd2" % domain.lower())
			if isinstance(path, Exception):
				return path
			elif not path:
				# Cancelled
				return
		return self.enable_spyder2(path, asroot)
	
	def enable_spyder2_consumer(self, result, check_instrument_setup,
								callafter=None, callafter_args=()):
		if not isinstance(result, Exception) and result:
			result = UnloggedInfo(lang.getstr("enable_spyder2_success"))
			self.update_menus()
		elif result is False:
			result = UnloggedError("".join(self.worker.errors))
		if result:
			show_result_dialog(result, self)
		if check_instrument_setup:
			self.check_instrument_setup(callafter, callafter_args)
		elif callafter:
			wx.CallAfter(callafter, *callafter_args)

	def extra_args_handler(self, event):
		if not hasattr(self, "extra_args"):
			self.extra_args = ExtraArgsFrame(self)
			self.extra_args.Center()
		if self.extra_args.IsShownOnScreen():
			self.extra_args.Raise()
		else:
			self.extra_args.Show()

	def startup_sound_enable_handler(self, event):
		setcfg("startup_sound.enable", 
			   int(self.menuitem_startup_sound.IsChecked()))

	def use_fancy_progress_handler(self, event):
		setcfg("use_fancy_progress", 
			   int(self.menuitem_use_fancy_progress.IsChecked()))

	def use_separate_lut_access_handler(self, event):
		setcfg("use_separate_lut_access", 
			   int(self.menuitem_use_separate_lut_access.IsChecked()))
		self.update_displays(set_height=True)

	def do_not_use_video_lut_handler(self, event):
		do_not_use_video_lut = self.menuitem_do_not_use_video_lut.IsChecked()
		is_patterngenerator = config.is_patterngenerator()
		if do_not_use_video_lut != is_patterngenerator:
			dlg = ConfirmDialog(self,
								msg=lang.getstr("calibration.do_not_use_video_lut.warning"),  
								ok=lang.getstr("yes"), 
								cancel=lang.getstr("no"), 
								bitmap=geticon(32, "dialog-warning"), log=False)
			result = dlg.ShowModal()
			dlg.Destroy()
			if result != wx.ID_OK:
				self.menuitem_do_not_use_video_lut.Check(is_patterngenerator)
				return
		setcfg("calibration.use_video_lut", 
			   int(not do_not_use_video_lut))
		if not is_patterngenerator:
			setcfg("calibration.use_video_lut.backup", None)

	def skip_legacy_serial_ports_handler(self, event):
		setcfg("skip_legacy_serial_ports", 
			   int(self.menuitem_skip_legacy_serial_ports.IsChecked()))

	def calibrate_instrument_handler(self, event):
		self.worker.start(lambda result: show_result_dialog(result, self)
										 if isinstance(result, Exception)
										 else None,
						  self.worker.calibrate_instrument_producer,
						  fancy=False)

	def allow_skip_sensor_cal_handler(self, event):
		setcfg("allow_skip_sensor_cal", 
			   int(self.menuitem_allow_skip_sensor_cal.IsChecked()))

	def update_adjustment_controls(self):
		update_cal = getcfg("calibration.update")
		auto = self.get_measurement_mode() == "auto"
		do_cal = bool(getcfg("calibration.interactive_display_adjustment",
							 False) or getcfg("trc"))
		enable = (not update_cal and not auto and do_cal)
		for option in ("whitepoint.colortemp", "whitepoint.x",
					   "whitepoint.y", "calibration.luminance",
					   "calibration.black_luminance",
					   "calibration.interactive_display_adjustment"):
			backup = getcfg("%s.backup" % option, False)
			if auto and backup is None:
				# Backup current settings
				setcfg("%s.backup" % option, getcfg(option, False))
			elif not auto and backup is not None:
				setcfg(option, getcfg("%s.backup" % option))
				setcfg("%s.backup" % option, None)
		if auto or not do_cal:
			setcfg("whitepoint.colortemp", None)
			setcfg("whitepoint.x", None)
			setcfg("whitepoint.y", None)
			self.whitepoint_colortemp_textctrl.Hide()
			self.whitepoint_colortemp_label.Hide()
			self.whitepoint_x_textctrl.Hide()
			self.whitepoint_x_label.Hide()
			self.whitepoint_y_textctrl.Hide()
			self.whitepoint_y_label.Hide()
			self.visual_whitepoint_editor_btn.Hide()
			self.whitepoint_measure_btn.Hide()
			self.luminance_ctrl.SetSelection(0)
			self.luminance_textctrl.Hide()
			self.luminance_textctrl_label.Hide()
			setcfg("calibration.luminance", None)
			self.black_luminance_textctrl.Hide()
			self.black_luminance_textctrl_label.Hide()
			setcfg("calibration.black_luminance", None)
			setcfg("calibration.interactive_display_adjustment", 0)
		self.whitepoint_ctrl.Enable(enable)
		self.luminance_ctrl.Enable(enable)
		self.black_luminance_ctrl.Enable(enable)
		self.interactive_display_adjustment_cb.Enable(not update_cal and
													  not auto)

		self.interactive_display_adjustment_cb.SetValue(not update_cal and 
			bool(int(getcfg("calibration.interactive_display_adjustment"))))
		self.whitepoint_colortemp_textctrl.SetValue(
			str(stripzeros(getcfg("whitepoint.colortemp"))))
		if getcfg("whitepoint.colortemp", False):
			self.whitepoint_ctrl.SetSelection(1)
		elif getcfg("whitepoint.x", False) and getcfg("whitepoint.y", False):
			self.whitepoint_x_textctrl.SetValue(round(getcfg("whitepoint.x"), 4))
			self.whitepoint_y_textctrl.SetValue(round(getcfg("whitepoint.y"), 4))
			self.whitepoint_ctrl.SetSelection(2)
		else:
			self.whitepoint_ctrl.SetSelection(0)
		self.whitepoint_ctrl_handler(
			CustomEvent(wx.EVT_CHOICE.evtType[0], 
			self.whitepoint_ctrl), False)
		show_advanced_options = bool(getcfg("show_advanced_options"))
		for ctrl in (self.whitepoint_colortemp_locus_label,
					 self.whitepoint_colortemp_locus_ctrl):
			ctrl.Show(self.whitepoint_ctrl.GetSelection() in (0, 1) and
					  not auto and do_cal and
					  show_advanced_options)

		if getcfg("calibration.luminance", False):
			self.luminance_ctrl.SetSelection(1)
		else:
			self.luminance_ctrl.SetSelection(0)
		self.luminance_textctrl.SetValue(getcfg("calibration.luminance"))
		self.luminance_textctrl.Show(bool(getcfg("calibration.luminance", 
												 False)))
		self.luminance_textctrl_label.Show(bool(getcfg("calibration.luminance", 
													   False)))

		if getcfg("calibration.black_luminance", False):
			self.black_luminance_ctrl.SetSelection(1)
		else:
			self.black_luminance_ctrl.SetSelection(0)
		self.black_luminance_textctrl.SetValue(
			getcfg("calibration.black_luminance"))
		self.black_luminance_textctrl.Show(
			bool(show_advanced_options and
				 getcfg("calibration.black_luminance", False)))
		self.black_luminance_textctrl_label.Show(
			bool(show_advanced_options and
				 getcfg("calibration.black_luminance", False)))

	def enable_3dlut_tab_handler(self, event):
		setcfg("3dlut.tab.enable", 
			   int(self.menuitem_enable_3dlut_tab.IsChecked()))
		setcfg("3dlut.tab.enable.backup", getcfg("3dlut.tab.enable"))
		if not getcfg("3dlut.tab.enable"):
			setcfg("3dlut.create", 0)
			self.lut3d_update_controls()
		self.update_main_controls()

	def enable_argyll_debug_handler(self, event):
		if not getcfg("argyll.debug"):
			dlg = ConfirmDialog(self, msg=lang.getstr("argyll.debug.warning1"),  
								ok=lang.getstr("ok"), 
								cancel=lang.getstr("cancel"), 
								bitmap=geticon(32, "dialog-warning"), log=False)
			result = dlg.ShowModal()
			dlg.Destroy()
			if result != wx.ID_OK:
				self.menuitem_enable_argyll_debug.Check(False)
				return
			InfoDialog(self, msg=lang.getstr("argyll.debug.warning2"), 
					   bitmap=geticon(32, "dialog-warning"), log=False)
		setcfg("argyll.debug", 
			   int(self.menuitem_enable_argyll_debug.IsChecked()))

	def enable_dry_run_handler(self, event):
		setcfg("dry_run", int(self.menuitem_enable_dry_run.IsChecked()))
		self.menuitem_enable_argyll_debug.Enable(not self.menuitem_enable_dry_run.IsChecked())
	
	def enable_menus(self, enable=True):
		for menu, label in self.menubar.GetMenus():
			for item in menu.GetMenuItems():
				item.Enable(enable)
		if enable:
			self.update_menus()

	def lut3d_check_bpc(self):
		if getcfg("3dlut.create") and getcfg("profile.black_point_compensation"):
			# Warn about BPC if creating 3D LUT
			dlg = ConfirmDialog(self,
								msg=lang.getstr("black_point_compensation.3dlut.warning"),
								ok=lang.getstr("turn_off"),
								cancel=lang.getstr("setting.keep_current"),
								bitmap=geticon(32, "dialog-warning"))
			if dlg.ShowModal() == wx.ID_OK:
				setcfg("profile.black_point_compensation", 0)
				self.update_bpc()

	def lut3d_create_cb_handler(self, event):
		v = int(self.lut3d_create_cb.GetValue())
		if v != getcfg("3dlut.create"):
			self.profile_settings_changed()
		setcfg("3dlut.create", v)
		self.calpanel.Freeze()
		self.lut3d_show_trc_controls()
		self.lut3d_update_apply_cal_control()
		self.lut3d_update_b2a_controls()
		self.calpanel.Thaw()
		self.lut3d_check_bpc()
		self.update_main_controls()

	def lut3d_init_input_profiles(self):
		self.input_profiles = OrderedDict()
		for profile_filename in ["ACES.icm", "DCI_XYZ.icm", "Rec709.icm", 
								 "Rec2020.icm", "EBU3213_PAL.icm",
								 "SMPTE_RP145_NTSC.icm", "SMPTE431_P3.icm",
								 getcfg("3dlut.input.profile")]:
			if not os.path.isabs(profile_filename):
				profile_filename = get_data_path("ref/" + profile_filename)
			if profile_filename:
				try:
					profile = ICCP.ICCProfile(profile_filename)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					safe_print("%s:" % profile_filename, exception)
				else:
					if profile_filename not in self.input_profiles.values():
						desc = profile.getDescription()
						desc = re.sub(r"\s*(?:color profile|primaries with "
									  "\S+ transfer function)$", "", desc)
						self.input_profiles[desc] = profile_filename
		self.input_profiles.sort()
		self.lut3d_input_profile_ctrl.SetItems(self.input_profiles.keys())

	def lut3d_input_colorspace_handler(self, event):
		if event:
			self.lut3d_set_option("3dlut.input.profile",
				   self.input_profiles[self.lut3d_input_profile_ctrl.GetStringSelection()],
				   event)
			lut3d_input_profile = ICCP.ICCProfile(getcfg("3dlut.input.profile"))
			if (lut3d_input_profile and
				"rTRC" in lut3d_input_profile.tags and
				"gTRC" in lut3d_input_profile.tags and
				"bTRC" in lut3d_input_profile.tags and
				lut3d_input_profile.tags.rTRC ==
				lut3d_input_profile.tags.gTRC ==
				lut3d_input_profile.tags.bTRC and
				isinstance(lut3d_input_profile.tags.rTRC,
						   ICCP.CurveType)):
				tf = lut3d_input_profile.tags.rTRC.get_transfer_function()
				# Set gamma to profile gamma if single gamma profile
				if tf[0][0].startswith("Gamma"):
					if not getcfg("3dlut.trc_gamma.backup", False):
						# Backup current gamma
						setcfg("3dlut.trc_gamma.backup",
							   getcfg("3dlut.trc_gamma"))
					setcfg("3dlut.trc_gamma",
						   round(tf[0][1], 2))
				# Restore previous gamma if not single gamma
				# profile
				elif getcfg("3dlut.trc_gamma.backup", False):
					setcfg("3dlut.trc_gamma",
						   getcfg("3dlut.trc_gamma.backup"))
					setcfg("3dlut.trc_gamma.backup", None)
				self.lut3d_update_trc_controls()
				self.lut3d_show_trc_controls()
			if getattr(self, "lut3dframe", None):
				self.lut3dframe.update_controls()
		self.lut3d_input_profile_ctrl.SetToolTipString(
			getcfg("3dlut.input.profile"))

	def lut3d_set_path(self, path=None):
		# 3D LUT filename with crcr32 hash before extension - up to DCG 2.9.0.7
		profile_save_path = os.path.splitext(path or
											 getcfg("calibration.file") or
											 defaults["calibration.file"])[0]
		lut3d = [getcfg("3dlut.gamap.use_b2a") and "gg" or "G",
				 "i" + getcfg("3dlut.rendering_intent"),
				 "r%i" % getcfg("3dlut.size"),
				 "e" + getcfg("3dlut.encoding.input"),
				 "E" + getcfg("3dlut.encoding.output"),
				 "I%s:%s:%s" % (getcfg("3dlut.trc_gamma_type"),
								getcfg("3dlut.trc_output_offset"),
								getcfg("3dlut.trc_gamma"))]
		if getcfg("3dlut.format") == "3dl":
			lut3d.append(str(getcfg("3dlut.bitdepth.input")))
		if getcfg("3dlut.format") in ("3dl", "png", "ReShade"):
			lut3d.append(str(getcfg("3dlut.bitdepth.output")))
		lut3d_ext = getcfg("3dlut.format")
		if lut3d_ext == "eeColor":
			lut3d_ext = "txt"
		elif lut3d_ext == "madVR":
			lut3d_ext = "3dlut"
		elif lut3d_ext == "ReShade":
			lut3d_ext = "png"
		elif lut3d_ext == "icc":
			lut3d_ext = profile_ext[1:]
		input_profname = os.path.splitext(os.path.basename(getcfg("3dlut.input.profile")))[0]
		self.lut3d_path = ".".join([profile_save_path, input_profname,
									"%X" % (crc32("-".join(lut3d))
											& 0xFFFFFFFF),
									lut3d_ext])
		if not os.path.isfile(self.lut3d_path):
			# 3D LUT filename with plain options before extension - DCG 2.9.0.8+
			enc_in = lut3d[3][1:]
			enc_out = lut3d[4][1:]
			encoding = enc_in
			if enc_in != enc_out:
				encoding += enc_out
			if getcfg("3dlut.output.profile.apply_cal"):
				cal_exclude = ""
			else:
				cal_exclude = "e"
			if getcfg("3dlut.trc").startswith("smpte2084"):
				lut3dp = [str(getcfg("3dlut.trc_output_offset")) + ",2084"]
				if getcfg("3dlut.hdr_peak_luminance") < 10000:
					lut3dp.append("@" + str(getcfg("3dlut.hdr_peak_luminance")))
					if getcfg("3dlut.trc") == "smpte2084.hardclip":
						lut3dp.append("h")
					else:
						lut3dp.append("s")
					if getcfg("3dlut.hdr_maxcll") < 10000:
						lut3dp.append(str(getcfg("3dlut.hdr_maxcll")))
			else:
				lut3dp = [lut3d[5][1].replace("b", "bb") +
						  lut3d[5][3:].replace(":", ",")]  # TRC
			lut3dp.extend([cal_exclude,
						   lut3d[0],  # Gamut mapping mode
						   lut3d[1][1:],  # Rendering intent
						   encoding,
						   lut3d[2][1:]])  # Resolution
			bitdepth_in = None
			bitdepth_out = None
			if len(lut3d) > 6:
				bitdepth_in = lut3d[6]  # Input bitdepth
			if len(lut3d) > 7:
				bitdepth_out = lut3d[7]  # Output bitdepth
			if bitdepth_in or bitdepth_out:
				bitdepth = bitdepth_in
				if bitdepth_out and bitdepth_in != bitdepth_out:
					bitdepth += bitdepth_out
				lut3dp.append(bitdepth)
			self.lut3d_path = ".".join([profile_save_path, input_profname,
										"".join(lut3dp), lut3d_ext])
		devlink = os.path.splitext(self.lut3d_path)[0] + profile_ext
		setcfg("measurement_report.devlink_profile", devlink)

	def lut3d_show_controls(self):
		show = True#bool(getcfg("3dlut.create"))
		self.lut3d_input_profile_label.Show(show)
		self.lut3d_input_profile_ctrl.Show(show)
		self.lut3d_show_trc_controls()
		self.lut3d_show_encoding_controls(show)
		self.lut3d_format_label.Show(show)
		self.lut3d_format_ctrl.Show(show)
		show_advanced_options = getcfg("show_advanced_options")
		for ctrl in (self.lut3d_apply_cal_cb,
					 self.gamut_mapping_mode,
					 self.gamut_mapping_inverse_a2b,
					 self.gamut_mapping_b2a):
			ctrl.GetContainingSizer().Show(ctrl,
										   show_advanced_options and
										   show)
		for ctrl in (self.lut3d_size_label,
					 self.lut3d_size_ctrl):
			ctrl.GetContainingSizer().Show(ctrl, show)

	def lut3d_update_apply_cal_control(self):
		profile = not getcfg("3dlut.create") and get_current_profile(True)
		enable_apply_cal = bool(getcfg("3dlut.create") or
								(profile and
								 isinstance(profile.tags.get("vcgt"),
											ICCP.VideoCardGammaType)))
		self.lut3d_apply_cal_cb.SetValue(enable_apply_cal and
										 bool(getcfg("3dlut.output.profile.apply_cal")))
		self.lut3d_apply_cal_cb.Enable(enable_apply_cal)

	def lut3d_update_b2a_controls(self):
		# Allow using B2A instead of inverse A2B?
		if getcfg("3dlut.create"):
			allow_b2a_gamap = (getcfg("profile.type") in ("l", "x", "X") and
							   getcfg("profile.b2a.hires"))
		else:
			profile = get_current_profile(True)
			allow_b2a_gamap = (profile and "B2A0" in profile.tags and
							   isinstance(profile.tags.B2A0, ICCP.LUT16Type) and
							   profile.tags.B2A0.clut_grid_steps >= 17)
		self.gamut_mapping_b2a.Enable(bool(allow_b2a_gamap))
		if not allow_b2a_gamap:
			setcfg("3dlut.gamap.use_b2a", 0)
		self.gamut_mapping_inverse_a2b.SetValue(
			not getcfg("3dlut.gamap.use_b2a"))
		self.gamut_mapping_b2a.SetValue(
			bool(getcfg("3dlut.gamap.use_b2a")))
	
	def lut3d_update_controls(self):
		self.lut3d_create_cb.SetValue(bool(getcfg("3dlut.create")))
		lut3d_input_profile = getcfg("3dlut.input.profile")
		if not lut3d_input_profile in self.input_profiles.values():
			if (not lut3d_input_profile or
				not os.path.isfile(lut3d_input_profile)):
				lut3d_input_profile = defaults["3dlut.input.profile"]
				setcfg("3dlut.input.profile", lut3d_input_profile)
			else:
				try:
					profile = ICCP.ICCProfile(lut3d_input_profile)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					safe_print("%s:" % lut3d_input_profile, exception)
				else:
					desc = profile.getDescription()
					desc = re.sub(r"\s*(?:color profile|primaries with "
								  "\S+ transfer function)$", "", desc)
					self.input_profiles[desc] = lut3d_input_profile
		if lut3d_input_profile in self.input_profiles.values():
			self.lut3d_input_profile_ctrl.SetSelection(
				self.input_profiles.values().index(lut3d_input_profile))
			self.lut3d_input_colorspace_handler(None)
		self.lut3d_update_apply_cal_control()
		self.lut3d_update_b2a_controls()
		self.lut3d_update_shared_controls()
		self.lut3d_update_encoding_controls()
		self.lut3d_show_controls()

	def profile_quality_warning_handler(self, event):
		q = self.get_profile_quality()
		if q == "u":
			InfoDialog(self, msg=lang.getstr("quality.ultra.warning"), 
					   ok=lang.getstr("ok"), 
					   bitmap=geticon(32, "dialog-warning"), log=False)

	def profile_quality_ctrl_handler(self, event):
		if debug:
			safe_print("[D] profile_quality_ctrl_handler called for ID %s %s "
					   "event type %s %s" % (event.GetId(), 
											 getevtobjname(event, self), 
											 event.GetEventType(), 
											 getevttype(event)))
		oldq = getcfg("profile.quality")
		q = self.get_profile_quality()
		if q == oldq:
			return
		if q == "l":
			self.profile_quality_info.SetLabel(
				lang.getstr("calibration.quality.low"))
		elif q == "m":
			self.profile_quality_info.SetLabel(lang.getstr(
				"calibration.quality.medium"))
		elif q == "h":
			self.profile_quality_info.SetLabel(lang.getstr(
				"calibration.quality.high"))
		elif q == "u":
			self.profile_quality_info.SetLabel(lang.getstr(
				"calibration.quality.ultra"))
		self.profile_settings_changed()
		setcfg("profile.quality", q)
		self.update_profile_name()
		self.set_default_testchart(False)
		wx.CallAfter(self.check_testchart_patches_amount)

	def calibration_file_ctrl_handler(self, event):
		if debug:
			safe_print("[D] calibration_file_ctrl_handler called for ID %s %s "
					   "event type %s %s" % (event.GetId(), 
											 getevtobjname(event, self), 
											 event.GetEventType(), 
											 getevttype(event)))
		sel = self.calibration_file_ctrl.GetSelection()
		if sel > 0:
			self.load_cal_handler(None, path=self.recent_cals[sel])
		else:
			self.cal_changed(setchanged=False)
			if getattr(self, "lut3dframe", None):
				self.lut3dframe.set_profile("output")
			if getattr(self, "reportframe", None):
				self.reportframe.set_profile("output")
			### Set measurement report dest profile to current
			##setcfg("measurement_report.output_profile",
				   ##get_current_profile_path())
			if (self.lut3d_settings_panel.IsShown() or
				self.mr_settings_panel.IsShown()):
				if self.mr_settings_panel.IsShown():
					self.mr_update_controls()
				else:
					self.set_profile("output")
				if self.lut3d_settings_panel.IsShown():
					self.lut3d_show_trc_controls()
				self.update_main_controls()
	
	def settings_discard_changes(self, sel=None, keep_changed_state=False):
		""" Update the calibration file control and remove the leading
		asterisk (*) from items """
		if sel is None:
			sel = self.calibration_file_ctrl.GetSelection()
		if not keep_changed_state: setcfg("settings.changed", 0)
		items = self.calibration_file_ctrl.GetItems()
		changed = False
		for j, item in enumerate(items):
			#if j != sel and item[0] == "*":
			if item[0] == "*":
				items[j] = item[2:]
				changed = True
		if changed:
			self.calibration_file_ctrl.Freeze()
			self.calibration_file_ctrl.SetItems(items)
			self.calibration_file_ctrl.SetSelection(sel)
			self.calibration_file_ctrl.Thaw()
			
	def settings_confirm_discard(self):
		""" Show a dialog for user to confirm or cancel discarding changed
		settings """
		sel = self.calibration_file_ctrl.GetSelection()
		cal = getcfg("calibration.file", False) or ""
		if not cal in self.recent_cals:
			self.recent_cals.append(cal)
		# The case-sensitive index could fail because of 
		# case insensitive file systems, e.g. if the 
		# stored filename string is 
		# "C:\Users\Name\AppData\DisplayCAL\storage\MyFile"
		# but the actual filename is 
		# "C:\Users\Name\AppData\DisplayCAL\storage\myfile"
		# (maybe because the user renamed the file)
		idx = index_fallback_ignorecase(self.recent_cals, 
										cal)
		self.calibration_file_ctrl.SetSelection(idx)
		dlg = ConfirmDialog(self, msg=lang.getstr("warning.discard_changes"), 
								  ok=lang.getstr("ok"), 
								  cancel=lang.getstr("cancel"), 
								  bitmap=geticon(32, "dialog-warning"))
		result = dlg.ShowModal()
		dlg.Destroy()
		if result != wx.ID_OK: return False
		self.settings_discard_changes(sel)
		return True

	def calibration_quality_ctrl_handler(self, event):
		if debug:
			safe_print("[D] calibration_quality_ctrl_handler called for ID %s "
					   "%s event type %s %s" % (event.GetId(), 
												getevtobjname(event, self), 
												event.GetEventType(), 
												getevttype(event)))
		q = self.get_calibration_quality()
		self.set_calibration_quality_label(q)
		if q != getcfg("calibration.quality"):
			self.profile_settings_changed()
		setcfg("calibration.quality", q)
		self.update_estimated_measurement_time("cal")
		self.update_profile_name()
	
	def set_calibration_quality_label(self, q):
		if q == "v":
			self.calibration_quality_info.SetLabel(
				lang.getstr("calibration.speed.veryhigh"))
		elif q == "l":
			self.calibration_quality_info.SetLabel(
				lang.getstr("calibration.speed.high"))
		elif q == "m":
			self.calibration_quality_info.SetLabel(
				lang.getstr("calibration.speed.medium"))
		elif q == "h":
			self.calibration_quality_info.SetLabel(
				lang.getstr("calibration.speed.low"))
		elif q == "u":
			self.calibration_quality_info.SetLabel(
				lang.getstr("calibration.speed.verylow"))

	def interactive_display_adjustment_ctrl_handler(self, event):
		if debug:
			safe_print("[D] interactive_display_adjustment_ctrl_handler called "
					   "for ID %s %s event type %s %s" % (event.GetId(), 
														  getevtobjname(event, 
																		self), 
														  event.GetEventType(), 
														  getevttype(event)))
		v = int(self.interactive_display_adjustment_cb.GetValue())
		if v != getcfg("calibration.interactive_display_adjustment"):
			setcfg("calibration.interactive_display_adjustment", v)
			self.profile_settings_changed()
			self.panel.Freeze()
			self.update_adjustment_controls()
			self.calpanel.Layout()
			self.calpanel.Refresh()
			self.panel.Thaw()
			self.update_main_controls()
			self.update_profile_name()

	def black_point_compensation_ctrl_handler(self, event):
		v = int(self.black_point_compensation_cb.GetValue())
		if v != getcfg("profile.black_point_compensation"):
			self.profile_settings_changed()
		setcfg("profile.black_point_compensation", v)
		self.lut3d_check_bpc()
	
	def black_point_correction_auto_handler(self, event=None):
		if event:
			auto = self.black_point_correction_auto_cb.GetValue()
			setcfg("calibration.black_point_correction.auto", int(auto))
			self.cal_changed()
			self.update_profile_name()
		else:
			auto = getcfg("calibration.black_point_correction.auto")
			self.black_point_correction_auto_cb.SetValue(bool(auto))
		show = (self.trc_ctrl.GetSelection() > 0 and
				bool(getcfg("show_advanced_options")) and not auto)
		self.calpanel.Freeze()
		self.black_point_correction_ctrl.Show(show)
		self.black_point_correction_intctrl.Show(show)
		self.black_point_correction_intctrl_label.Show(show)
		self.calpanel.Layout()
		self.calpanel.Refresh()
		self.calpanel.Thaw()

	def black_point_correction_ctrl_handler(self, event):
		if debug:
			safe_print("[D] black_point_correction_ctrl_handler called for ID "
					   "%s %s event type %s %s" % (event.GetId(), 
												   getevtobjname(event, self), 
												   event.GetEventType(), 
												   getevttype(event)))
		if event.GetId() == self.black_point_correction_intctrl.GetId():
			self.black_point_correction_ctrl.SetValue(
				self.black_point_correction_intctrl.GetValue())
		else:
			self.black_point_correction_intctrl.SetValue(
				self.black_point_correction_ctrl.GetValue())
		v = self.get_black_point_correction()
		if float(v) != getcfg("calibration.black_point_correction"):
			self.cal_changed()
		setcfg("calibration.black_point_correction", v)
		self.black_point_rate_ctrl.Enable(
			getcfg("calibration.black_point_correction") < 1 and 
			defaults["calibration.black_point_rate.enabled"])
		self.black_point_rate_floatctrl.Enable(
			getcfg("calibration.black_point_correction") < 1 and 
			defaults["calibration.black_point_rate.enabled"])
		self.update_profile_name()

	def black_point_rate_ctrl_handler(self, event):
		if debug:
			safe_print("[D] black_point_rate_ctrl_handler called for ID %s %s "
					   "event type %s %s" % (event.GetId(), 
											 getevtobjname(event, self), 
											 event.GetEventType(), 
											 getevttype(event)))
		if event.GetId() == self.black_point_rate_floatctrl.GetId():
			self.black_point_rate_ctrl.SetValue(
				int(round(self.black_point_rate_floatctrl.GetValue() * 100)))
		else:
			self.black_point_rate_floatctrl.SetValue(
				self.black_point_rate_ctrl.GetValue() / 100.0)
		v = self.get_black_point_rate()
		if v != str(getcfg("calibration.black_point_rate")):
			self.cal_changed()
		setcfg("calibration.black_point_rate", v)
		self.update_profile_name()

	def black_output_offset_ctrl_handler(self, event):
		if debug:
			safe_print("[D] black_output_offset_ctrl_handler called for ID %s "
					   "%s event type %s %s" % (event.GetId(), 
												getevtobjname(event, self), 
												event.GetEventType(), 
												getevttype(event)))
		if event.GetId() == self.black_output_offset_intctrl.GetId():
			self.black_output_offset_ctrl.SetValue(
				self.black_output_offset_intctrl.GetValue())
		else:
			self.black_output_offset_intctrl.SetValue(
				self.black_output_offset_ctrl.GetValue())
		v = self.get_black_output_offset()
		if float(v) != getcfg("calibration.black_output_offset"):
			self.cal_changed()
			setcfg("calibration.black_output_offset", v)
			self.update_profile_name()
			self.update_trc_control()
			self.show_trc_controls(True)

	def visual_whitepoint_editor_handler(self, event):
		display_no = config.get_display_number(getcfg("display.number") - 1)
		try:
			pos = wx.Display(display_no).ClientArea[:2]
		except:
			pos = self.GetDisplay().ClientArea[:2]
		editor = VisualWhitepointEditor(self, pos=pos)
		editor.RealCenterOnScreen()
		editor.Show()
	
	def ambient_measure_handler(self, event):
		""" Start measuring ambient illumination """
		if not check_set_argyll_bin():
			return
		# Minimum Windows version: XP or Server 2003
		if sys.platform == "win32" and sys.getwindowsversion() < (5, 1):
			show_result_dialog(Error(lang.getstr("windows.version.unsupported")))
			return
		safe_print("-" * 80)
		safe_print(lang.getstr("ambient.measure"))
		self.stop_timers()
		evtobjname = event.GetEventObject().Name
		if evtobjname == "visual_whitepoint_editor_measure_btn":
			interactive_frame = event.GetEventObject().TopLevelParent
			while not isinstance(interactive_frame, VisualWhitepointEditor):
				# Floated panel
				interactive_frame = interactive_frame.Parent
		else:
			interactive_frame = "ambient"
		self.worker.interactive = interactive_frame != "ambient"
		self.worker.start(self.ambient_measure_consumer, 
						  self.ambient_measure_producer, 
						  ckwargs={"evtobjname": evtobjname},
						  wkwargs={"evtobjname": evtobjname},
						  progress_title=lang.getstr("ambient.measure"),
						  interactive_frame=interactive_frame)
	
	def ambient_measure_producer(self, evtobjname):
		""" Process spotread output for ambient readings """
		cmd = get_argyll_util("spotread")
		if evtobjname == "visual_whitepoint_editor_measure_btn":
			# Emissive
			mode = "-e"
		else:
			# Ambient
			mode = "-a"
		args = ["-v", mode, "-x"]
		if getcfg("extra_args.spotread").strip():
			args += parse_argument_string(getcfg("extra_args.spotread"))
		result = self.worker.add_measurement_features(args, False,
													  allow_nondefault_observer=True,
													  ambient=mode == "-a")
		if isinstance(result, Exception):
			return result
		return self.worker.exec_cmd(cmd, args, capture_output=True,
									skip_scripts=True)
	
	def ambient_measure_consumer(self, result=None, evtobjname=None):
		self.start_timers()
		if not result or isinstance(result, Exception):
			if getattr(self.worker, "subprocess", None):
				self.worker.quit_terminate_cmd()
			if isinstance(result, Exception):
				show_result_dialog(result, self)
			return
		safe_print(lang.getstr("success"))
		result = re.sub("[^\t\n\r\x20-\x7f]", "",
						"".join(self.worker.output)).strip()
		if not result:
			wx.Bell()
			return
		if getcfg("whitepoint.colortemp.locus") == "T":
			K = re.search("Planckian temperature += (\d+(?:\.\d+)?)K", 
						  result, re.I)
		else:
			K = re.search("Daylight temperature += (\d+(?:\.\d+)?)K", 
						  result, re.I)
		XYZ = re.search("XYZ: (\d+(?:\.\d+)) (\d+(?:\.\d+)) (\d+(?:\.\d+))", 
						result)
		Yxy = re.search("Yxy: (\d+(?:\.\d+)) (\d+(?:\.\d+)) (\d+(?:\.\d+))", 
						result)
		lux = re.search("Ambient = (\d+(?:\.\d+)) Lux", result, re.I)
		set_whitepoint = evtobjname in ("visual_whitepoint_editor_measure_btn",
										"whitepoint_measure_btn")
		set_ambient = evtobjname == "ambient_measure_btn"
		if (set_whitepoint and not set_ambient and lux and
			getcfg("show_advanced_options")):
			dlg = ConfirmDialog(self, msg=lang.getstr("ambient.set"), 
								ok=lang.getstr("yes"), 
								cancel=lang.getstr("no"), 
								bitmap=geticon(32, "dialog-question"))
			set_ambient = dlg.ShowModal() == wx.ID_OK
			dlg.Destroy()
		if set_ambient:
			if lux:
				self.ambient_viewcond_adjust_textctrl.SetValue(float(lux.groups()[0]))
				self.ambient_viewcond_adjust_cb.SetValue(True)
				self.ambient_viewcond_adjust_ctrl_handler(
						CustomEvent(wx.EVT_CHECKBOX.evtType[0], 
									self.ambient_viewcond_adjust_cb))
			else:
				show_result_dialog(Error(lang.getstr("ambient.measure.light_level.missing")),
								   self)
			if not set_whitepoint and (K or Yxy):
				dlg = ConfirmDialog(self, msg=lang.getstr("whitepoint.set"), 
									ok=lang.getstr("yes"), 
									cancel=lang.getstr("no"), 
									bitmap=geticon(32, "dialog-question"))
				set_whitepoint = dlg.ShowModal() == wx.ID_OK
				dlg.Destroy()
		if set_whitepoint:
			if evtobjname == "visual_whitepoint_editor_measure_btn" and XYZ:
				RGB = []
				for attribute in "rgb":
					RGB.append(getcfg("whitepoint.visual_editor." + attribute))
				if max(RGB) < 255:
					# Set luminance
					self.luminance_ctrl.SetSelection(1)
					self.luminance_textctrl.SetValue(float(XYZ.group(2)))
				else:
					self.luminance_ctrl.SetSelection(0)
				self.luminance_ctrl_handler(CustomEvent(wx.EVT_CHOICE.evtType[0], 
														self.luminance_ctrl))
			if not K and not Yxy:
				# Monochrome reading?
				show_result_dialog(Error(lang.getstr("ambient.measure.color.unsupported",
													 self.comport_ctrl.GetStringSelection())),
								   self)
				return
			if K:
				if not Yxy:
					self.whitepoint_ctrl.SetSelection(1)
				self.whitepoint_colortemp_textctrl.SetValue(K.groups()[0])
			if Yxy:
				if not K:
					self.whitepoint_ctrl.SetSelection(2)
				Y, x, y = Yxy.groups()
				self.whitepoint_x_textctrl.SetValue(round(float(x), 4))
				self.whitepoint_y_textctrl.SetValue(round(float(y), 4))
			self.whitepoint_ctrl_handler(CustomEvent(wx.EVT_CHOICE.evtType[0], 
													 self.whitepoint_ctrl))

	def ambient_viewcond_adjust_ctrl_handler(self, event):
		if event.GetId() == self.ambient_viewcond_adjust_textctrl.GetId() and \
		   (not self.ambient_viewcond_adjust_cb.GetValue() or 
			getcfg("calibration.ambient_viewcond_adjust.lux") == 
			self.ambient_viewcond_adjust_textctrl.GetValue()):
			event.Skip()
			return
		if debug:
			safe_print("[D] ambient_viewcond_adjust_ctrl_handler called for ID "
					   "%s %s event type %s %s" % (event.GetId(), 
												   getevtobjname(event, self), 
												   event.GetEventType(), 
												   getevttype(event)))
		if event.GetId() == self.ambient_viewcond_adjust_textctrl.GetId():
			if self.ambient_viewcond_adjust_textctrl.GetValue():
				self.ambient_viewcond_adjust_cb.SetValue(True)
			else:
				self.ambient_viewcond_adjust_cb.SetValue(False)
		if self.ambient_viewcond_adjust_cb.GetValue():
			self.ambient_viewcond_adjust_textctrl.Enable()
			v = self.ambient_viewcond_adjust_textctrl.GetValue()
			if v:
				if v < 0.000001 or v > sys.maxint:
					wx.Bell()
					self.ambient_viewcond_adjust_textctrl.SetValue(
						getcfg("calibration.ambient_viewcond_adjust.lux"))
			if event.GetId() == self.ambient_viewcond_adjust_cb.GetId():
				self.ambient_viewcond_adjust_textctrl.SetFocus()
		else:
			self.ambient_viewcond_adjust_textctrl.Disable()
		v1 = int(self.ambient_viewcond_adjust_cb.GetValue())
		v2 = self.ambient_viewcond_adjust_textctrl.GetValue()
		if v1 != getcfg("calibration.ambient_viewcond_adjust") or \
		   v2 != getcfg("calibration.ambient_viewcond_adjust.lux", False):
			self.cal_changed()
		setcfg("calibration.ambient_viewcond_adjust", v1)
		setcfg("calibration.ambient_viewcond_adjust.lux", v2)
		self.update_profile_name()
		if event.GetEventType() == wx.EVT_KILL_FOCUS.evtType[0]:
			event.Skip()

	def ambient_viewcond_adjust_info_handler(self, event):
		InfoDialog(self, 
				   msg=lang.getstr("calibration.ambient_viewcond_adjust.info"), 
				   ok=lang.getstr("ok"), 
				   bitmap=geticon(32, "dialog-information"), log=False)

	def black_luminance_ctrl_handler(self, event):
		if event.GetId() == self.black_luminance_textctrl.GetId() and (
		   self.black_luminance_ctrl.GetSelection() != 1 or 
		   getcfg("calibration.black_luminance") == 
		   self.black_luminance_textctrl.GetValue() or
		   not self.black_luminance_ctrl.IsShown()):
			event.Skip()
			return
		if debug:
			safe_print("[D] black_luminance_ctrl_handler called for ID %s %s "
					   "event type %s %s" % (event.GetId(), 
											 getevtobjname(event, self), 
											 event.GetEventType(), 
											 getevttype(event)))
		self.calpanel.Freeze()
		if self.black_luminance_ctrl.GetSelection() == 1: # cd/m2
			self.black_luminance_textctrl.Show()
			self.black_luminance_textctrl_label.Show()
			try:
				v = self.black_luminance_textctrl.GetValue()
				if v < 0.000001 or v > 100000:
					raise ValueError()
			except ValueError:
				wx.Bell()
				self.black_luminance_textctrl.SetValue(
					getcfg("calibration.black_luminance"))
			if (event.GetId() == self.black_luminance_ctrl.GetId() and
				self.black_luminance_ctrl.GetSelection() == 1):
				self.black_luminance_textctrl.SetFocus()
		else:
			self.black_luminance_textctrl.Hide()
			self.black_luminance_textctrl_label.Hide()
		self.calpanel.Layout()
		self.calpanel.Refresh()
		self.calpanel.Thaw()
		v = self.get_black_luminance()
		if v != str(getcfg("calibration.black_luminance", False)):
			self.cal_changed()
		setcfg("calibration.black_luminance", v)
		self.update_profile_name()
		if event.GetEventType() == wx.EVT_KILL_FOCUS.evtType[0]:
			event.Skip()

	def luminance_ctrl_handler(self, event):
		if event.GetId() == self.luminance_textctrl.GetId() and (
		   self.luminance_ctrl.GetSelection() != 1 or 
		   getcfg("calibration.luminance") == 
		   self.luminance_textctrl.GetValue()):
			event.Skip()
			return
		if debug:
			safe_print("[D] luminance_ctrl_handler called for ID %s %s event "
					   "type %s %s" % (event.GetId(), 
									   getevtobjname(event, self), 
									   event.GetEventType(), 
									   getevttype(event)))
		self.calpanel.Freeze()
		if self.luminance_ctrl.GetSelection() == 1: # cd/m2
			self.luminance_textctrl.Show()
			self.luminance_textctrl_label.Show()
			try:
				v = self.luminance_textctrl.GetValue()
				if v < 0.000001 or v > 100000:
					raise ValueError()
			except ValueError:
				wx.Bell()
				self.luminance_textctrl.SetValue(
					getcfg("calibration.luminance"))
			if (event.GetId() == self.luminance_ctrl.GetId() and
				self.luminance_ctrl.GetSelection() == 1):
				self.luminance_textctrl.SetFocus()
		else:
			self.luminance_textctrl.Hide()
			self.luminance_textctrl_label.Hide()
		self.calpanel.Layout()
		self.calpanel.Refresh()
		self.calpanel.Thaw()
		v = self.get_luminance()
		if v != str(getcfg("calibration.luminance", False)):
			self.cal_changed()
		setcfg("calibration.luminance", v)
		self.update_profile_name()
		if event.GetEventType() == wx.EVT_KILL_FOCUS.evtType[0]:
			event.Skip()

	def whitepoint_colortemp_locus_ctrl_handler(self, event):
		if debug:
			safe_print("[D] whitepoint_colortemp_locus_ctrl_handler called for "
					   "ID %s %s event type %s %s" % (event.GetId(), 
													  getevtobjname(event, 
																	self), 
													  event.GetEventType(), 
													  getevttype(event)))
		v = self.get_whitepoint_locus()
		if v != getcfg("whitepoint.colortemp.locus"):
			setcfg("whitepoint.colortemp.locus", v)
			self.whitepoint_ctrl_handler(
				CustomEvent(wx.EVT_CHOICE.evtType[0], 
				self.whitepoint_ctrl), False)
			self.cal_changed()
		self.update_profile_name()

	def whitepoint_ctrl_handler(self, event, cal_changed=True):
		if event.GetId() == self.whitepoint_colortemp_textctrl.GetId() and (
		   self.whitepoint_ctrl.GetSelection() != 1 or 
		   str(int(getcfg("whitepoint.colortemp"))) == 
		   self.whitepoint_colortemp_textctrl.GetValue()):
			event.Skip()
			return
		if event.GetId() == self.whitepoint_x_textctrl.GetId() and (
		   self.whitepoint_ctrl.GetSelection() != 2 or 
		   round(getcfg("whitepoint.x"), 4) == round(self.whitepoint_x_textctrl.GetValue(), 4)):
			event.Skip()
			return
		if event.GetId() == self.whitepoint_y_textctrl.GetId() and (
		   self.whitepoint_ctrl.GetSelection() != 2 or 
		   round(getcfg("whitepoint.y"), 4) == round(self.whitepoint_y_textctrl.GetValue(), 4)):
			event.Skip()
			return
		if (event.GetEventObject() and
			hasattr(event.GetEventObject(), "IsShown") and
			not event.GetEventObject().IsShown()):
			event.Skip()
			return
		if debug:
			safe_print("[D] whitepoint_ctrl_handler called for ID %s %s event "
					   "type %s %s" % (event.GetId(), 
									   getevtobjname(event, self), 
									   event.GetEventType(), 
									   getevttype(event)))
		self.calpanel.Freeze()
		show_advanced_options = bool(getcfg("show_advanced_options"))
		if self.whitepoint_ctrl.GetSelection() == 2: # x,y chromaticity coordinates
			self.whitepoint_colortemp_locus_label.Hide()
			self.whitepoint_colortemp_locus_ctrl.Hide()
			self.whitepoint_colortemp_textctrl.Hide()
			self.whitepoint_colortemp_label.Hide()
			self.whitepoint_x_textctrl.Show()
			self.whitepoint_x_label.Show()
			self.whitepoint_y_textctrl.Show()
			self.whitepoint_y_label.Show()
			try:
				v = self.whitepoint_x_textctrl.GetValue()
				if v < 0 or v > 1:
					raise ValueError()
			except ValueError:
				wx.Bell()
				self.whitepoint_x_textctrl.SetValue(round(getcfg("whitepoint.x"), 4))
			try:
				v = self.whitepoint_y_textctrl.GetValue()
				if v < 0 or v > 1:
					raise ValueError()
			except ValueError:
				wx.Bell()
				self.whitepoint_y_textctrl.SetValue(round(getcfg("whitepoint.y"), 4))
			x = self.whitepoint_x_textctrl.GetValue()
			y = self.whitepoint_y_textctrl.GetValue()
			k = xyY2CCT(x, y, 1.0)
			if k:
				self.whitepoint_colortemp_textctrl.SetValue(
					str(stripzeros(math.ceil(k))))
			else:
				self.whitepoint_colortemp_textctrl.SetValue("")
			if cal_changed:
				if not getcfg("whitepoint.colortemp") and \
				   x == getcfg("whitepoint.x") and \
				   y == getcfg("whitepoint.y"):
					cal_changed = False
			setcfg("whitepoint.colortemp", None)
			setcfg("whitepoint.x", x)
			setcfg("whitepoint.y", y)
			if (event.GetId() == self.whitepoint_ctrl.GetId() and
				self.whitepoint_ctrl.GetSelection() == 2 and
				not self.updatingctrls):
				self.whitepoint_x_textctrl.SetFocus()
		elif self.whitepoint_ctrl.GetSelection() == 1:
			self.whitepoint_colortemp_locus_label.Show(show_advanced_options)
			self.whitepoint_colortemp_locus_ctrl.Show(show_advanced_options)
			self.whitepoint_colortemp_textctrl.Show()
			self.whitepoint_colortemp_label.Show()
			self.whitepoint_x_textctrl.Hide()
			self.whitepoint_x_label.Hide()
			self.whitepoint_y_textctrl.Hide()
			self.whitepoint_y_label.Hide()
			try:
				v = float(
					self.whitepoint_colortemp_textctrl.GetValue().replace(
						",", "."))
				if v < 1000 or v > 15000:
					raise ValueError()
				self.whitepoint_colortemp_textctrl.SetValue(str(stripzeros(v)))
			except ValueError:
				wx.Bell()
				self.whitepoint_colortemp_textctrl.SetValue(
					str(stripzeros(getcfg("whitepoint.colortemp"))))
			if cal_changed:
				v = float(self.whitepoint_colortemp_textctrl.GetValue())
				if getcfg("whitepoint.colortemp") == v and not \
				   getcfg("whitepoint.x") and not getcfg("whitepoint.y"):
					cal_changed = False
			setcfg("whitepoint.colortemp", int(v))
			setcfg("whitepoint.x", None)
			setcfg("whitepoint.y", None)
			if (event.GetId() == self.whitepoint_ctrl.GetId() and
				self.whitepoint_ctrl.GetSelection() == 1 and
				not self.updatingctrls):
				self.whitepoint_colortemp_textctrl.SetFocus()
				self.whitepoint_colortemp_textctrl.SelectAll()
		else:
			self.whitepoint_colortemp_locus_label.Show(show_advanced_options)
			self.whitepoint_colortemp_locus_ctrl.Show(show_advanced_options)
			self.whitepoint_colortemp_textctrl.Hide()
			self.whitepoint_colortemp_label.Hide()
			self.whitepoint_x_textctrl.Hide()
			self.whitepoint_x_label.Hide()
			self.whitepoint_y_textctrl.Hide()
			self.whitepoint_y_label.Hide()
			if not getcfg("whitepoint.colortemp") and \
			   not getcfg("whitepoint.x") and not getcfg("whitepoint.y"):
				cal_changed = False
			setcfg("whitepoint.colortemp", None)
			self.whitepoint_colortemp_textctrl.SetValue(
					str(stripzeros(getcfg("whitepoint.colortemp"))))
			setcfg("whitepoint.x", None)
			setcfg("whitepoint.y", None)
		self.visual_whitepoint_editor_btn.Show(self.whitepoint_ctrl.GetSelection() > 0)
		self.whitepoint_measure_btn.Show(self.whitepoint_ctrl.GetSelection() > 0)
		self.calpanel.Layout()
		self.calpanel.Refresh()
		self.calpanel.Thaw()
		self.show_observer_ctrl()
		if self.whitepoint_ctrl.GetSelection() != 2:
			if getcfg("whitepoint.colortemp.locus") == "T":
				# Planckian locus
				xyY = planckianCT2xyY(getcfg("whitepoint.colortemp"))
			else:
				# Daylight locus
				xyY = CIEDCCT2xyY(getcfg("whitepoint.colortemp"))
			if xyY:
				self.whitepoint_x_textctrl.SetValue(round(xyY[0], 4))
				self.whitepoint_y_textctrl.SetValue(round(xyY[1], 4))
			else:
				self.whitepoint_x_textctrl.SetValue(0)
				self.whitepoint_y_textctrl.SetValue(0)
		if cal_changed and not self.updatingctrls:
			self.cal_changed()
			self.update_profile_name()
		if event.GetEventType() == wx.EVT_KILL_FOCUS.evtType[0]:
			event.Skip()

	def trc_type_ctrl_handler(self, event):
		if debug:
			safe_print("[D] trc_type_ctrl_handler called for ID %s %s event "
					   "type %s %s" % (event.GetId(), 
									   getevtobjname(event, self), 
									   event.GetEventType(), 
									   getevttype(event)))
		v = self.get_trc_type()
		if v != getcfg("trc.type"):
			setcfg("trc.type", v)
			self.cal_changed()
			self.update_profile_name()
			self.update_trc_control()
			self.show_trc_controls(True)

	def trc_ctrl_handler(self, event, cal_changed=True):
		if event.GetId() == self.trc_textctrl.GetId() and (
		   self.trc_ctrl.GetSelection() not in (1, 4, 7) or stripzeros(getcfg("trc")) == 
		   stripzeros(self.trc_textctrl.GetValue())):
			event.Skip()
			self.show_trc_controls(True)
			return
		if debug:
			safe_print("[D] trc_ctrl_handler called for ID %s %s event type %s "
					   "%s" % (event.GetId(), getevtobjname(event, self), 
							   event.GetEventType(), getevttype(event)))
		self.panel.Freeze()
		unload_cal = True
		if event.GetId() == self.trc_ctrl.GetId():
			bt1886 = (getcfg("trc.type") == "G" and
					  getcfg("calibration.black_output_offset") == 0 and
					  getcfg("trc") == 2.4)
			if self.trc_ctrl.GetSelection() == 1:
				# Gamma 2.2
				self.trc_textctrl.SetValue("2.2")
				setcfg("trc.type", "g")
				self.trc_type_ctrl.SetSelection(0)
				setcfg("calibration.black_output_offset", 1)
				self.black_output_offset_ctrl.SetValue(100)
				self.black_output_offset_intctrl.SetValue(100)
			elif self.trc_ctrl.GetSelection() == 4:
				# BT.1886
				if not bt1886 and not getcfg("trc.backup", False):
					setcfg("trc.backup", self.trc_textctrl.GetValue().replace(",", "."))
					setcfg("trc.type.backup", getcfg("trc.type"))
					setcfg("calibration.black_output_offset.backup",
						   getcfg("calibration.black_output_offset"))
				self.trc_textctrl.SetValue("2.4")
				setcfg("trc.type", "G")
				self.trc_type_ctrl.SetSelection(1)
				setcfg("calibration.black_output_offset", 0)
				self.black_output_offset_ctrl.SetValue(0)
				self.black_output_offset_intctrl.SetValue(0)
			elif self.trc_ctrl.GetSelection() not in (0, 1, 7):
				self.restore_trc_backup()
				if getcfg("calibration.black_output_offset.backup") is not None:
					setcfg("calibration.black_output_offset",
						   getcfg("calibration.black_output_offset.backup"))
					setcfg("calibration.black_output_offset.backup", None)
					self.update_black_output_offset_ctrl()
			elif self.trc_ctrl.GetSelection() == 0:
				# As measured
				unload_cal = False
		if self.trc_ctrl.GetSelection() in (1, 4, 7):
			try:
				v = float(self.trc_textctrl.GetValue().replace(",", "."))
				if v == 0 or v > 10:
					raise ValueError()
			except ValueError:
				wx.Bell()
				self.trc_textctrl.SetValue(str(getcfg("trc")))
			else:
				if str(v) != self.trc_textctrl.GetValue():
					self.trc_textctrl.SetValue(str(v))
			if event.GetId() == self.trc_ctrl.GetId():
				# Have to use CallAfter, otherwise only part of the text will
				# be selected (wxPython bug?)
				wx.CallAfter(self.trc_textctrl.SetFocus)
				wx.CallLater(1, self.trc_textctrl.SelectAll)
		trc = self.get_trc()
		if cal_changed:
			if trc != str(getcfg("trc")):
				if unload_cal:
					self.cal_changed()
				else:
					self.worker.options_dispcal = []
					self.profile_settings_changed()
		setcfg("trc", trc)
		if cal_changed:
			self.update_profile_name()
		if event.GetId() != self.trc_ctrl.GetId():
			self.update_trc_control()
		else:
			self.lut3d_update_apply_cal_control()
		self.update_adjustment_controls()
		self.show_trc_controls()
		self.calpanel.Layout()
		self.calpanel.Refresh()
		self.panel.Thaw()
		self.set_size(True)
		self.update_scrollbars()
		self.update_main_controls()
		if event.GetEventType() == wx.EVT_KILL_FOCUS.evtType[0]:
			event.Skip()
		if (trc in ("240", "709", "s") and not
		    (bool(int(getcfg("calibration.ambient_viewcond_adjust"))) and 
			 getcfg("calibration.ambient_viewcond_adjust.lux")) and
			getcfg("trc.should_use_viewcond_adjust.show_msg") and
			getcfg("show_advanced_options")):
			dlg = InfoDialog(self, 
							 msg=lang.getstr("trc.should_use_viewcond_adjust"), 
							 ok=lang.getstr("ok"), 
							 bitmap=geticon(32, "dialog-information"), 
							 show=False, log=False)
			chk = wx.CheckBox(dlg, -1, lang.getstr("dialog.do_not_show_again"))
			dlg.Bind(wx.EVT_CHECKBOX, self.should_use_viewcond_adjust_handler, 
					 id=chk.GetId())
			dlg.sizer3.Add(chk, flag=wx.TOP | wx.ALIGN_LEFT, border=12)
			dlg.sizer0.SetSizeHints(dlg)
			dlg.sizer0.Layout()
			dlg.ShowModalThenDestroy()
	
	def restore_trc_backup(self):
		if getcfg("trc.backup"):
			setcfg("trc", getcfg("trc.backup"))
			setcfg("trc.backup", None)
			self.trc_textctrl.SetValue(str(getcfg("trc")))
		if getcfg("trc.type.backup"):
			setcfg("trc.type", getcfg("trc.type.backup"))
			setcfg("trc.type.backup", None)
			self.trc_type_ctrl.SetSelection(
				self.trc_types_ba.get(getcfg("trc.type"), 
									  self.trc_types_ba.get(defaults["trc.type"])))

	def should_use_viewcond_adjust_handler(self, event):
		setcfg("trc.should_use_viewcond_adjust.show_msg", 
			   int(not event.GetEventObject().GetValue()))

	def check_overwrite(self, ext="", filename=None):
		if not filename:
			filename = getcfg("profile.name.expanded") + ext
			dst_file = os.path.join(getcfg("profile.save_path"), 
									getcfg("profile.name.expanded"), filename)
		else:
			dst_file = os.path.join(getcfg("profile.save_path"), filename)
		if os.path.exists(dst_file):
			dlg = ConfirmDialog(self, msg=lang.getstr("warning.already_exists", 
													  filename), 
								ok=lang.getstr("ok"), 
								cancel=lang.getstr("cancel"), 
								bitmap=geticon(32, "dialog-warning"))
			result = dlg.ShowModal()
			dlg.Destroy()
			if result != wx.ID_OK: return False
		return True
	
	def measure_uniformity_handler(self, event):
		""" Start measuring display device uniformity """
		dlg = ConfirmDialog(self, msg=lang.getstr("patch.layout.select"),
							ok=lang.getstr("ok"), 
							cancel=lang.getstr("cancel"), 
							bitmap=geticon(32, "dialog-information"))
		sizer = wx.BoxSizer(wx.HORIZONTAL)
		dlg.sizer3.Add(sizer, flag=wx.TOP, border=12)
		cols = wx.Choice(dlg, -1,
						 choices=map(str, config.valid_values["uniformity.cols"]))
		rows = wx.Choice(dlg, -1,
						 choices=map(str, config.valid_values["uniformity.rows"]))
		cols.SetStringSelection(str(getcfg("uniformity.cols")))
		rows.SetStringSelection(str(getcfg("uniformity.rows")))
		sizer.Add(cols, flag=wx.ALIGN_CENTER_VERTICAL)
		sizer.Add(wx.StaticText(dlg, -1, "x"), flag=wx.LEFT | wx.RIGHT |
													wx.ALIGN_CENTER_VERTICAL,
								border=4)
		sizer.Add(rows, flag=wx.ALIGN_CENTER_VERTICAL)
		dlg.sizer0.SetSizeHints(dlg)
		dlg.sizer0.Layout()
		dlg.ok.SetDefault()
		result = dlg.ShowModal()
		if result == wx.ID_OK:
			setcfg("uniformity.cols", int(cols.GetStringSelection()))
			setcfg("uniformity.rows", int(rows.GetStringSelection()))
		dlg.Destroy()
		if result != wx.ID_OK:
			return
		if isinstance(getattr(self.worker, "terminal", None),
					  DisplayUniformityFrame):
			self.worker.terminal.Destroy()
			self.worker.terminal = None
		self.HideAll()
		self.worker.interactive = True
		self.worker.start(self.measure_uniformity_consumer,
						  self.measure_uniformity_producer, resume=False, 
						  continue_next=False, interactive_frame="uniformity")
	
	def measure_uniformity_producer(self):
		cmd, args = get_argyll_util("spotread"), ["-v", "-e", "-T"]
		if cmd:
			result = self.worker.add_measurement_features(args, display=False)
			if isinstance(result, Exception):
				return result
			return self.worker.exec_cmd(cmd, args, skip_scripts=True)
		else:
			wx.CallAfter(show_result_dialog,
						 Error(lang.getstr("argyll.util.not_found",
										   "spotread")), self)
	
	def measure_uniformity_consumer(self, result):
		self.Show()
		if isinstance(result, Exception):
			show_result_dialog(result, self)
			if getcfg("dry_run"):
				return
		for i, line in enumerate(self.worker.output):
			if line.startswith("spotread: Warning"):
				show_result_dialog(Warn(line.strip()), self)
	
	def profile_share_get_meta_error(self, profile):
		""" Check for required metadata in profile to allow sharing.
		
		The treshold for average delta E 1976 is 1.0
		
		"""
		if ("meta" in profile.tags and
			isinstance(profile.tags.meta, ICCP.DictType)):
			try:
				avg_dE76 = float(profile.tags.meta.getvalue("ACCURACY_dE76_avg"))
			except (TypeError, ValueError):
				return lang.getstr("profile.share.meta_missing")
			else:
				threshold = 1.0
				if avg_dE76 and avg_dE76 > threshold:
					return lang.getstr("profile.share.avg_dE_too_high",
									   ("%.2f" % avg_dE76, "%.2f" % threshold))
				else:
					# Check for EDID metadata
					metadata = profile.tags.meta
					if "EDID_mnft" in metadata:
						# Check and correct manufacturer if necessary
						manufacturer = get_manufacturer_name(metadata["EDID_mnft"])
						if manufacturer:
							manufacturer = colord.quirk_manufacturer(manufacturer)
							if (not "EDID_manufacturer" in metadata or
								metadata["EDID_manufacturer"] != manufacturer):
								metadata["EDID_manufacturer"] = manufacturer
					if (not "EDID_model_id" in metadata or
						(not "EDID_model" in metadata and
						 metadata["EDID_model_id"] == "0") or
						not "EDID_mnft_id" in metadata or
						not "EDID_mnft" in metadata or
						not "EDID_manufacturer" in metadata or
						not "OPENICC_automatic_generated" in metadata):
						return lang.getstr("profile.share.meta_missing")
					if ("B2A0" in profile.tags and
						isinstance(profile.tags.B2A0, ICCP.LUT16Type) and
						profile.tags.B2A0.input_entries_count < 1024):
						# 1024 is the Argyll value for a medium quality profile
						return lang.getstr("profile.share.b2a_resolution_too_low")
		else:
			return lang.getstr("profile.share.meta_missing")
	
	def profile_share_handler(self, event):
		""" Share ICC profile via http://icc.opensuse.org """
		# Select profile
		profile = get_current_profile(include_display_profile=True)
		ignore = not profile or self.profile_share_get_meta_error(profile)
		kwargs = {"ignore_current_profile": ignore,
				  "prefer_current_profile": isinstance(event.EventObject,
													   wx.Button),
				  "title": lang.getstr("profile.share")}
		profile = self.select_profile(**kwargs)
		if not profile:
			return
		
		# Check meta and profcheck data
		error = self.profile_share_get_meta_error(profile)
		if error:
			InfoDialog(getattr(self, "modaldlg", self), msg=error,
					   ok=lang.getstr("ok"), bitmap=geticon(32, "dialog-error"))
			return
		
		# Get options from profile
		options_dispcal, options_colprof = get_options_from_profile(profile)
		gamma = None
		for option in options_dispcal:
			if option.startswith("g") or option.startswith("G"):
				option = option[1:]
				gamma = {"240": "SMPTE 240M",
						 "709": "Rec. 709",
						 "l": "L*",
						 "s": "sRGB"}.get(option, "Gamma %s" % option)

		metadata = profile.tags.meta
		# Model will be shown in overview on http://icc.opensuse.org
		model = metadata.getvalue("EDID_model",
								  profile.getDeviceModelDescription() or
								  metadata["EDID_model_id"],
								  None)
		description = model
		date = metadata.getvalue("EDID_date", "", None).split("-T")
		if len(date) == 2:
			year = int(date[0])
			week = int(date[1])
			date = datetime.date(int(year), 1, 1) + datetime.timedelta(weeks=week)
			description += " '" + strftime("%y", date.timetuple())
		if isinstance(profile.tags.get("vcgt"), ICCP.VideoCardGammaType):
			if profile.tags.vcgt.is_linear():
				vcgt = "linear VCGT"
			else:
				vcgt = "VCGT"
		else:
			vcgt = "no VCGT"
		if vcgt:
			description += ", " + vcgt
		whitepoint = "%iK" % round(XYZ2CCT(*profile.tags.wtpt.values()))
		description += ", " + whitepoint
		description += u", %i cd/m²" % profile.tags.lumi.Y 
		if gamma:
			description += ", " + gamma
		instrument = metadata.getvalue("MEASUREMENT_device")
		if instrument:
			for instrument_name in instruments:
				if instrument_name.lower() == instrument:
					instrument = instrument_name
					break
			description += ", " + instrument
		description += ", " + strftime("%Y-%m-%d", profile.dateTime.timetuple())
		dlg = ConfirmDialog(
			getattr(self, "modaldlg", self), title=lang.getstr("profile.share"),
			msg=lang.getstr("profile.share.enter_info"), 
			ok=lang.getstr("upload"), cancel=lang.getstr("cancel"), 
			bitmap=geticon(32, appname + "-profile-info"), alt=lang.getstr("save"),
			wrap=100)
		# Description field
		boxsizer = wx.StaticBoxSizer(wx.StaticBox(dlg, -1,
												  lang.getstr("description")),
									 wx.VERTICAL)
		dlg.sizer3.Add(boxsizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
		if sys.platform not in ("darwin", "win32"):
			boxsizer.Add((1, 8))
		dlg.description_txt_ctrl = wx.TextCtrl(dlg, -1, 
											   description)
		boxsizer.Add(dlg.description_txt_ctrl, 1, flag=wx.ALL | wx.EXPAND,
					 border=4)
		# Display properties
		boxsizer = wx.StaticBoxSizer(wx.StaticBox(dlg, -1,
												  lang.getstr("display.properties")),
									 wx.VERTICAL)
		dlg.sizer3.Add(boxsizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
		if sys.platform not in ("darwin", "win32"):
			boxsizer.Add((1, 8))
		box_gridsizer = wx.FlexGridSizer(0, 1, 0, 0)
		boxsizer.Add(box_gridsizer, 1, flag=wx.ALL, border=4)
		# Display panel surface type, connection
		gridsizer = wx.FlexGridSizer(0, 4, 4, 8)
		box_gridsizer.Add(gridsizer, 1, wx.ALIGN_LEFT)
		# Panel surface type
		gridsizer.Add(wx.StaticText(dlg, -1, lang.getstr("panel.surface")), 1, 
					   flag=wx.ALIGN_LEFT | wx.ALIGN_CENTER_VERTICAL)
		paneltypes = ["glossy", "matte"]
		dlg.panel_ctrl = wx.Choice(dlg, -1, 
								   choices=[""] + [lang.getstr(panel)
												   for panel in
												   paneltypes])
		panel_surface = metadata.getvalue("SCREEN_surface", "")
		try:
			index = dlg.panel_ctrl.GetItems().index(lang.getstr(panel_surface))
		except ValueError:
			index = 0
		dlg.panel_ctrl.SetSelection(index)
		gridsizer.Add(dlg.panel_ctrl, 1, flag=wx.RIGHT | wx.ALIGN_LEFT |
					  wx.ALIGN_CENTER_VERTICAL, border=8)
		# Connection type
		gridsizer.Add(wx.StaticText(dlg, -1,
									lang.getstr("display.connection.type")), 1,
					  flag=wx.ALIGN_LEFT | wx.ALIGN_CENTER_VERTICAL)
		connections = ["dvi", "displayport", "hdmi", "internal", "vga"]
		dlg.connection_ctrl = wx.Choice(dlg, -1, 
										choices=[lang.getstr(contype)
												 for contype in
												 connections])
		connection_type = metadata.getvalue("CONNECTION_type",
											"dvi")
		try:
			index = dlg.connection_ctrl.GetItems().index(lang.getstr(connection_type))
		except ValueError:
			index = 0
		dlg.connection_ctrl.SetSelection(index)
		gridsizer.Add(dlg.connection_ctrl, 1, flag=wx.RIGHT | wx.ALIGN_LEFT |
					  wx.ALIGN_CENTER_VERTICAL, border=8)
		if sys.platform == "darwin":
			display_settings_tabs = wx.Notebook(dlg, -1)
		else:
			display_settings_tabs = aui.AuiNotebook(dlg, -1, style=aui.AUI_NB_TOP)
			display_settings_tabs._agwFlags = aui.AUI_NB_TOP
			try:
				art = AuiBetterTabArt()
				if sys.platform == "win32":
					art.SetDefaultColours(aui.StepColour(dlg.BackgroundColour, 96))
				display_settings_tabs.SetArtProvider(art)
			except Exception, exception:
				safe_print(exception)
				pass
		dlg.display_settings = display_settings_tabs
		# Column layout
		scale = getcfg("app.dpi") / config.get_default_dpi()
		if scale < 1:
			scale = 1
		display_settings = ((# 1st tab
							 lang.getstr("osd") + ": " +
							 lang.getstr("settings.basic"), # Tab title
							 2, # Number of columns
							 (# 1st (left) column
							  (("preset", 150),
							   ("brightness", 50),
							   ("contrast", 50),
							   ("trc.gamma", 50),
							   ("blacklevel", 50),
							   ("hue", 50)),
							  # 2nd (right) column
							  (("", 0),
							   ("whitepoint.colortemp", 125),
							   ("whitepoint", 50),
							   ("saturation", 50)))),
							(# 2nd tab
							 lang.getstr("osd") + ": " +
							 lang.getstr("settings.additional"), # Tab title
							 3, # Number of columns
							 (# 1st (left) column
							  (("hue", 50), ),
							  # 2nd (middle) column
							  (("offset", 50), ),
							  # 3rd (right) column
							  (("saturation", 50), ))))
		display_settings_ctrls = []
		for tab_num, settings in enumerate(display_settings):
			panel = wx.Panel(display_settings_tabs, -1)
			panel.SetSizer(wx.BoxSizer(wx.VERTICAL))
			gridsizer = wx.FlexGridSizer(0, settings[1] * 2, 4, 12)
			panel.GetSizer().Add(gridsizer, 1, wx.ALL | wx.EXPAND, border=8)
			display_settings_tabs.AddPage(panel, settings[0])
			ctrls = []
			texts = []
			for column in settings[2]:
				for name, width in column:
					if name in ("whitepoint", ):
						components = ("red", "green", "blue")
					elif tab_num == 1 and name in ("hue", "offset",
												   "saturation"):
						components = ("red", "green", "blue", "cyan", "magenta",
									  "yellow")
					else:
						components = ("", )
					nameprefix = name
					for component in components:
						if component:
							name = nameprefix + "_" + component
						if name:
							label = name
							if ("_" in label):
								label = label.split("_")
								for i, part in enumerate(label):
									label[i] = lang.getstr(part)
								label = " ".join(label)
							else:
								label = lang.getstr(label)
							text = wx.StaticText(panel, -1, label)
							ctrl = wx.TextCtrl(panel, -1,
											   metadata.getvalue("OSD_settings_%s" %
																 re.sub("[ .]", "_", name), ""),
											   size=(width * scale, -1),
											   name=name)
						else:
							text = (0, 0)
							ctrl = (0, 0)
						texts.append(text)
						ctrls.append(ctrl)
						display_settings_ctrls.append(ctrl)
			# Add the controls to the sizer
			rows = int(math.ceil(len(ctrls) / float(settings[1])))
			for row_num in range(rows):
				for column_num in range(settings[1]):
					ctrl_index = row_num + column_num * rows
					if ctrl_index < len(ctrls):
						gridsizer.Add(texts[ctrl_index],
									  1, flag=wx.ALIGN_CENTER_VERTICAL |
											  wx.ALIGN_LEFT)
						gridsizer.Add(ctrls[ctrl_index], 1, 
									   flag=wx.ALIGN_CENTER_VERTICAL |
											wx.ALIGN_LEFT | wx.RIGHT, border=4)
			if isinstance(display_settings_tabs, aui.AuiNotebook):
				if sys.platform != "win32":
					display_settings_tabs.SetTabCtrlHeight(display_settings_tabs.GetTabCtrlHeight() + 2)
				height = display_settings_tabs.GetHeightForPageHeight(panel.Sizer.MinSize[1])
			else:
				height = -1
			display_settings_tabs.SetMinSize((dlg.sizer3.MinSize[0] - 16,
											  height))
		box_gridsizer.Add(display_settings_tabs, 1, 
					   flag=wx.TOP | wx.ALIGN_LEFT, border=8)
		# License field
		##dlg.sizer3.Add(wx.StaticText(dlg, -1, lang.getstr("license")), 1, 
					   ##flag=wx.TOP | wx.ALIGN_LEFT, border=12)
		##dlg.license_ctrl = wx.Choice(dlg, -1, 
									 ##choices=["http://www.color.org/registry/icc_license_2011.txt",
											  ##"http://www.gzip.org/zlib/zlib_license.html"])
		##dlg.license_ctrl.SetSelection(0)
		##sizer4 = wx.BoxSizer(wx.HORIZONTAL)
		##dlg.sizer3.Add(sizer4, 1, 
					   ##flag=wx.TOP | wx.ALIGN_LEFT, border=4)
		##sizer4.Add(dlg.license_ctrl, 1, 
					   ##flag=wx.RIGHT | wx.ALIGN_LEFT | wx.ALIGN_CENTER_VERTICAL,
							##border=8)
		# License link button
		##dlg.license_link_ctrl = wx.BitmapButton(dlg, -1,
												##geticon(16, "dialog-information"), 
												##style=wx.NO_BORDER)
		##dlg.license_link_ctrl.SetToolTipString(lang.getstr("license"))
		##dlg.Bind(wx.EVT_BUTTON,
				 ##lambda event: launch_file(dlg.license_ctrl.GetValue()),
				 ##dlg.license_link_ctrl)
		##sizer4.Add(dlg.license_link_ctrl, flag=wx.ALIGN_LEFT |
				   ##wx.ALIGN_CENTER_VERTICAL)
		# Link to ICC Profile Taxi service
		hyperlink = HyperLinkCtrl(dlg.buttonpanel, -1,
												   label="icc.opensuse.org", 
												   URL="https://icc.opensuse.org/")
		dlg.sizer2.Insert(0, hyperlink, flag=wx.ALIGN_LEFT |
											 wx.ALIGN_CENTER_VERTICAL | wx.LEFT,
						  border=int(round((32 + 12) * scale)))
		dlg.description_txt_ctrl.SetFocus()
		dlg.sizer0.SetSizeHints(dlg)
		dlg.sizer0.Layout()
		dlg.Center()
		result = dlg.ShowModal()
		if result == wx.ID_CANCEL:
			return
		# Get meta prefix
		prefixes = (metadata.getvalue("prefix", "", None) or "CONNECTION_").split(",")
		if not "CONNECTION_" in prefixes:
			prefixes.append("CONNECTION_")
		# Update meta
		panel = dlg.panel_ctrl.GetSelection()
		if panel > 0:
			metadata["SCREEN_surface"] = paneltypes[panel - 1]
			if not "SCREEN_" in prefixes:
				prefixes.append("SCREEN_")
		# Update meta
		metadata["CONNECTION_type"] = connections[dlg.connection_ctrl.GetSelection()]
		for ctrl in display_settings_ctrls:
			if isinstance(ctrl, wx.TextCtrl) and ctrl.GetValue().strip():
				metadata["OSD_settings_%s" %
						 re.sub("[ .]", "_", ctrl.Name)] = ctrl.GetValue().strip()
			if not "OSD_" in prefixes:
				prefixes.append("OSD_")
		# Set meta prefix
		metadata["prefix"] = ",".join(prefixes)
		# Calculate profile ID
		profile.calculateID()
		# Save profile
		try:
			profile.write()
		except EnvironmentError, exception:
			show_result_dialog(exception, self)
		if result != wx.ID_OK:
			return
		# Get profile data
		data = profile.data
		# Add metadata which should not be reflected in profile
		metadata["model"] = model
		metadata["vcgt"] = int("vcgt" in profile.tags)
		# Upload
		params = {"description": dlg.description_txt_ctrl.GetValue(),
				  ##"licence": dlg.license_ctrl.GetValue()}
				  "licence": "http://www.color.org/registry/icc_license_2011.txt"}
		files = [("metadata", "metadata.json",
				  '{"org":{"freedesktop":{"openicc":{"device":{"monitor":[%s]}}}}}' %
				  metadata.to_json()),
				 ("profile", "profile.icc", data)]
		self.worker.interactive = False
		self.worker.start(self.profile_share_consumer, 
						  http_request, 
						  ckwargs={}, 
						  wkwargs={"domain": domain.lower() if test
											 else "icc.opensuse.org",
								   "request_type": "POST",
								   "path": "/print_r_post.php" if test
										   else "/upload",
								   "params": params,
								   "files": files},
						  progress_msg=lang.getstr("profile.share"),
						  stop_timers=False, cancelable=False,
						  show_remaining_time=False, fancy=False)

	def profile_share_consumer(self, result, parent=None):
		""" This function receives the response from the profile upload """
		if result is not False:
			safe_print(safe_unicode(result.read().strip(), "UTF-8"))
			parent = parent or getattr(self, "modaldlg", self)
			dlg = InfoDialog(parent, 
							 msg=lang.getstr("profile.share.success"),
							 ok=lang.getstr("ok"), 
							 bitmap=geticon(32, "dialog-information"),
							 show=False)
			# Link to ICC Profile Taxi service
			hyperlink = HyperLinkCtrl(dlg.buttonpanel, -1,
													   label="icc.opensuse.org", 
													   URL="https://icc.opensuse.org/")
			border = (dlg.sizer3.MinSize[0] - dlg.sizer2.MinSize[0] -
					  hyperlink.Size[0])
			if border < 24:
				border = 24
			dlg.sizer2.Insert(0, hyperlink, flag=wx.ALIGN_LEFT |
												 wx.ALIGN_CENTER_VERTICAL |
												 wx.RIGHT, border=border)
			dlg.sizer2.Insert(0, (44, 1))
			dlg.sizer0.SetSizeHints(dlg)
			dlg.sizer0.Layout()
			dlg.ok.SetDefault()
			dlg.ShowModalThenDestroy(parent)

	def install_argyll_instrument_conf(self, event=None, uninstall=False):
		if uninstall:
			filenames = self.worker.get_argyll_instrument_conf("installed")
			if filenames:
				dlgs = []
				dlg = ConfirmDialog(self,
									title=lang.getstr("argyll.instrument.configuration_files.uninstall"),
									msg=lang.getstr("dialog.confirm_delete"), 
									ok=lang.getstr("delete"),
									cancel=lang.getstr("cancel"), 
									bitmap=geticon(32, "dialog-warning"))
				dlgs.append(dlg)
				dlg.sizer3.Add((0, 8))
				chks = []
				for filename in filenames:
					dlg.sizer3.Add((0, 4))
					chk = wx.CheckBox(dlg, -1, filename)
					chks.append(chk)
					chk.SetValue(os.path.basename(filename) !=
								 "69-cd-sensors.rules")
					dlg.sizer3.Add(chk, flag=wx.ALIGN_LEFT)
				dlg.sizer0.SetSizeHints(dlg)
				dlg.sizer0.Layout()
				dlg.Center()
				result = dlg.ShowModal()
				filenames = []
				if result == wx.ID_OK:
					for chk in chks:
						if chk.GetValue():
							filenames.append(chk.Label)
				for filename in filenames:
					if os.path.basename(filename) == "69-cd-sensors.rules":
						dlg = ConfirmDialog(self,
											title=lang.getstr("argyll.instrument.configuration_files.uninstall"),
											msg=lang.getstr("warning.system_file",
															filename),
											ok=lang.getstr("continue"),
											cancel=lang.getstr("cancel"),
											bitmap=geticon(32, "dialog-warning"))
						dlgs.append(dlg)
						result = dlg.ShowModal()
						if result != wx.ID_OK:
							break
				for dlg in dlgs:
					dlg.Destroy()
			if not filenames or result != wx.ID_OK:
				return
			cmd = "rm"
		else:
			filenames = None
			cmd = "cp"
		result = self.worker.authenticate(which(cmd))
		if result not in (True, None):
			if isinstance(result, Exception):
				show_result_dialog(result, self)
			return
		self.worker.start(self.install_argyll_instrument_conf_consumer,
						  self.worker.install_argyll_instrument_conf,
						  ckwargs={"uninstall": uninstall},
						  wkwargs={"uninstall": uninstall,
								   "filenames": filenames}, fancy=False)

	def install_argyll_instrument_conf_consumer(self, result, uninstall=False):
		if isinstance(result, Exception):
			show_result_dialog(result, self)
		elif result is False:
			show_result_dialog(Error("".join(self.worker.errors)), self)
		else:
			self.update_menus()
			if uninstall:
				msgid = "argyll.instrument.configuration_files.uninstall.success"
			else:
				msgid = "argyll.instrument.configuration_files.install.success"
			show_result_dialog(Info(lang.getstr(msgid)), self)
	
	def install_argyll_instrument_drivers(self, event=None, uninstall=False):
		if uninstall:
			title = "argyll.instrument.drivers.uninstall"
			msg = "argyll.instrument.drivers.uninstall.confirm"
			ok = "continue"
		else:
			title = "argyll.instrument.drivers.install"
			msg = "argyll.instrument.drivers.install.confirm"
			ok = "download_install"
		dlg = ConfirmDialog(self,
							title=lang.getstr(title),
							msg=lang.getstr(msg),
							ok=lang.getstr(ok).replace("&", "&&"),
							cancel=lang.getstr("cancel"),
							bitmap=geticon(32, "dialog-information"))
		dlg.launch_devman = wx.CheckBox(dlg, -1, lang.getstr("device_manager.launch"))
		dlg.launch_devman.SetValue(uninstall)
		dlg.sizer3.Add(dlg.launch_devman, flag=wx.TOP | wx.ALIGN_LEFT,
					   border=12)
		if hasattr(dlg.ok, "SetAuthNeeded"):
			dlg.ok.SetAuthNeeded(True)
		dlg.sizer0.SetSizeHints(dlg)
		dlg.sizer0.Layout()
		result = dlg.ShowModal()
		launch_devman = dlg.launch_devman.IsChecked()
		dlg.Destroy()
		if result != wx.ID_OK:
			return
		safe_print("-" * 80)
		safe_print(lang.getstr(title))
		self.worker.start(lambda result: show_result_dialog(result, self)
										 if isinstance(result, Exception)
										 else self.check_update_controls(True),
						  self.worker.install_argyll_instrument_drivers,
						  wargs=(uninstall, launch_devman), fancy=False)

	def uninstall_argyll_instrument_conf(self, event=None):
		self.install_argyll_instrument_conf(uninstall=True)
	
	def uninstall_argyll_instrument_drivers(self, event=None):
		self.install_argyll_instrument_drivers(uninstall=True)

	def install_profile_handler(self, event=None, profile_path=None,
								install_3dlut=None):
		""" Install a profile. Show an error dialog if the profile is
		invalid or unsupported (only 'mntr' RGB profiles are allowed) """
		if not check_set_argyll_bin():
			return
		if profile_path is None:
			profile_path = getcfg("calibration.file", False)
		if profile_path:
			result = check_file_isfile(profile_path)
			if isinstance(result, Exception):
				show_result_dialog(result, self)
		else:
			result = False
		if install_3dlut is None:
			install_3dlut = self.lut3d_settings_panel.IsShown()
		if not isinstance(result, Exception) and result:
			try:
				profile = ICCP.ICCProfile(profile_path)
			except (IOError, ICCP.ICCProfileInvalidError), exception:
				InfoDialog(self, msg=lang.getstr("profile.invalid") + 
									 "\n" + profile_path, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
			if profile.profileClass != "mntr" or \
			   profile.colorSpace != "RGB":
				InfoDialog(self, msg=lang.getstr("profile.unsupported", 
												 (profile.profileClass, 
												  profile.colorSpace)) +
									 "\n" + profile_path, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
			setcfg("calibration.file.previous", getcfg("calibration.file", False))
			self.profile_finish(
				True, profile_path=profile_path, 
				skip_scripts=True,
				allow_show_log=False,
				install_3dlut=install_3dlut)

	def select_install_profile_handler(self, event):
		""" Show a dialog for user to select a profile for installation """
		defaultDir, defaultFile = get_verified_path("last_icc_path")
		dlg = wx.FileDialog(self, lang.getstr("install_display_profile"), 
							defaultDir=defaultDir, defaultFile=defaultFile, 
							wildcard=lang.getstr("filetype.icc") + 
									 "|*.icc;*.icm", 
							style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
		dlg.Center(wx.BOTH)
		result = dlg.ShowModal()
		path = dlg.GetPath()
		dlg.Destroy()
		if result == wx.ID_OK:
			setcfg("last_icc_path", path)
			setcfg("last_cal_or_icc_path", path)
			self.install_profile_handler(profile_path=path, install_3dlut=False)

	def load_profile_cal_handler(self, event):
		""" Show a dialog for user to select a profile to load calibration
		(vcgt) from. """
		if not check_set_argyll_bin():
			return
		defaultDir, defaultFile = get_verified_path("last_cal_or_icc_path")
		dlg = wx.FileDialog(self, 
							lang.getstr("calibration.load_from_cal_or_profile"), 
							defaultDir=defaultDir, defaultFile=defaultFile, 
							wildcard=lang.getstr("filetype.cal_icc") + 
									 "|*.cal;*.icc;*.icm", 
							style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
		dlg.Center(wx.BOTH)
		result = dlg.ShowModal()
		path = dlg.GetPath()
		dlg.Destroy()
		if result == wx.ID_OK:
			if not os.path.exists(path):
				InfoDialog(self, msg=lang.getstr("file.missing", path), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
			setcfg("last_cal_or_icc_path", path)
			if verbose >= 1:
				safe_print(lang.getstr("calibration.loading"))
				safe_print(path)
			if os.path.splitext(path)[1].lower() in (".icc", ".icm"):
				try:
					profile = ICCP.ICCProfile(path)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					if verbose >= 1: safe_print(lang.getstr("failure"))
					InfoDialog(self, msg=lang.getstr("profile.invalid") + 
										 "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
				setcfg("last_icc_path", path)
				if self.install_cal(capture_output=True, 
									profile_path=path, 
									skip_scripts=True, 
									silent=not getcfg("dry_run"),
									title=lang.getstr("calibration.load_from_profile")) is True:
					self.lut_viewer_load_lut(profile=profile)
					if verbose >= 1: safe_print(lang.getstr("success"))
				elif not getcfg("dry_run"):
					if verbose >= 1: safe_print(lang.getstr("failure"))
					InfoDialog(self, msg=lang.getstr("calibration.load_error") + 
										 "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
			else:
				setcfg("last_cal_path", path)
				if self.install_cal(capture_output=True, cal=path, 
									skip_scripts=True, silent=not getcfg("dry_run"),
									title=lang.getstr("calibration.load_from_cal")) is True:
					self.lut_viewer_load_lut(profile=cal_to_fake_profile(path))
					if verbose >= 1: safe_print(lang.getstr("success"))
				elif not getcfg("dry_run"):
					if verbose >= 1: safe_print(lang.getstr("failure"))

	def preview_handler(self, event=None, preview=False):
		""" Preview profile calibration (vcgt).
		
		Toggle between profile curves and previous calibration curves.
		
		"""
		if preview or self.preview.GetValue():
			cal = self.cal
		else:
			cal = getcfg("calibration.file.previous")
			if self.cal == cal:
				cal = False
			elif not cal:
				cal = True
		if cal is False: # linear
			profile = None
		else:
			if cal is True: # display profile
				profile = get_display_profile()
				if not profile:
					cal = False
			elif cal.lower().endswith(".icc") or \
				 cal.lower().endswith(".icm"):
				try:
					profile = ICCP.ICCProfile(cal)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					show_result_dialog(exception, self)
					profile = None
			else:
				profile = cal_to_fake_profile(cal)
		if profile:
			if verbose >= 1:
				safe_print(lang.getstr("calibration.loading"))
				if profile.fileName:
					safe_print(profile.fileName)
		else:
			if verbose >= 1: safe_print(lang.getstr("calibration.resetting"))
		if self.install_cal(capture_output=True, cal=cal, 
							skip_scripts=True, silent=True,
							title=lang.getstr("calibration.load_from_cal_or_profile")) is True:
			self.lut_viewer_load_lut(profile=profile)
			if verbose >= 1: safe_print(lang.getstr("success"))
		else:
			if verbose >= 1: safe_print(lang.getstr("failure"))
	
	def profile_load_on_login_handler(self, event=None):
		setcfg("profile.load_on_login", 
			   int(self.profile_load_on_login.GetValue()))
		if sys.platform == "win32" and sys.getwindowsversion() >= (6, 1):
			self.profile_load_on_login.Enable(is_superuser() or
											  not util_win.calibration_management_isenabled())
			self.profile_load_by_os.Enable(is_superuser() and
										   self.profile_load_on_login.GetValue())
			if (not self.profile_load_on_login.GetValue() and 
				self.profile_load_by_os.GetValue() and is_superuser()):
				self.profile_load_by_os.SetValue(False)
				self.profile_load_by_os_handler()
		# Update profile loader config
		if sys.platform == "win32" and event:
			prev = self.send_command("apply-profiles",
									 "getcfg profile.load_on_login")
			if prev:
				try:
					prev = int(prev.split()[-1])
				except:
					pass
				result = self.send_command("apply-profiles",
										   "setcfg profile.load_on_login %i" %
										   getcfg("profile.load_on_login"))
				if result == "ok" and getcfg("profile.load_on_login") != prev:
					if getcfg("profile.load_on_login"):
						lstr = "calibration.preserve"
					else:
						lstr = "profile_loader.disable"
					self.send_command("apply-profiles",
									  "notify '%s'" % lang.getstr(lstr))
			else:
				# Profile loader not running? Fall back to config files

				# 1. Remember current config
				items = config.cfg.items(config.ConfigParser.DEFAULTSECT)

				# 2. Read in profile loader config. Result is unison of current
				#    config and profile loader config.
				initcfg("apply-profiles")

				# 3. Restore current config (but do not override profile loader
				#    options)
				for name, value in items:
					if not name.startswith("profile_loader"):
						config.cfg.set(config.ConfigParser.DEFAULTSECT, name,
									   value)

				# 4. Write profile loader config with values updated from
				#    current config
				writecfg(module="apply-profiles",
						 options=("profile.load_on_login", "profile_loader"))

				# 5. Remove profile loader options from current config
				for name in defaults:
					if name.startswith("profile_loader"):
						setcfg(name, None)
	
	def profile_load_by_os_handler(self, event=None):
		if is_superuser():
			# Enable calibration management under Windows 7
			try:
				util_win.enable_calibration_management(self.profile_load_by_os.GetValue())
			except Exception, exception:
				safe_print("util_win.enable_calibration_management(True): %s" %
						   safe_unicode(exception))
			else:
				label = get_profile_load_on_login_label(
							self.profile_load_by_os.GetValue())
				self.profile_load_on_login.Label = label
				self.profile_load_on_login.ContainingSizer.Layout()

	def install_cal(self, capture_output=False, cal=None, profile_path=None,
					skip_scripts=False, silent=False, title=appname):
		""" 'Install' (load) a calibration from a calibration file or
		profile """
		if config.is_virtual_display():
			return True
		# Install using dispwin
		cmd, args = self.worker.prepare_dispwin(cal, profile_path, False)
		if not isinstance(cmd, Exception):
			result = self.worker.exec_cmd(cmd, args, capture_output, 
										  low_contrast=False, 
										  skip_scripts=skip_scripts, 
										  silent=silent,
										  title=title)
		else:
			result = cmd
		if not isinstance(result, Exception) and result:
			if not silent:
				if cal is False:
					InfoDialog(self, 
							   msg=lang.getstr("calibration.reset_success"), 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-information"),
							   log=False)
				else:
					InfoDialog(self, 
							   msg=lang.getstr("calibration.load_success"), 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-information"),
							   log=False)
		elif not silent:
			if isinstance(result, Exception) and getcfg("dry_run"):
				show_result_dialog(result, self)
				return
			if cal is False:
				InfoDialog(self, 
						   msg=lang.getstr("calibration.reset_error"), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"), log=False)
			else:
				InfoDialog(self, msg=lang.getstr("calibration.load_error"), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"), log=False)
		return result
	
	def update_measurement_report(self, event=None):
		""" Show file dialog to select a HTML measurement report
		for updating. Update the selected report and show it afterwards. """
		defaultDir, defaultFile = get_verified_path("last_filedialog_path")
		dlg = wx.FileDialog(self, lang.getstr("measurement_report.update"), 
							defaultDir=defaultDir, defaultFile=defaultFile, 
							wildcard=lang.getstr("filetype.html") + "|*.html;*.htm", 
							style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
		dlg.Center(wx.BOTH)
		result = dlg.ShowModal()
		if result == wx.ID_OK:
			path = dlg.GetPath()
			setcfg("last_filedialog_path", path)
		dlg.Destroy()
		if result != wx.ID_OK:
			return
		try:
			report.update(path, pack=getcfg("report.pack_js"))
		except (IOError, OSError), exception:
			show_result_dialog(exception)
		else:
			# show report
			wx.CallAfter(launch_file, path)

	def verify_calibration_handler(self, event):
		if check_set_argyll_bin():
			self.setup_measurement(self.verify_calibration)

	def verify_calibration(self):
		if self.measure_auto(self.verify_calibration):
			return
		safe_print("-" * 80)
		progress_msg = lang.getstr("calibration.verify")
		safe_print(progress_msg)
		self.worker.interactive = False
		self.worker.start(self.result_consumer, self.worker.verify_calibration, 
						  progress_msg=progress_msg, pauseable=True,
						  resume=bool(getattr(self, "measure_auto_after",
											  None)))
	
	def select_profile(self, parent=None, title=appname, msg=None,
					   check_profile_class=True, ignore_current_profile=False,
					   prefer_current_profile=False):
		"""
		Selects the currently configured profile or display profile. Falls
		back to user choice via FileDialog if both not set.
		
		"""
		if not parent:
			parent = self
		if not msg:
			msg = lang.getstr("profile.choose")
		if ignore_current_profile:
			profile = None
		else:
			profile = get_current_profile(include_display_profile=True)
			if profile and not prefer_current_profile:
				dlg = ConfirmDialog(self, title=title, msg=msg,
									ok=lang.getstr("profile.current"),
									cancel=lang.getstr("cancel"),
									alt=lang.getstr("browse"),
									bitmap=geticon(32, appname + "-profile-info"))
				dlg.ok.SetDefault()
				result = dlg.ShowModal()
				if result == wx.ID_CANCEL:
					return
				elif result != wx.ID_OK:
					profile = None
		if not profile:
			defaultDir, defaultFile = get_verified_path("last_icc_path")
			dlg = wx.FileDialog(parent, msg, 
								defaultDir=defaultDir, defaultFile=defaultFile, 
								wildcard=lang.getstr("filetype.icc") + "|*.icc;*.icm", 
								style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
			dlg.Center(wx.BOTH)
			result = dlg.ShowModal()
			if result == wx.ID_OK:
				path = dlg.GetPath()
				setcfg("last_icc_path", path)
				setcfg("last_cal_or_icc_path", path)
			dlg.Destroy()
			if result != wx.ID_OK:
				return
			try:
				profile = ICCP.ICCProfile(path)
			except (IOError, ICCP.ICCProfileInvalidError), exception:
				InfoDialog(parent, msg=lang.getstr("profile.invalid") + 
								 "\n" + path, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
			if check_profile_class and (profile.profileClass != "mntr" or
										profile.colorSpace != "RGB"):
				InfoDialog(parent, msg=lang.getstr("profile.unsupported", 
												   (profile.profileClass, 
													profile.colorSpace)) + 
								 "\n" + path, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
		return profile

	def measurement_report_create_handler(self, event):
		""" Assign and initialize the report creation window """
		if not getattr(self, "reportframe", None):
			self.init_reportframe()
		if self.reportframe.IsShownOnScreen():
			self.reportframe.Raise()
		else:
			self.reportframe.Show(not self.reportframe.IsShownOnScreen())

	def measurement_report_handler(self, event, path=None):
		if sys.platform == "darwin" or debug: self.focus_handler(event)
		if not check_set_argyll_bin():
			return
			
		sim_ti3 = None
		sim_gray = None
			
		# select measurement data (ti1 or ti3)
		chart = getcfg("measurement_report.chart")
		
		try:
			chart = CGATS.CGATS(chart, True)
		except (IOError, CGATS.CGATSError), exception:
			show_result_dialog(exception, getattr(self, "reportframe", self))
			return
		
		fields = getcfg("measurement_report.chart.fields")
		
		# profile(s)
		paths = []
		use_sim = getcfg("measurement_report.use_simulation_profile")
		use_sim_as_output = getcfg("measurement_report.use_simulation_profile_as_output")
		use_devlink = getcfg("measurement_report.use_devlink_profile")
		##if not use_sim or not use_sim_as_output:
			##paths.append(getcfg("measurement_report.output_profile"))
		if use_sim:
			if use_sim_as_output and use_devlink:
				paths.append(getcfg("measurement_report.devlink_profile"))
			paths.append(getcfg("measurement_report.simulation_profile"))
		sim_profile = None
		devlink = None
		oprof = profile = get_current_profile(True)
		for i, profilepath in enumerate(paths):
			try:
				profile = ICCP.ICCProfile(profilepath)
			except (IOError, ICCP.ICCProfileInvalidError), exception:
				InfoDialog(getattr(self, "reportframe", self),
						   msg=lang.getstr("profile.invalid") + 
								 "\n" + profilepath, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
			if i in (0, 1) and use_sim:
				if use_sim_as_output and profile.colorSpace == "RGB":
					if i == 0 and use_devlink:
						devlink = profile
				else:
					if profile.colorSpace != "RGB":
						devlink = None
					sim_profile = profile
					profile = oprof
		if not profile and not oprof:
			show_result_dialog(Error(lang.getstr("display_profile.not_detected",
												 config.get_display_name(None,
																		 True))),
							   getattr(self, "reportframe", self))
			return
		colormanaged = (use_sim and use_sim_as_output and not sim_profile and
						config.get_display_name(None, True) in ("madVR",
																"Prisma") and
						getcfg("3dlut.enable"))
		if debug:
			for n, p in {"profile": profile, "devlink": devlink,
						 "sim_profile": sim_profile, "oprof": oprof}.iteritems():
				if p:
					safe_print(n, p.getDescription())

		if use_sim:
			if sim_profile:
				mprof = sim_profile
			else:
				mprof = profile
		apply_map = (use_sim and
					 mprof.colorSpace == "RGB" and
					 isinstance(mprof.tags.get("rXYZ"), ICCP.XYZType) and
					 isinstance(mprof.tags.get("gXYZ"), ICCP.XYZType) and
					 isinstance(mprof.tags.get("bXYZ"), ICCP.XYZType))
		apply_off = (apply_map and
					 getcfg("measurement_report.apply_black_offset"))
		apply_trc = (apply_map and
					 getcfg("measurement_report.apply_trc"))
		bt1886 = None
		if apply_trc or apply_off:
			# TRC BT.1886-like, gamma with black offset, or just black offset
			try:
				odata = self.worker.xicclu(oprof, (0, 0, 0), pcs="x")
				if len(odata) != 1 or len(odata[0]) != 3:
					raise ValueError("Blackpoint is invalid: %s" % odata)
			except Exception, exception:
				show_result_dialog(exception, getattr(self, "reportframe", self))
				return
			XYZbp = odata[0]
			if apply_trc:
				# TRC BT.1886-like
				gamma = getcfg("measurement_report.trc_gamma")
				gamma_type = getcfg("measurement_report.trc_gamma_type")
				outoffset = getcfg("measurement_report.trc_output_offset")
				if gamma_type == "b":
					# Get technical gamma needed to achieve effective gamma
					gamma = colormath.xicc_tech_gamma(gamma, XYZbp[1], outoffset)
			else:
				# Just black offset
				outoffset = 1.0
				gamma = 0.0
				for channel in "rgb":
					gamma += mprof.tags[channel + "TRC"].get_gamma()
				gamma /= 3.0
			rXYZ = mprof.tags.rXYZ.values()
			gXYZ = mprof.tags.gXYZ.values()
			bXYZ = mprof.tags.bXYZ.values()
			mtx = colormath.Matrix3x3([[rXYZ[0], gXYZ[0], bXYZ[0]],
									   [rXYZ[1], gXYZ[1], bXYZ[1]],
									   [rXYZ[2], gXYZ[2], bXYZ[2]]])
			bt1886 = colormath.BT1886(mtx, XYZbp, outoffset, gamma, apply_trc)
			if apply_trc:
				# Make sure the profile has the expected Rec. 709 TRC
				# for BT.1886
				for i, channel in enumerate(("r", "g", "b")):
					if channel + "TRC" in mprof.tags:
						mprof.tags[channel + "TRC"].set_trc(-709)

		if sim_profile:
			sim_intent = ("a"
						  if getcfg("measurement_report.whitepoint.simulate")
						  else "r")
			void, sim_ti3, sim_gray = self.worker.chart_lookup(chart, 
													  sim_profile,
													  check_missing_fields=True, 
													  intent=sim_intent,
													  bt1886=bt1886)
			# NOTE: we ignore the ti1 and gray patches here
			# only the ti3 is valuable at this point
			if not sim_ti3:
				return
			intent = ("r"
					  if sim_intent == "r" or
					  getcfg("measurement_report.whitepoint.simulate.relative")
					  else "a")
			bt1886 = None
		else:
			sim_intent = None
			intent = "r"
			if fields in ("LAB", "XYZ"):
				if getcfg("measurement_report.whitepoint.simulate"):
					sim_intent = "a"
					if not getcfg("measurement_report.whitepoint.simulate.relative"):
						intent = "a"
				else:
					chart.fix_device_values_scaling()
					chart.adapt(cat=profile.guess_cat() or "Bradford")
		
		# lookup test patches
		ti1, ti3_ref, gray = self.worker.chart_lookup(sim_ti3 or chart, 
													  profile,
													  bool(sim_ti3) or
													  fields in ("LAB", "XYZ"),
													  fields=None
															 if bool(sim_ti3)
															 else fields,
													  intent=intent,
													  bt1886=bt1886)
		if not ti3_ref:
			return
		if not gray and sim_gray:
			gray = sim_gray
		
		if devlink:
			void, ti1, void = self.worker.chart_lookup(ti1, devlink,
													   check_missing_fields=True,
													   white_patches=1,
													   white_patches_total=False)
			if not ti1:
				return
		
		# let the user choose a location for the result
		defaultFile = u"Measurement Report %s — %s — %s" % (version_short,
			re.sub(r"[\\/:;*?\"<>|]+", "_",
			self.display_ctrl.GetStringSelection().replace(" " +
														   lang.getstr("display.primary"),
														   "")),
			strftime("%Y-%m-%d %H-%M.html"))
		if not path:
			defaultDir = get_verified_path(None, 
										   os.path.join(getcfg("profile.save_path"), 
										   defaultFile))[0]
			dlg = wx.FileDialog(getattr(self, "reportframe", self),
								lang.getstr("save_as"), 
								defaultDir, defaultFile, 
								wildcard=lang.getstr("filetype.html") + "|*.html;*.htm", 
								style=wx.SAVE | wx.FD_OVERWRITE_PROMPT)
			dlg.Center(wx.BOTH)
			result = dlg.ShowModal()
			if result == wx.ID_OK:
				path = dlg.GetPath()
				if not waccess(path, os.W_OK):
					show_result_dialog(Error(lang.getstr("error.access_denied.write",
														 path)),
									   getattr(self, "reportframe", self))
					return
			dlg.Destroy()
			if result != wx.ID_OK:
				return
		save_path = os.path.splitext(path)[0] + ".html"
		setcfg("last_filedialog_path", save_path)
		# check if file(s) already exist
		if os.path.exists(save_path):
				dlg = ConfirmDialog(
					getattr(self, "reportframe", self),
					msg=lang.getstr("dialog.confirm_overwrite", save_path), 
					ok=lang.getstr("overwrite"), 
					cancel=lang.getstr("cancel"), 
					bitmap=geticon(32, "dialog-warning"))
				result = dlg.ShowModal()
				dlg.Destroy()
				if result != wx.ID_OK:
					return
		
		# setup for measurement
		self.setup_measurement(self.measurement_report, ti1, oprof, profile,
							   sim_profile, intent, sim_intent, devlink,
							   ti3_ref, sim_ti3, save_path, chart, gray,
							   apply_trc, colormanaged, use_sim_as_output)

	def measurement_report(self, ti1, oprof, profile, sim_profile, intent,
						   sim_intent, devlink, ti3_ref, sim_ti3, save_path,
						   chart, gray, apply_trc, colormanaged,
						   use_sim_as_output):
		safe_print("-" * 80)
		progress_msg = lang.getstr("measurement_report")
		safe_print(progress_msg)
		
		# setup temp dir
		temp = self.worker.create_tempdir()
		if isinstance(temp, Exception):
			show_result_dialog(temp, getattr(self, "reportframe", self))
			return
		
		# filenames
		name, ext = os.path.splitext(os.path.basename(save_path))
		ti1_path = os.path.join(temp, name + ".ti1")
		profile_path = os.path.join(temp, name + ".icc")
		
		# write ti1 to temp dir
		try:
			ti1_file = open(ti1_path, "w")
		except EnvironmentError, exception:
			InfoDialog(getattr(self, "reportframe", self),
					   msg=lang.getstr("error.file.create", ti1_path), 
					   ok=lang.getstr("ok"), 
					   bitmap=geticon(32, "dialog-error"))
			self.worker.wrapup(False)
			return
		ti1_file.write(str(ti1))
		ti1_file.close()
		
		# write profile to temp dir
		profile.write(profile_path)
		# Check if we need to apply calibration
		if (not use_sim_as_output or
			(devlink and not "-a" in parse_argument_string(
				devlink.tags.get("meta", {}).get("collink.args", {}).get("value",
					"-a" if getcfg("3dlut.output.profile.apply_cal") else "")))):
			calprof = oprof
		else:
			calprof = profile
		if isinstance(calprof.tags.get("vcgt"), ICCP.VideoCardGammaType):
			# Extract calibration from profile
			try:
				cgats = vcgt_to_cal(calprof)
			except (IOError, CGATS.CGATSInvalidError, 
					CGATS.CGATSInvalidOperationError, CGATS.CGATSKeyError, 
					CGATS.CGATSTypeError, CGATS.CGATSValueError), exception:
				wx.CallAfter(show_result_dialog,
							 Error(lang.getstr("cal_extraction_failed")),
							 getattr(self, "reportframe", self))
				self.Show()
				return
			cal_path = os.path.join(temp, name + ".cal")
			cgats.write(cal_path)
		else:
			# Use linear calibration
			cal_path = get_data_path("linear.cal")
		
		# start readings
		self.worker.dispread_after_dispcal = False
		self.worker.interactive = config.get_display_name() == "Untethered"
		self.worker.start(self.measurement_report_consumer, 
						  self.worker.measure_ti1, 
						  cargs=(os.path.splitext(ti1_path)[0] + ".ti3", 
								 profile, sim_profile, intent, sim_intent,
								 devlink, ti3_ref, sim_ti3, save_path, chart,
								 gray, apply_trc),
						  wargs=(ti1_path, cal_path, colormanaged),
						  progress_msg=progress_msg, pauseable=True)
	
	def measurement_report_consumer(self, result, ti3_path, profile, sim_profile,
									intent, sim_intent, devlink, ti3_ref,
									sim_ti3, save_path, chart, gray,
									apply_trc):
		
		self.Show()
		
		if not isinstance(result, Exception) and result:
			# get item 0 of the ti3 to strip the CAL part from the measured data
			try:
				ti3_measured = CGATS.CGATS(ti3_path)[0]
			except (IOError, CGATS.CGATSInvalidError, 
					CGATS.CGATSInvalidOperationError, CGATS.CGATSKeyError, 
					CGATS.CGATSTypeError, CGATS.CGATSValueError), exc:
				result = exc
			else:
				safe_print(lang.getstr("success"))
				result = self.measurement_file_check_confirm(ti3_measured)
		
		# cleanup
		self.worker.wrapup(False if not isinstance(result, Exception)
						   else result)
		
		if isinstance(result, Exception) or not result:
			if isinstance(result, Exception):
				wx.CallAfter(show_result_dialog, result,
							 getattr(self, "reportframe", self))
			return
		
		# Account for additional white patches
		white_rgb = {'RGB_R': 100, 'RGB_G': 100, 'RGB_B': 100}
		white_ref = ti3_ref.queryi(white_rgb)
		if devlink:
			# Remove additional white patch (device white = 100 before
			# accounting for effect of devicelink)
			# This is always the first patch ONLY
			ti3_measured.DATA.remove(0)
			# The new offset is the difference in length between measured and
			# ref because the white patch is always added at the start
			offset = len(ti3_measured.DATA) - len(ti3_ref.DATA)
			# Set full white RGB to 100
			for i in xrange(offset):
				for label in ("RGB_R", "RGB_G", "RGB_B"):
					ti3_measured.DATA[i][label] = 100.0
			# Restore original device values
			for i in ti3_ref.DATA:
				for label in ("RGB_R", "RGB_G", "RGB_B"):
					ti3_measured.DATA[i + offset][label] = ti3_ref.DATA[i][label]
			# White patches (device white = 100 after accounting for effect of
			# devicelink)
			white_measured = ti3_measured.queryi(white_rgb)
			# Update white cd/m2
			luminance = float(ti3_measured.LUMINANCE_XYZ_CDM2.split()[1])
			white_XYZ_cdm2 = [0, 0, 0]
			for i, label in enumerate(("XYZ_X", "XYZ_Y", "XYZ_Z")):
				white_XYZ_cdm2[i] = white_measured[0][label] * luminance / 100.0
			ti3_measured.LUMINANCE_XYZ_CDM2 = "%.6f %.6f %.6f" % tuple(white_XYZ_cdm2)
			# Scale to actual white Y after accounting for effect of devicelink
			scale = 100.0 / white_measured[0]["XYZ_Y"]
			for i in ti3_measured.DATA:
				for label in ("XYZ_X", "XYZ_Y", "XYZ_Z"):
					ti3_measured.DATA[i][label] *= scale
		else:
			white_measured = ti3_measured.queryi(white_rgb)
			offset = max(len(white_measured) - len(white_ref), 0)

		# If patches were removed from the measured TI3, we need to remove them
		# from reference and simulation TI3
		if isinstance(result, tuple):
			ref_removed = []
			sim_removed = []
			for item in reversed(result[0]):
				key = item.key - offset
				ref_removed.insert(0, ti3_ref.DATA.pop(key))
				if sim_ti3:
					sim_removed.insert(0, sim_ti3.DATA.pop(key))
			for item in ref_removed:
				safe_print("Removed patch #%i from reference TI3: %s" %
						   (item.key, item))
			for item in sim_removed:
				safe_print("Removed patch #%i from simulation TI3: %s" %
						   (item.key, item))
			# Update offset
			white_ref = ti3_ref.queryi(white_rgb)
			offset = max(len(white_measured) - len(white_ref), 0)
		
		# Determine if we should use planckian locus for assumed target wp
		# Detection will only work for profiles created by DisplayCAL
		planckian = False
		if (profile.tags.get("CIED", "") or 
			profile.tags.get("targ", ""))[0:4] == "CTI3":
			options_dispcal = get_options_from_profile(profile)[0]
			for option in options_dispcal:
				if option.startswith("T"):
					planckian = True
					break
		
		# calculate amount of calibration grayscale tone values
		cal_entrycount = 256
		if isinstance(profile.tags.get("vcgt"), ICCP.VideoCardGammaType):
			rgb = [[], [], []]
			vcgt = profile.tags.vcgt
			if "data" in vcgt:
				# table
				cal_entrycount = vcgt['entryCount']
				for i in range(0, cal_entrycount):
					for j in range(0, 3):
						rgb[j].append(float(vcgt['data'][j][i]) / (math.pow(256, vcgt['entrySize']) - 1) * 255)
			else:
				# formula
				step = 100.0 / 255.0
				for i in range(0, cal_entrycount):
					# float2dec(v) fixes miniscule deviations in the calculated gamma
					for j, name in enumerate(("red", "green", "blue")):
						vmin = float2dec(vcgt[name + "Min"] * 255)
						v = float2dec(math.pow(step * i / 100.0, vcgt[name + "Gamma"]))
						vmax = float2dec(vcgt[name + "Max"] * 255)
						rgb[j].append(float2dec(vmin + v * (vmax - vmin), 8))
			cal_rgblevels = [len(set(round(n) for n in channel)) for channel in rgb]
		else:
			# Assume linear with all steps
			cal_rgblevels = [256, 256, 256]
		
		if not chart.filename.lower().endswith(".ti1") or sim_ti3:
			# make the device values match
			for i in ti3_ref.DATA:
				for color in ("RGB_R", "RGB_G", "RGB_B"):
					if sim_ti3 and sim_ti3.DATA[i].get(color) is not None:
						ti3_ref.DATA[i][color] = sim_ti3.DATA[i][color]
					else:
						ti3_ref.DATA[i][color] = ti3_measured.DATA[i + offset][color]
		
		cat = "Bradford"
		
		# create a 'joined' ti3 from ref ti3, with XYZ values from measured ti3
		# this makes sure CMYK data in the original ref will be present in
		# the newly joined ti3
		ti3_joined = CGATS.CGATS(str(ti3_ref))[0]
		ti3_joined.LUMINANCE_XYZ_CDM2 = ti3_measured.LUMINANCE_XYZ_CDM2
		# add XYZ to DATA_FORMAT if not yet present
		labels_xyz = ("XYZ_X", "XYZ_Y", "XYZ_Z")
		if not "XYZ_X" in ti3_joined.DATA_FORMAT.values() and \
		   not "XYZ_Y" in ti3_joined.DATA_FORMAT.values() and \
		   not "XYZ_Z" in ti3_joined.DATA_FORMAT.values():
			ti3_joined.DATA_FORMAT.add_data(labels_xyz)
		# set XYZ in joined ti3 to XYZ of measurements
		for i in ti3_joined.DATA:
			for color in labels_xyz:
				ti3_joined.DATA[i][color] = ti3_measured.DATA[i + offset][color]
		
		wtpt_profile_norm = tuple(n * 100 for n in profile.tags.wtpt.values())
		if isinstance(profile.tags.get("chad"), ICCP.chromaticAdaptionTag):
			# undo chromatic adaption of profile whitepoint
			WX, WY, WZ = profile.tags.chad.inverted() * wtpt_profile_norm
			wtpt_profile_norm = tuple((n / WY) * 100.0 for n in (WX, WY, WZ))
			# guess chromatic adaption transform (Bradford, CAT02...)
			cat = profile.guess_cat() or cat
		elif isinstance(profile.tags.get("arts"), ICCP.chromaticAdaptionTag):
			cat = profile.guess_cat() or cat
		if "lumi" in profile.tags and isinstance(profile.tags.lumi,
												 ICCP.XYZType):
			# calculate unscaled whitepoint
			scale = profile.tags.lumi.Y / 100.0
			wtpt_profile = tuple(n * scale for n in wtpt_profile_norm)
		else:
			wtpt_profile = wtpt_profile_norm
		
		if sim_profile:
			wtpt_sim_profile_norm = tuple(n * 100 for n in sim_profile.tags.wtpt.values())
			if "chad" in sim_profile.tags:
				# undo chromatic adaption of profile whitepoint
				WX, WY, WZ = sim_profile.tags.chad.inverted() * wtpt_sim_profile_norm
				wtpt_sim_profile_norm = tuple((n / WY) * 100.0 for n in (WX, WY, WZ))
		
		wtpt_measured = tuple(float(n) for n in ti3_joined.LUMINANCE_XYZ_CDM2.split())
		# normalize so that Y = 100
		wtpt_measured_norm = tuple((n / wtpt_measured[1]) * 100 for n in wtpt_measured)
		
		if intent != "a" and sim_intent != "a":
			white = ti3_joined.queryi(white_rgb)
			for i in white:
				white[i].update({'XYZ_X': wtpt_measured_norm[0], 
								 'XYZ_Y': wtpt_measured_norm[1], 
								 'XYZ_Z': wtpt_measured_norm[2]})
		
		black = ti3_joined.queryi1({'RGB_R': 0, 'RGB_G': 0, 'RGB_B': 0})
		if black:
			bkpt_measured_norm = black["XYZ_X"], black["XYZ_Y"], black["XYZ_Z"]
			bkpt_measured = tuple(wtpt_measured[1] / 100 * n for n in bkpt_measured_norm)
		else:
			bkpt_measured_norm = None
			bkpt_measured = None
		
		# set Lab values
		labels_Lab = ("LAB_L", "LAB_A", "LAB_B")
		for data in (ti3_ref, ti3_joined):
			if "XYZ_X" in data.DATA_FORMAT.values() and \
			   "XYZ_Y" in data.DATA_FORMAT.values() and \
			   "XYZ_Z" in data.DATA_FORMAT.values():
				if not "LAB_L" in data.DATA_FORMAT.values() and \
				   not "LAB_A" in data.DATA_FORMAT.values() and \
				   not "LAB_B" in data.DATA_FORMAT.values():
					# add Lab fields to DATA_FORMAT if not present
					data.DATA_FORMAT.add_data(labels_Lab)
					has_Lab = False
				else:
					has_Lab = True
				if data is ti3_joined or not has_Lab:
					for i in data.DATA:
						X, Y, Z = [data.DATA[i][color] for color in labels_xyz]
						if data is ti3_joined:
							# we need to adapt the measured values to D50
							#print X, Y, Z, '->',
							X, Y, Z = colormath.adapt(X, Y, Z, 
													  wtpt_measured_norm, 
													  cat=cat)
							#print X, Y, Z
						Lab = XYZ2Lab(X, Y, Z)
						for j, color in enumerate(labels_Lab):
							data.DATA[i][color] = Lab[j]
			if data is ti3_ref and sim_intent == "a" and intent == "a":
				for i in data.DATA:
					# we need to adapt the reference values to D50
					L, a, b = [data.DATA[i][color] for color in labels_Lab]
					X, Y, Z = colormath.Lab2XYZ(L, a, b, scale=100)
					#print X, Y, Z, '->',
					X, Y, Z = colormath.adapt(X, Y, Z,
											  wtpt_profile_norm,
											  cat=cat)
					#print X, Y, Z
					Lab = XYZ2Lab(X, Y, Z)
					for j, color in enumerate(labels_Lab):
						data.DATA[i][color] = Lab[j]
		
		# gather data for report
		
		instrument = self.comport_ctrl.GetStringSelection()
		measurement_mode = self.measurement_mode_ctrl.GetStringSelection()
		instrument += u" \u2014 " + measurement_mode
		
		observer = get_cfg_option_from_args("observer", "-Q",
											self.worker.options_dispread)
		if observer != defaults["observer"]:
			instrument += u" \u2014 " + self.observers_ab.get(observer, observer)
		
		ccmx = "None"
		reference_observer = None
		if self.worker.instrument_can_use_ccxx():
			ccmx = getcfg("colorimeter_correction_matrix_file").split(":", 1)
			if len(ccmx) > 1 and ccmx[1]:
				ccmxpath = ccmx[1]
				ccmx = os.path.basename(ccmx[1])
				try:
					cgats = CGATS.CGATS(ccmxpath)
				except (IOError, CGATS.CGATSError), exception:
					safe_print("%s:" % ccmxpath, exception)
				else:
					desc = safe_unicode(cgats.get_descriptor(), "UTF-8")
					# If the description is not the same as the 'sane'
					# filename, add the filename after the description
					# (max 31 chars)
					# See also colorimeter_correction_check_overwite, the
					# way the filename is processed must be the same
					if (re.sub(r"[\\/:;*?\"<>|]+", "_",
							   make_argyll_compatible_path(desc)) !=
						os.path.splitext(ccmx)[0]):
						ccmx = "%s &amp;lt;%s&amp;gt;" % (desc, ellipsis(ccmx,
																		 31,
																		 "m"))
					if cgats.get(0, cgats).type == "CCMX":
						reference_observer = cgats.queryv1("REFERENCE_OBSERVER")
						if (reference_observer and
							reference_observer != defaults["observer"]):
							reference_observer = self.observers_ab.get(reference_observer,
																	   reference_observer)
							if not reference_observer.lower() in ccmx.lower():
								ccmx += u" \u2014 " + reference_observer
			else:
				ccmx = "None"
		
		use_sim = getcfg("measurement_report.use_simulation_profile")
		use_sim_as_output = getcfg("measurement_report.use_simulation_profile_as_output")
		if not sim_profile and use_sim and use_sim_as_output:
			sim_profile = profile
		
		if (getcfg("measurement_report.trc_gamma") != 2.4 or
			getcfg("measurement_report.trc_gamma_type") != "B" or
			getcfg("measurement_report.trc_output_offset")):
			trc = ''
		else:
			trc = "BT.1886"

		placeholders2data = {"${PLANCKIAN}": 'checked="checked"' if planckian 
											 else "",
							 "${DISPLAY}": self.display_ctrl.GetStringSelection().replace(" " +
																						  lang.getstr("display.primary"),
																						  ""),
							 "${INSTRUMENT}": instrument,
							 "${CORRECTION_MATRIX}": ccmx,
							 "${BLACKPOINT}": "%f %f %f" % (bkpt_measured if
											  bkpt_measured else (-1, ) * 3),
							 "${WHITEPOINT}": "%f %f %f" % wtpt_measured,
							 "${WHITEPOINT_NORMALIZED}": "%f %f %f" % 
														 wtpt_measured_norm,
							 "${PROFILE}": profile.getDescription(),
							 "${PROFILE_WHITEPOINT}": "%f %f %f" % wtpt_profile,
							 "${PROFILE_WHITEPOINT_NORMALIZED}": "%f %f %f" % 
																 wtpt_profile_norm,
							 "${SIMULATION_PROFILE}": sim_profile.getDescription() if sim_profile else '',
							 "${TRC_GAMMA}": str(getcfg("measurement_report.trc_gamma")
												 if apply_trc else 'null'),
							 "${TRC_GAMMA_TYPE}": str(getcfg("measurement_report.trc_gamma_type")
													  if apply_trc else ''),
							 "${TRC_OUTPUT_OFFSET}": str(getcfg("measurement_report.trc_output_offset")
														 if apply_trc else 0),
							 "${TRC}": trc if apply_trc else '',
							 "${WHITEPOINT_SIMULATION}": str(sim_intent == "a").lower(),
							 "${WHITEPOINT_SIMULATION_RELATIVE}": str(sim_intent == "a" and
																	  intent == "r").lower(),
							 "${DEVICELINK_PROFILE}": devlink.getDescription() if devlink else '',
							 "${TESTCHART}": os.path.basename(chart.filename),
							 "${ADAPTION}": str(profile.guess_cat(False) or cat),
							 "${DATETIME}": strftime("%Y-%m-%d %H:%M:%S"),
							 "${REF}":  str(ti3_ref).decode(enc, 
															"replace").replace('"', 
																			   "&quot;"),
							 "${MEASURED}": str(ti3_joined).decode(enc, 
																   "replace").replace('"', 
																					  "&quot;"),
							 "${CAL_ENTRYCOUNT}": str(cal_entrycount),
							 "${CAL_RGBLEVELS}": repr(cal_rgblevels),
							 "${GRAYSCALE}": repr(gray) if gray else 'null',
							 "${REPORT_VERSION}": version_short}
		
		# create report
		try:
			report.create(save_path, placeholders2data, getcfg("report.pack_js"))
		except (IOError, OSError), exception:
			show_result_dialog(exception, self)
		else:
			# show report
			wx.CallAfter(launch_file, save_path)

	def load_cal(self, cal=None, silent=False):
		""" Load a calibration from a .cal file or ICC profile. Defaults
		to currently configured file if cal parameter is not given. """
		load_vcgt = getcfg("calibration.autoload") or cal
		if not cal:
			cal = getcfg("calibration.file", False)
		if cal:
			if check_set_argyll_bin():
				if verbose >= 1 and load_vcgt:
					safe_print(lang.getstr("calibration.loading"))
					safe_print(cal)
				if not load_vcgt or \
					self.install_cal(capture_output=True, cal=cal, 
									skip_scripts=True, silent=silent,
									title=lang.getstr("calibration.load_from_cal_or_profile")) is True:
					if (cal.lower().endswith(".icc") or 
						cal.lower().endswith(".icm")):
						try:
							profile = ICCP.ICCProfile(cal)
						except (IOError, ICCP.ICCProfileInvalidError), exception:
							safe_print(exception)
							profile = None
					else:
						profile = cal_to_fake_profile(cal)
					self.lut_viewer_load_lut(profile=profile)
					if verbose >= 1 and silent and load_vcgt:
						safe_print(lang.getstr("success"))
					return True
				if verbose >= 1 and load_vcgt:
					safe_print(lang.getstr("failure"))
		return False

	def reset_cal(self, event=None):
		""" Reset video card gamma table to linear """
		if check_set_argyll_bin():
			if verbose >= 1:
				safe_print(lang.getstr("calibration.resetting"))
			if self.install_cal(capture_output=True, cal=False, 
								skip_scripts=True, silent=not (getcfg("dry_run") and event),
								title=lang.getstr("calibration.reset")) is True:
				profile = ICCP.ICCProfile()
				profile._data = "\0" * 128
				profile._tags.desc = ICCP.TextDescriptionType("", "desc")
				profile._tags.vcgt = ICCP.VideoCardGammaTableType("", "vcgt")
				profile._tags.vcgt.update({
					"channels": 3,
					"entryCount": 256,
					"entrySize": 1,
					"data": [range(0, 256), range(0, 256), range(0, 256)]
				})
				profile.size = len(profile.data)
				profile.is_loaded = True
				self.lut_viewer_load_lut(profile=profile)
				if verbose >= 1:
					safe_print(lang.getstr("success"))
				return True
			if verbose >= 1 and not getcfg("dry_run"):
				safe_print(lang.getstr("failure"))
		return False

	def load_display_profile_cal(self, event=None, lut_viewer_load_lut=True):
		""" Load calibration (vcgt) from current display profile """
		profile = get_display_profile()
		if check_set_argyll_bin():
			if verbose >= 1 and (getcfg("calibration.autoload") or event):
				safe_print(
					lang.getstr("calibration.loading_from_display_profile"))
				if profile and profile.fileName:
					safe_print(profile.fileName)
			if (not getcfg("calibration.autoload") and not event) or \
				self.install_cal(capture_output=True, cal=True, 
								skip_scripts=True, silent=not (getcfg("dry_run") and event),
								title=lang.getstr("calibration.load_from_display_profile")) is True:
				if lut_viewer_load_lut:
					self.lut_viewer_load_lut(profile=profile)
				if verbose >= 1 and (getcfg("calibration.autoload") or event):
					safe_print(lang.getstr("success"))
				return True
			if (verbose >= 1 and not getcfg("dry_run") and
				(getcfg("calibration.autoload") or event)):
				safe_print(lang.getstr("failure"))
		return False

	def report_calibrated_handler(self, event):
		""" Report on calibrated display and exit """
		self.setup_measurement(self.report)

	def report_uncalibrated_handler(self, event):
		""" Report on uncalibrated display and exit """
		self.setup_measurement(self.report, False)

	def report(self, report_calibrated=True):
		if check_set_argyll_bin():
			if self.measure_auto(self.report, report_calibrated):
				return
			safe_print("-" * 80)
			if report_calibrated:
				progress_msg = lang.getstr("report.calibrated")
			else:
				progress_msg = lang.getstr("report.uncalibrated")
			safe_print(progress_msg)
			self.worker.interactive = False
			self.worker.start(self.result_consumer, self.worker.report, 
							  wkwargs={"report_calibrated": report_calibrated},
							  progress_msg=progress_msg, pauseable=True,
							  resume=bool(getattr(self,
												  "measure_auto_after",
												  None)))
	
	def result_consumer(self, result):
		""" Generic result consumer. Shows the info window on success
		if enabled in the configuration or an info/warn/error dialog if
		result was an exception. """
		if isinstance(result, Exception) and result:
			wx.CallAfter(show_result_dialog, result, self)
		else:
			wx.CallAfter(self.infoframe_toggle_handler, show=True)
		self.worker.wrapup(False)
		self.Show()

	def calibrate_btn_handler(self, event):
		if sys.platform == "darwin" or debug: self.focus_handler(event)
		if (not isinstance(event, CustomEvent) and
			not getcfg("profile.update") and (not getcfg("calibration.update") or 
											  is_profile()) and getcfg("trc")):
			update_profile = getcfg("calibration.update") and is_profile()
			if update_profile:
				msg = lang.getstr("calibration.update_profile_choice")
				ok = lang.getstr("profile.update")
			else:
				msg = lang.getstr("calibration.create_fast_matrix_shaper_choice")
				ok = lang.getstr("calibration.create_fast_matrix_shaper")
			dlg = ConfirmDialog(self, 
								msg=msg,
								ok=ok, 
								alt=lang.getstr("button.calibrate"), 
								cancel=lang.getstr("cancel"), 
								bitmap=geticon(32, "dialog-question"))
			result = dlg.ShowModal()
			dlg.Destroy()
			if result == wx.ID_CANCEL:
				return
			if update_profile and result == wx.ID_OK:
				setcfg("profile.update", 1)
		else:
			result = None
		self.worker.dispcal_create_fast_matrix_shaper = result == wx.ID_OK
		if check_set_argyll_bin() and self.check_overwrite(".cal") and \
		   ((not getcfg("profile.update") and 
			 not self.worker.dispcal_create_fast_matrix_shaper) or 
			self.check_overwrite(profile_ext)):
			self.setup_measurement(self.just_calibrate)

	def just_calibrate(self):
		""" Just calibrate, optionally creating a fast matrix shaper profile """
		if self.measure_auto(self.just_calibrate):
			return
		safe_print("-" * 80)
		safe_print(lang.getstr("button.calibrate"))
		setcfg("calibration.continue_next", 0)
		if getcfg("calibration.interactive_display_adjustment") and \
		   not getcfg("calibration.update"):
			# Interactive adjustment, do not show progress dialog
			self.worker.interactive = True
		else:
			# No interactive adjustment, show progress dialog
			self.worker.interactive = False
		self.worker.start_calibration(self.just_calibrate_finish, remove=True,
									  progress_msg=lang.getstr("calibration"),
									  resume=bool(getattr(self,
														  "measure_auto_after",
														  None)))
	
	def just_calibrate_finish(self, result):
		start_timers = True
		if not isinstance(result, Exception) and result:
			wx.CallAfter(self.update_calibration_file_ctrl)
			if getcfg("log.autoshow"):
				wx.CallAfter(self.infoframe_toggle_handler, show=True)
			if getcfg("profile.update") or \
			   self.worker.dispcal_create_fast_matrix_shaper:
				start_timers = False
				wx.CallAfter(self.profile_finish, True, 
							 success_msg=lang.getstr("calibration.complete"),
							 install_3dlut=getcfg("3dlut.create"))
			elif getcfg("trc"):
				wx.CallAfter(self.load_cal, silent=True)
				wx.CallAfter(InfoDialog, self, 
							 msg=lang.getstr("calibration.complete"), 
							 ok=lang.getstr("ok"), 
							 bitmap=geticon(32, "dialog-information"))
		else:
			if isinstance(result, Exception):
				wx.CallAfter(show_result_dialog, result, self)
			elif not getcfg("dry_run"):
				wx.CallAfter(InfoDialog, self, 
							 msg=lang.getstr("calibration.incomplete"), 
							 ok=lang.getstr("ok"), 
							 bitmap=geticon(32, "dialog-error"))
		self.Show(start_timers=start_timers)

	def setup_measurement(self, pending_function, *pending_function_args, 
						  **pending_function_kwargs):
		if not self.setup_patterngenerator(self):
			return
		writecfg()
		if pending_function_kwargs.get("wrapup", True):
			self.worker.wrapup(False)
		if "wrapup" in pending_function_kwargs:
			del pending_function_kwargs["wrapup"]
		self.HideAll()
		self.set_pending_function(pending_function, *pending_function_args, 
								  **pending_function_kwargs)
		if ((config.is_virtual_display() and
			 config.get_display_name() not in ("Resolve", "Prisma") and
			 not config.get_display_name().startswith("Chromecast ") and
			 not config.get_display_name().startswith("Prisma ")) or
			getcfg("dry_run")):
			self.call_pending_function()
		elif sys.platform in ("darwin", "win32") or isexe:
			self.measureframe.Show()
		else:
			wx.CallAfter(self.start_measureframe_subprocess)

	def setup_patterngenerator(self, parent=None, title=appname, upload=False):
		retval = True
		if config.get_display_name(None, True) == "Prisma":
			# Ask for prisma hostname or IP
			dlg = ConfirmDialog(parent, title=title,
								msg=lang.getstr("patterngenerator.prisma.specify_host"),
								ok=lang.getstr("continue"),
								cancel=lang.getstr("cancel"),
								bitmap=geticon(32, "dialog-question"))
			host = getcfg("patterngenerator.prisma.host")
			dlg.host = wx.ComboBox(dlg, -1, host)
			def check_host_empty(event):
				dlg.ok.Enable(bool(dlg.host.GetValue()))
			dlg.host.Bind(wx.EVT_TEXT, check_host_empty)
			dlg.host.Bind(wx.EVT_COMBOBOX, check_host_empty)
			dlg.sizer3.Add(dlg.host, 0, flag=wx.TOP | wx.ALIGN_LEFT | wx.EXPAND,
						   border=12)
			dlg.errormsg = wx.StaticText(dlg, -1, "")
			dlg.sizer3.Add(dlg.errormsg, 0, flag=wx.TOP | wx.ALIGN_LEFT |
												 wx.EXPAND, border=6)
			if upload:
				# Show preset selection & filename
				sizer = wx.BoxSizer(wx.HORIZONTAL)
				dlg.sizer3.Add(sizer, 0, flag=wx.TOP | wx.ALIGN_LEFT | wx.EXPAND,
							   border=12)
				sizer.Add(wx.StaticText(dlg, -1,
										lang.getstr("3dlut.holder.assign_preset")),
						  flag=wx.ALIGN_CENTER_VERTICAL)
				preset = wx.Choice(dlg, -1, choices=config.valid_values["patterngenerator.prisma.preset"])
				preset.SetStringSelection(getcfg("patterngenerator.prisma.preset"))
				sizer.Add(preset, flag=wx.LEFT | wx.ALIGN_CENTER_VERTICAL,
						  border=8)
				# Filename
				basename = os.path.basename(getcfg("3dlut.input.profile"))
				name = os.path.splitext(basename)[0]
				# Shorten long name
				gamut = {"SMPTE_RP145_NTSC": "NTSC",
						 "EBU3213_PAL": "PAL",
						 "SMPTE431_P3": "P3"}.get(name, name)
				# Use file created date & time for filename
				filename = strftime("%%s-%Y%m%dT%H%M%S.3dl",
									localtime(os.stat(self.lut3d_path).st_ctime)) % gamut
				dlg.sizer3.Add(wx.StaticText(dlg, -1, "%s: %s" %
													  (lang.getstr("filename.upload"),
													   filename)),
							   flag=wx.TOP | wx.ALIGN_LEFT,
							   border=12)
			else:
				# Show levels selection
				dlg.tvlevels = wx.RadioButton(dlg, -1,
											  lang.getstr("3dlut.encoding.type_t"),
											  style=wx.RB_GROUP)
				dlg.sizer3.Add(dlg.tvlevels, 0, flag=wx.TOP | wx.ALIGN_LEFT,
							   border=12)
				dlg.pclevels = wx.RadioButton(dlg, -1,
											  lang.getstr("3dlut.encoding.type_n"))
				dlg.sizer3.Add(dlg.pclevels, 0, flag=wx.TOP | wx.ALIGN_LEFT,
							   border=4)
				if getcfg("patterngenerator.prisma.use_video_levels"):
					dlg.tvlevels.SetValue(True)
				else:
					dlg.pclevels.SetValue(True)
			dlg.sizer0.SetSizeHints(dlg)
			dlg.sizer0.Layout()
			def check_host(host):
				try:
					ip = socket.gethostbyname(host)
				except socket.error, exception:
					result = exception
				else:
					result = ip
				wx.CallAfter(check_host_consumer, result)
			def check_host_consumer(result):
				if not dlg:
					return
				if isinstance(result, Exception):
					dlg.Freeze()
					dlg.errormsg.Label = lang.getstr("host.invalid.lookup_failed")
					dlg.errormsg.ForegroundColour = wx.Colour(204, 0, 0)
					dlg.ok.Enable()
					dlg.Thaw()
					wx.Bell()
				else:
					dlg.EndModal(wx.ID_OK)
			def check_host_handler(event):
				host = dlg.host.GetValue()
				if host:
					dlg.Freeze()
					dlg.errormsg.Label = lang.getstr("please_wait")
					dlg.errormsg.ForegroundColour = wx.SystemSettings.GetColour(wx.SYS_COLOUR_WINDOWTEXT)
					dlg.ok.Disable()
					dlg.sizer0.SetSizeHints(dlg)
					dlg.sizer0.Layout()
					dlg.Thaw()
					thread = threading.Thread(target=check_host, args=(host, ))
					thread.start()
				else:
					wx.Bell()
			def add_client(addr_client):
				if not dlg:
					return
				name = addr_client[1]["name"]
				if sys.platform != "win32" and not name.endswith(".local"):
					name += ".local"
				dlg.host.Append(name)
				if not dlg.host.GetValue():
					dlg.host.SetSelection(0)
					check_host_empty(None)
			def discover():
				self.worker.patterngenerator.bind("on_client_added",
												  lambda addr_client:
												  wx.CallAfter(add_client,
															   addr_client))
				self.worker.patterngenerator.listen()
				self.worker.patterngenerator.announce()
			thread = threading.Thread(target=discover)
			dlg.ok.Bind(wx.EVT_BUTTON, check_host_handler)
			dlg.ok.Enable(bool(host))
			if self.worker.patterngenerator:
				self.worker.patterngenerator.disconnect_client()
			else:
				self.worker.setup_patterngenerator()
			wx.CallAfter(thread.start)
			result = dlg.ShowModal()
			self.worker.patterngenerator.listening = False
			host = dlg.host.GetValue()
			if result == wx.ID_OK:
				if upload:
					setcfg("patterngenerator.prisma.preset",
						   preset.GetStringSelection())
					retval = filename
				else:
					setcfg("patterngenerator.prisma.use_video_levels",
						   int(dlg.tvlevels.GetValue()))
			dlg.Destroy()
			if result != wx.ID_OK or not host:
				return
			setcfg("patterngenerator.prisma.host", host)
			self.worker.patterngenerator.host = host
		return retval
	
	def start_measureframe_subprocess(self):
		args = u'"%s" -c "%s"' % (exe, "import sys;"
									   "sys.path.insert(0, %r);"
									   "import wxMeasureFrame;"
									   "wxMeasureFrame.main();"
									   "sys.exit(wxMeasureFrame.MeasureFrame.exitcode)" %
									   pydir)
		if wx.Display.GetCount() == 1 and len(self.worker.display_rects) > 1:
			# Separate X screens, TwinView or similar
			display = wx.Display(0)
			geometry = display.Geometry
			union = wx.Rect()
			xy = []
			for rect in self.worker.display_rects:
				if rect[:2] in xy or rect[2:] == geometry[2:]:
					# Overlapping x y coordinates or screen filling whole
					# reported geometry, so assume separate X screens
					union = None
					break
				xy.append(rect[:2])
				union = union.Union(rect)
			if union == geometry:
				# Assume TwinView or similar where Argyll enumerates 1+n 
				# displays but wx only 'sees' one that is the union of them
				pass
			else:
				# Assume separate X screens
				try:
					x_hostname, x_display, x_screen = util_x.get_display()
				except ValueError, exception:
					InfoDialog(self, msg=safe_unicode(exception), 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					self.Show(start_timers=True)
					return
				args = "DISPLAY=%s:%s.%s %s" % (x_hostname, x_display,
												getcfg("display.number") - 1,
												args)
		delayedresult.startWorker(self.measureframe_consumer,
								  self.measureframe_subprocess, wargs=(args, ))

	def measureframe_subprocess(self, args):
		returncode = -1
		try:
			p = sp.Popen(args.encode(fs_enc), 
						 shell=True, 
						 stdin=sp.PIPE, stdout=sp.PIPE, stderr=sp.PIPE)
		except Exception, exception:
			stderr = safe_str(exception)
		else:
			self._measureframe_subprocess = p
			stdout, stderr = p.communicate()
			returncode = self._measureframe_subprocess.returncode
			del self._measureframe_subprocess
		return returncode, stderr

	def measureframe_consumer(self, delayedResult):
		returncode, stderr = delayedResult.get()
		if returncode != -1:
			config.initcfg()
			self.get_set_display()
		if returncode != 255:
			self.Show(start_timers=True)
			self.restore_measurement_mode()
			self.restore_testchart()
			if returncode != 0 and stderr and stderr.strip():
				InfoDialog(self, msg=safe_unicode(stderr.strip()), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
		else:
			self.call_pending_function()
	
	def get_set_display(self, update_ccmx_items=False):
		""" Get the currently configured display number, and set the
		display device selection """
		if debug:
			safe_print("[D] get_set_display")
		if self.worker.displays:
			self.display_ctrl.SetSelection(
				min(max(0, len(self.worker.displays) - 1), 
					max(0, getcfg("display.number") - 1)))
		self.display_ctrl_handler(
			CustomEvent(wx.EVT_CHOICE.evtType[0], 
						self.display_ctrl), load_lut=False,
						update_ccmx_items=update_ccmx_items)

	def get_ccxx_measurement_modes(self, instrument_name, swap=False):
		"""
		Get measurement modes suitable for colorimeter correction creation
		
		"""
		# IMPORTANT: Make changes aswell in the following locations:
		# - DisplayCAL.MainFrame.create_colorimeter_correction_handler
		# - DisplayCAL.MainFrame.set_ccxx_measurement_mode
		# - DisplayCAL.MainFrame.update_colorimeter_correction_matrix_ctrl_items
		# - worker.Worker.check_add_display_type_base_id
		# - worker.Worker.instrument_can_use_ccxx
		modes = {"ColorHug":
				 {"F": lang.getstr("measurement_mode.factory"),
				  "R": lang.getstr("measurement_mode.raw")},
				 "ColorHug2":
				 {"F": lang.getstr("measurement_mode.factory"),
				  "R": lang.getstr("measurement_mode.raw")},
				 "ColorMunki Smile":
				 {"f": lang.getstr("measurement_mode.lcd.ccfl")},
				 "Colorimtre HCFR":
				 {"R": lang.getstr("measurement_mode.raw")},
				 "K-10":
				 {"F": lang.getstr("measurement_mode.factory")}}.get(
					 instrument_name, {"c": lang.getstr("measurement_mode.refresh"),
									   "l": lang.getstr("measurement_mode.lcd")})
		if swap:
			modes = swap_dict_keys_values(modes)
		return modes

	def set_ccxx_measurement_mode(self):
		"""
		Set measurement mode suitable for colorimeter correction creation
		
		"""
		# IMPORTANT: Make changes aswell in the following locations:
		# - DisplayCAL.MainFrame.create_colorimeter_correction_handler
		# - DisplayCAL.MainFrame.get_ccxx_measurement_modes
		# - DisplayCAL.MainFrame.update_colorimeter_correction_matrix_ctrl_items
		# - worker.Worker.check_add_display_type_base_id
		# - worker.Worker.instrument_can_use_ccxx
		measurement_mode = None
		if getcfg("measurement_mode") == "auto":
			# Make changes in worker.Worker.add_instrument_features too!
			if self.worker.get_instrument_name() == "ColorHug":
				measurement_mode = "R"
			elif self.worker.get_instrument_name() == "ColorHug2":
				measurement_mode = "F"
			else:
				measurement_mode = "l"
		elif (self.worker.get_instrument_name() in ("ColorHug", "ColorHug2")
			and getcfg("measurement_mode") not in ("F", "R")):
			# Automatically set factory measurement mode if not already
			# factory or raw measurement mode
			measurement_mode = "F"
		elif (self.worker.get_instrument_name() == "ColorMunki Smile"
			and getcfg("measurement_mode") != "f"):
			# Automatically set LCD measurement mode if not already
			# LCD CCFL measurement mode
			measurement_mode = "f"
		elif (self.worker.get_instrument_name() == "Colorimtre HCFR"
			and getcfg("measurement_mode") != "R"):
			# Automatically set raw measurement mode if not already
			# raw measurement mode
			measurement_mode = "R"
		elif (self.worker.get_instrument_name() in ("Spyder4", "Spyder5")
			and getcfg("measurement_mode") not in ("l", "c")):
			# Automatically set LCD measurement mode if not already
			# LCD or refresh measurement mode
			measurement_mode = "l"
		if not getcfg("measurement_mode.backup", False):
			setcfg("measurement_mode.backup", getcfg("measurement_mode"))
		if measurement_mode:
			setcfg("measurement_mode", measurement_mode)
			self.update_measurement_mode()

	def set_pending_function(self, pending_function, *pending_function_args, 
							 **pending_function_kwargs):
		self.pending_function = pending_function
		self.pending_function_args = pending_function_args
		self.pending_function_kwargs = pending_function_kwargs

	def call_pending_function(self):
		# Needed for proper display updates under GNOME
		writecfg()
		if sys.platform in ("darwin", "win32") or isexe:
			self.measureframe.Hide()
		if debug:
			safe_print("[D] Calling pending function with args:", 
					   self.pending_function_args)
		wx.CallLater(100, self.pending_function, *self.pending_function_args, 
					 **self.pending_function_kwargs)
		self.pending_function = None

	def calibrate_and_profile_btn_handler(self, event):
		""" Setup calibration and characterization measurements """
		if sys.platform == "darwin" or debug: self.focus_handler(event)
		if check_set_argyll_bin() and self.check_overwrite(".cal") and \
		   self.check_overwrite(".ti3") and self.check_overwrite(profile_ext):
			self.setup_measurement(self.calibrate_and_profile)

	def calibrate_and_profile(self):
		""" Start calibration measurements """
		if self.measure_auto(self.calibrate_and_profile):
			return
		safe_print("-" * 80)
		safe_print(lang.getstr("button.calibrate_and_profile").replace("&&", 
																	   "&"))
		setcfg("calibration.continue_next", 1)
		self.worker.dispcal_create_fast_matrix_shaper = False
		self.worker.dispread_after_dispcal = True
		if getcfg("calibration.interactive_display_adjustment") and \
		   not getcfg("calibration.update"):
			# Interactive adjustment, do not show progress dialog
			self.worker.interactive = True
		else:
			# No interactive adjustment, show progress dialog
			self.worker.interactive = False
		self.worker.start_calibration(self.calibrate_finish,
									  progress_msg=lang.getstr("calibration"), 
									  continue_next=True,
									  resume=bool(getattr(self,
														  "measure_auto_after",
														  None)))
	
	def calibrate_finish(self, result):
		""" Start characterization measurements """
		self.worker.interactive = False
		if not isinstance(result, Exception) and result:
			wx.CallAfter(self.update_calibration_file_ctrl)
			if getcfg("trc"):
				cal = True
			else:
				cal = get_data_path("linear.cal")
			self.worker.start_measurement(self.calibrate_and_profile_finish,
										  apply_calibration=cal, 
										  progress_msg=lang.getstr("measuring.characterization"), 
										  resume=True, continue_next=True)
		else:
			if isinstance(result, Exception):
				wx.CallAfter(show_result_dialog, result, self)
			self.Show()
	
	def calibrate_and_profile_finish(self, result):
		""" Build profile from characterization measurements """
		start_timers = True
		if not isinstance(result, Exception) and result:
			result = self.check_copy_ti3()
		if not isinstance(result, Exception) and result:
			start_timers = False
			wx.CallAfter(self.start_profile_worker, 
						 lang.getstr("calibration_profiling.complete"), 
						 resume=True)
		else:
			if isinstance(result, Exception):
				wx.CallAfter(show_result_dialog, result, self)
			elif not getcfg("dry_run"):
				wx.CallAfter(InfoDialog, self, 
							 msg=lang.getstr("profiling.incomplete"), 
							 ok=lang.getstr("ok"), 
							 bitmap=geticon(32, "dialog-error"))
		self.Show(start_timers=start_timers)
	
	def check_copy_ti3(self):
		result = self.measurement_file_check_confirm(parent=getattr(self.worker, "progress_wnd", self))
		if isinstance(result, tuple):
			result = self.worker.wrapup(copy=True, remove=False,
										ext_filter=[".ti3"])
		if isinstance(result, Exception) or not result:
			self.worker.stop_progress()
		return result

	def start_profile_worker(self, success_msg, resume=False):
		name = getcfg("profile.name.expanded")
		path = os.path.join(getcfg("profile.save_path"), name, name + profile_ext)
		self.lut3d_set_path(path)
		continue_next = (getcfg("3dlut.create") and
						 not os.path.isfile(self.lut3d_path))
		self.worker.interactive = False
		self.worker.start(self.profile_finish, self.worker.create_profile, 
						  ckwargs={"success_msg": success_msg, 
								   "failure_msg": lang.getstr(
									   "profiling.incomplete"),
								   "install_3dlut": getcfg("3dlut.create")}, 
						  wkwargs={"tags": True},
						  progress_msg=lang.getstr("create_profile"), 
						  resume=resume, continue_next=continue_next)

	def gamap_btn_handler(self, event):
		if not hasattr(self, "gamapframe"):
			self.init_gamapframe()
		if self.gamapframe.IsShownOnScreen():
			self.gamapframe.Raise()
		else:
			self.gamapframe.Center()
			self.gamapframe.SetPosition((-1, self.GetPosition()[1] + 
											 self.GetSize()[1] - 
											 self.gamapframe.GetSize()[1] - 
											 100))
			self.gamapframe.Show(not self.gamapframe.IsShownOnScreen())
	
	def current_cal_choice(self, silent=False):
		""" Prompt user to either keep or clear the current calibration,
		with option to embed or not embed
		
		Return None if the current calibration should be embedded
		Return False if no calibration should be embedded
		Return filename if a .cal file should be used
		Return wx.ID_CANCEL if whole operation should be cancelled
		
		"""
		if config.is_uncalibratable_display():
			return False
		cal = getcfg("calibration.file", False)
		if cal:
			filename, ext = os.path.splitext(cal)
			if ext.lower() in (".icc", ".icm"):
				self.worker.options_dispcal = []
				try:
					profile = ICCP.ICCProfile(cal)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					InfoDialog(self, msg=lang.getstr("profile.invalid") + 
									 "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					self.update_profile_name_timer.Start(1000)
					return wx.ID_CANCEL
				else:
					# get dispcal options if present
					self.worker.options_dispcal = [
						"-" + arg for arg in 
						get_options_from_profile(profile)[0]]
			if os.path.isfile(filename + ".cal"):
				cal = filename + ".cal"
			else:
				cal = None
		if (self.worker.argyll_version < [1, 1, 0] or
			not self.worker.has_lut_access()):
			# If Argyll < 1.1, we cannot save the current VideoLUT to use it.
			# For web, there is no point in using the current VideoLUT as it
			# may not be from the display we render on (and we cannot save it
			# to begin with as there is no VideoLUT access).
			# So an existing .cal file or no calibration are the only options.
			can_use_current_cal = False
		else:
			can_use_current_cal = True
		if cal:
			msgstr = "dialog.cal_info"
			icon = "information"
		elif can_use_current_cal:
			msgstr = "dialog.current_cal_warning"
			icon = "warning"
		else:
			msgstr = "dialog.linear_cal_info"
			icon = "information"
		dlg = ConfirmDialog(self, 
							msg=lang.getstr(msgstr, os.path.basename(cal)
													if cal else None), 
							ok=lang.getstr("continue"), 
							cancel=lang.getstr("cancel"), 
							bitmap=geticon(32, "dialog-%s" % icon))
		border = 12
		if can_use_current_cal or cal:
			dlg.reset_cal_ctrl = wx.CheckBox(dlg, -1, 
									   lang.getstr("calibration.use_linear_instead"))
			dlg.sizer3.Add(dlg.reset_cal_ctrl, flag=wx.TOP | wx.ALIGN_LEFT, 
						   border=border)
			border = 4
		dlg.embed_cal_ctrl = wx.CheckBox(dlg, -1, 
								   lang.getstr("calibration.embed"))
		def embed_cal_ctrl_handler(event):
			embed_cal = dlg.embed_cal_ctrl.GetValue()
			dlg.reset_cal_ctrl.Enable(embed_cal)
			if not embed_cal:
				dlg.reset_cal_ctrl.SetValue(True)
		if can_use_current_cal or cal:
			dlg.embed_cal_ctrl.Bind(wx.EVT_CHECKBOX, embed_cal_ctrl_handler)
		dlg.embed_cal_ctrl.SetValue(bool(can_use_current_cal or cal))
		dlg.sizer3.Add(dlg.embed_cal_ctrl, flag=wx.TOP | wx.ALIGN_LEFT, 
					   border=border)
		dlg.sizer0.SetSizeHints(dlg)
		dlg.sizer0.Layout()
		if silent:
			result = wx.ID_OK
		else:
			result = dlg.ShowModal()
		if can_use_current_cal or cal:
			reset_cal = dlg.reset_cal_ctrl.GetValue()
		embed_cal = dlg.embed_cal_ctrl.GetValue()
		dlg.Destroy()
		if result == wx.ID_CANCEL:
			self.update_profile_name_timer.Start(1000)
			return wx.ID_CANCEL
		if not embed_cal:
			if can_use_current_cal and reset_cal:
				self.reset_cal()
			return False
		elif not (can_use_current_cal or cal) or reset_cal:
			return get_data_path("linear.cal")
		elif cal:
			return cal
	
	def restore_measurement_mode(self):
		if getcfg("measurement_mode.backup", False):
			setcfg("measurement_mode", getcfg("measurement_mode.backup"))
			setcfg("measurement_mode.backup", None)
			if getcfg("comport.number.backup", False):
				setcfg("comport.number", getcfg("comport.number.backup"))
				setcfg("comport.number.backup", None)
				self.update_comports()
			else:
				self.update_measurement_mode()
		if getcfg("observer.backup", False):
			setcfg("observer", getcfg("observer.backup"))
			setcfg("observer.backup", None)

	def restore_testchart(self):
		if getcfg("testchart.file.backup", False):
			self.set_testchart(getcfg("testchart.file.backup"))
			setcfg("testchart.file.backup", None)

	def measure_auto(self, measure_auto_after, *measure_auto_after_args):
		""" Automatically create a CCMX with EDID reference """
		if (getcfg("measurement_mode") == "auto" and
			not getattr(self, "measure_auto_after", None)):
			if not self.worker.get_display_edid():
				self.measure_auto_finish(Error("EDID not available"))
				return True
			self.measure_auto_after = measure_auto_after
			self.measure_auto_after_args = measure_auto_after_args
			if not is_ccxx_testchart():
				ccxx_testchart = get_ccxx_testchart()
				if not ccxx_testchart:
					self.measure_auto_finish(Error(lang.getstr("not_found",
															   lang.getstr("ccxx.ti1"))))
					return True
				setcfg("testchart.file.backup", getcfg("testchart.file"))
				self.set_testchart(ccxx_testchart)
			self.setup_ccxx_measurement()
			self.just_measure(get_data_path("linear.cal"),
							  self.measure_auto_finish)
			return True

	def measure_auto_finish(self, result):
		ti3_path = os.path.join(self.worker.tempdir or "",
								getcfg("profile.name.expanded") + ".ti3")
		self.restore_testchart()
		if isinstance(result, Exception) or not result:
			self.measure_auto_after = None
			if isinstance(result, Exception):
				wx.CallAfter(show_result_dialog, result, self)
			self.Show()
			self.worker.stop_progress()
		else:
			edid = self.worker.get_display_edid()
			defaultFile = edid.get("monitor_name",
								   edid.get("ascii",
											str(edid["product_id"]))) + profile_ext
			profile_path = os.path.join(self.worker.tempdir, defaultFile)
			profile = ICCP.ICCProfile.from_edid(edid)
			try:
				profile.write(profile_path)
			except Exception, exception:
				self.measure_auto_finish(exception)
				return
			luminance = None
			if self.worker.get_instrument_name() == "ColorHug":
				# Get the factory calibration so we can do luminance scaling
				# NOTE that this currently only works for the ColorHug,
				# NOT the ColorHug2! (but it's probably not needed for the
				# ColorHug2 anyway)
				for line in self.worker.output:
					if line.lower().startswith("serial number:"):
						serial = line.split(":", 1)[-1].strip()
						calibration = "calibration-%s.ti3" % serial
						path = os.path.join(config.get_argyll_data_dir(),
											calibration)
						if not os.path.isfile(path):
							safe_print("Retrieving factory calibration for "
									   "ColorHug", serial)
							url = ("https://raw.githubusercontent.com/hughski"
								   "/colorhug-calibration/master/data/" +
								   calibration)
							try:
								response = urllib2.urlopen(url)
							except Exception, exception:
								self.measure_auto_finish(exception)
								return
							body = response.read()
							response.close()
							if body.strip().startswith("CTI3"):
								safe_print("Successfully retrieved", url)
								try:
									with open(path, "wb") as calibrationfile:
										calibrationfile.write(body)
								except Exception, exception:
									safe_print(exception)
							else:
								safe_print("Got unexpected answer from %s:" %
										   url)
								safe_print(body)
						if os.path.isfile(path):
							safe_print("Using factory calibration", path)
							try:
								cgats = CGATS.CGATS(path)
							except (IOError, CGATS.CGATSError), exception:
								safe_print(exception)
							else:
								white = cgats.queryi1({"RGB_R": 1,
													   "RGB_G": 1,
													   "RGB_B": 1})
								if white:
									luminance = white["XYZ_Y"]
									safe_print("Using luminance %.2f from "
											   "factory calibration" %
											   luminance)
			if self.create_colorimeter_correction_handler(None, [profile_path,
																 ti3_path],
														  luminance=luminance):
				self.measure_auto_after(*self.measure_auto_after_args)
			else:
				self.Show()
				self.worker.stop_progress()
			self.measure_auto_after = None
	
	def measure_handler(self, event=None):
		self.setup_ccxx_measurement()
		if check_set_argyll_bin() and self.check_overwrite(".ti3"):
			if is_ccxx_testchart():
				# Use linear calibration for measuring CCXX testchart
				apply_calibration = get_data_path("linear.cal")
			else:
				apply_calibration = self.current_cal_choice()
			if apply_calibration != wx.ID_CANCEL:
				self.setup_measurement(self.just_measure, apply_calibration)
		else:
			self.restore_measurement_mode()
			self.restore_testchart()

	def profile_btn_handler(self, event):
		""" Setup characterization measurements """
		if sys.platform == "darwin" or debug: self.focus_handler(event)
		if check_set_argyll_bin() and self.check_overwrite(".ti3") and \
		   self.check_overwrite(profile_ext):
			apply_calibration = self.current_cal_choice(silent=isinstance(event, CustomEvent))
			if apply_calibration != wx.ID_CANCEL:
				self.setup_measurement(self.just_profile, apply_calibration)

	def setup_ccxx_measurement(self):
		if is_ccxx_testchart():
			# Allow different location to store measurements
			path = getcfg("profile.save_path")
			if not path:
				self.profile_save_path_btn_handler(None)
				path = getcfg("profile.save_path")
			if path:
				if not waccess(path, os.W_OK):
					show_result_dialog(Error(lang.getstr("error.access_denied.write",
														 path)), self)
					return
				setcfg("measurement.save_path", path)
				setcfg("measurement.name.expanded",
					   make_filename_safe("%s & %s %s" %
										  (self.worker.get_instrument_name(),
										   self.worker.get_display_name(),
										   strftime("%Y-%m-%d %H-%M-%S"))))
			else:
				return

	def just_measure(self, apply_calibration, consumer=None):
		if self.measure_auto(self.just_measure, apply_calibration):
			return
		safe_print("-" * 80)
		safe_print(lang.getstr("measure"))
		self.worker.dispread_after_dispcal = False
		self.worker.interactive = config.get_display_name() == "Untethered"
		setcfg("calibration.file.previous", None)
		continue_next = bool(consumer)
		resume = bool(getattr(self, "measure_auto_after", None))
		if not consumer:
			consumer = self.just_measure_finish
		self.worker.start_measurement(consumer, apply_calibration,
									  progress_msg=lang.getstr("measuring.characterization"), 
									  continue_next=continue_next,
									  resume=resume)
	
	def just_measure_finish(self, result):
		if not isinstance(result, Exception) and result:
			result = self.check_copy_ti3()
		self.worker.wrapup(copy=False, remove=True)
		if isinstance(result, Exception) or not result:
			if isinstance(result, Exception):
				wx.CallAfter(show_result_dialog, result, self)
		elif is_ccxx_testchart():
			try:
				cgats = CGATS.CGATS(os.path.join(getcfg("measurement.save_path"),
												 getcfg("measurement.name.expanded"),
												 getcfg("measurement.name.expanded")) + ".ti3")
			except Exception, exception:
				wx.CallAfter(show_result_dialog, exception, self)
			else:
				if cgats.queryv1("INSTRUMENT_TYPE_SPECTRAL") == "YES":
					setcfg("last_reference_ti3_path", cgats.filename)
				else:
					setcfg("last_colorimeter_ti3_path", cgats.filename)
				if getcfg("comport.number.backup", False):
					# Measurements were started from colorimeter correction
					# creation dialog
					paths = []
					if (getcfg("last_reference_ti3_path", False) and
						os.path.isfile(getcfg("last_reference_ti3_path")) and
						(getcfg("colorimeter_correction.type") == "spectral" or
						 (getcfg("last_colorimeter_ti3_path", False) and
						  os.path.isfile(getcfg("last_colorimeter_ti3_path")) and
						  self.worker.get_instrument_name() ==
						  getcfg("colorimeter_correction.instrument")))):
						paths.append(getcfg("last_reference_ti3_path"))
						if (self.worker.get_instrument_name() ==
							getcfg("colorimeter_correction.instrument")):
							paths.append(getcfg("last_colorimeter_ti3_path"))
					wx.CallAfter(self.create_colorimeter_correction_handler,
								 True, paths=paths)
		else:
			wx.CallAfter(self.just_measure_show_result, 
						 os.path.join(getcfg("profile.save_path"), 
									  getcfg("profile.name.expanded"), 
									  getcfg("profile.name.expanded") + 
									  ".ti3"))
		self.Show(start_timers=True)
		self.restore_measurement_mode()
		self.restore_testchart()
	
	def just_measure_show_result(self, path):
		dlg = ConfirmDialog(self, msg=lang.getstr("measurements.complete"), 
						    ok=lang.getstr("ok"), 
						    cancel=lang.getstr("cancel"), 
						    bitmap=geticon(32, "dialog-question"))
		if dlg.ShowModal() == wx.ID_OK:
			launch_file(os.path.dirname(path))
		dlg.Destroy()

	def just_profile(self, apply_calibration):
		""" Start characterization measurements """
		if self.measure_auto(self.just_profile, apply_calibration):
			return
		safe_print("-" * 80)
		safe_print(lang.getstr("button.profile"))
		self.worker.dispread_after_dispcal = False
		self.worker.interactive = config.get_display_name() == "Untethered"
		setcfg("calibration.file.previous", None)
		self.worker.start_measurement(self.just_profile_finish, apply_calibration,
									  progress_msg=lang.getstr("measuring.characterization"), 
									  continue_next=config.get_display_name() != "Untethered",
									  resume=bool(getattr(self,
														  "measure_auto_after",
														  None)))
	
	def just_profile_finish(self, result):
		""" Build profile from characterization measurements """
		start_timers = True
		if not isinstance(result, Exception) and result:
			result = self.check_copy_ti3()
		if not isinstance(result, Exception) and result:
			start_timers = False
			wx.CallAfter(self.start_profile_worker, 
						 lang.getstr("profiling.complete"), resume=True)
		else:
			if isinstance(result, Exception):
				wx.CallAfter(show_result_dialog, result, self)
			elif not getcfg("dry_run"):
				wx.CallAfter(InfoDialog, self, 
							 msg=lang.getstr("profiling.incomplete"), 
							 ok=lang.getstr("ok"), 
							 bitmap=geticon(32, "dialog-error"))
		self.Show(start_timers=start_timers)

	def profile_finish(self, result, profile_path=None, success_msg="", 
					   failure_msg="", preview=True, skip_scripts=False,
					   allow_show_log=True, install_3dlut=False):
		if not isinstance(result, Exception) and result:
			if getcfg("log.autoshow") and allow_show_log:
				self.infoframe_toggle_handler(show=True)
			self.install_3dlut = install_3dlut
			if profile_path:
				profile_save_path = os.path.splitext(profile_path)[0]
			else:
				profile_save_path = os.path.join(
										getcfg("profile.save_path"), 
										getcfg("profile.name.expanded"), 
										getcfg("profile.name.expanded"))
				profile_path = profile_save_path + profile_ext
			self.cal = profile_path
			profile = None
			filename, ext = os.path.splitext(profile_path)
			extra = []
			cinfo = []
			vinfo = []
			has_cal = False
			try:
				profile = ICCP.ICCProfile(profile_path)
			except (IOError, ICCP.ICCProfileInvalidError), exception:
				InfoDialog(self, msg=lang.getstr("profile.invalid") + 
									 "\n" + profile_path, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				self.start_timers(True)
				setcfg("calibration.file.previous", None)
				return
			else:
				has_cal = isinstance(profile.tags.get("vcgt"),
									 ICCP.VideoCardGammaType)
				if profile.profileClass != "mntr" or \
				   profile.colorSpace != "RGB":
					InfoDialog(self, msg=lang.getstr("profiling.complete"), 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-information"))
					self.start_timers(True)
					setcfg("calibration.file.previous", None)
					return
				if getcfg("calibration.file", False) != profile_path:
					# Load profile
					(options_dispcal, 
					 options_colprof) = get_options_from_profile(profile)
					if options_dispcal or options_colprof:
						cal = profile_save_path + ".cal"
						sel = self.calibration_file_ctrl.GetSelection()
						if options_dispcal and self.recent_cals[sel] == cal:
							self.recent_cals.remove(cal)
							self.calibration_file_ctrl.Delete(sel)
						if getcfg("settings.changed"):
							self.settings_discard_changes()
						if options_dispcal and options_colprof:
							self.load_cal_handler(None, path=profile_path, 
												  update_profile_name=False, 
												  silent=True,
												  load_vcgt=False)
						else:
							setcfg("calibration.file", profile_path)
							setcfg("3dlut.output.profile", profile_path)
							setcfg("measurement_report.output_profile", profile_path)
							self.update_controls(update_profile_name=False)
				# Get 3D LUT options
				self.lut3d_set_path()
				# Check if we want to automatically create 3D LUT
				if (install_3dlut and getcfg("3dlut.create") and
					not os.path.isfile(self.lut3d_path)):
					# Update curve viewer if shown
					self.lut_viewer_load_lut(profile=profile)
					# Create 3D LUT
					self.lut3d_create_handler(None)
					return
				elif hasattr(self.worker, "_disabler"):
					# This shouldn't happen
					self.worker.stop_progress()
				if "meta" in profile.tags:
					for key in ("avg", "max", "rms"):
						try:
							dE = float(profile.tags.meta.getvalue("ACCURACY_dE76_%s" % key))
						except (TypeError, ValueError):
							pass
						else:
							lstr = lang.getstr("profile.self_check") + ":"
							if not lstr in extra:
								extra.append(lstr)
							extra.append(u" %s %.2f" %
										 (lang.getstr("profile.self_check.%s" %
													  key), dE))
					gamuts = (("srgb", "sRGB", ICCP.GAMUT_VOLUME_SRGB),
							  ("adobe-rgb", "Adobe RGB", ICCP.GAMUT_VOLUME_ADOBERGB),
							  ("dci-p3", "DCI P3", ICCP.GAMUT_VOLUME_SMPTE431_P3))
					for key, name, volume in gamuts:
						try:
							gamut_coverage = float(profile.tags.meta.getvalue("GAMUT_coverage(%s)" % key))
						except (TypeError, ValueError):
							gamut_coverage = None
						if gamut_coverage:
							cinfo.append("%.1f%% %s" % (gamut_coverage * 100,
														name))
					try:
						gamut_volume = float(profile.tags.meta.getvalue("GAMUT_volume"))
					except (TypeError, ValueError):
						gamut_volume = None
					if gamut_volume:
						for key, name, volume in gamuts:
							vinfo.append("%.1f%% %s" %
										 (gamut_volume *
										  ICCP.GAMUT_VOLUME_SRGB /
										  volume * 100,
										  name))
							if len(vinfo) == len(cinfo):
								break
			if config.is_virtual_display() or install_3dlut:
				installable = False
				title = appname
				if self.lut3d_path and os.path.isfile(self.lut3d_path):
					# 3D LUT file already exists
					if (getcfg("3dlut.format") in ("madVR", "ReShade") or
						config.check_3dlut_format("Prisma")):
						ok = lang.getstr("3dlut.install")
					else:
						ok = lang.getstr("3dlut.save_as")
				else:
					ok = lang.getstr("3dlut.create")
				cancel = lang.getstr("cancel")
			else:
				# Check if profile is a LUT-type, and if yes, if LUT is of high
				# enough resolution (we assume anything >= 17 to be ok)
				if ("B2A0" in profile.tags and isinstance(profile.tags.B2A0,
														  ICCP.LUT16Type) and
					profile.tags.B2A0.clut_grid_steps < 17):
					# Nope. Not allowing to install. Offer to re-generate B2A
					# tables.
					dlg = ConfirmDialog(self,
										msg=lang.getstr("profile.b2a.lowres.warning"), 
								bitmap=geticon(32, "dialog-warning"))
					choice = dlg.ShowModal()
					if choice == wx.ID_OK:
						self.profile_hires_b2a_handler(None, profile)
					return
				installable = True
				title = lang.getstr("profile.install")
				ok = lang.getstr("profile.install")
				cancel = lang.getstr("profile.do_not_install")
			if not success_msg:
				if installable:
					success_msg = lang.getstr("dialog.install_profile", 
											  (os.path.basename(profile_path), 
											   self.display_ctrl.GetStringSelection()))
				else:
					success_msg = lang.getstr("profiling.complete")
			if extra:
				extra = ",".join(extra).replace(":,", ":").replace(",,", "\n")
				success_msg = "\n\n".join([success_msg, extra]).strip()
			# Always load calibration curves
			self.load_cal(cal=profile_path, silent=True)
			# Check profile metadata
			share_profile = None
			if not self.profile_share_get_meta_error(profile):
				share_profile = lang.getstr("profile.share")
			dlg = ConfirmDialog(self, msg=success_msg, 
								title=title,
								ok=ok, 
								cancel=cancel, 
								bitmap=geticon(32, appname + "-profile-info"),
								alt=share_profile)
			if cinfo or vinfo:
				gamut_info_sizer = wx.FlexGridSizer(2, 2, 0, 24)
				dlg.sizer3.Add(gamut_info_sizer, flag=wx.TOP, border=14)
				if cinfo:
					label = wx.StaticText(dlg, -1, lang.getstr("gamut.coverage"))
					font = label.GetFont()
					font.SetWeight(wx.BOLD)
					label.SetFont(font)
					gamut_info_sizer.Add(label)
				if vinfo:
					label = wx.StaticText(dlg, -1, lang.getstr("gamut.volume"))
					font = label.GetFont()
					font.SetWeight(wx.BOLD)
					label.SetFont(font)
				else:
					label = (1, 1)
				gamut_info_sizer.Add(label)
				if cinfo:
					gamut_info_sizer.Add(wx.StaticText(dlg, -1,
													   "\n".join(cinfo)))
				if vinfo:
					gamut_info_sizer.Add(wx.StaticText(dlg, -1,
													   "\n".join(vinfo)))
			self.modaldlg = dlg
			if share_profile:
				# Show share profile button
				dlg.Unbind(wx.EVT_BUTTON, dlg.alt)
				dlg.Bind(wx.EVT_BUTTON, self.profile_share_handler,
						 id=dlg.alt.GetId())
			if preview and has_cal and self.worker.calibration_loading_supported:
				# Show calibration preview checkbox
				self.preview = wx.CheckBox(dlg, -1, 
										   lang.getstr("calibration.preview"))
				self.preview.SetValue(True)
				dlg.Bind(wx.EVT_CHECKBOX, self.preview_handler, 
						 id=self.preview.GetId())
				dlg.sizer3.Add(self.preview, flag=wx.TOP | wx.ALIGN_LEFT, 
							   border=14)
				if LUTFrame and not ProfileInfoFrame:
					# Disabled, use profile information window instead
					self.show_lut = wx.CheckBox(dlg, -1, 
												lang.getstr(
													"calibration.show_lut"))
					dlg.Bind(wx.EVT_CHECKBOX, self.show_lut_handler, 
							 id=self.show_lut.GetId())
					dlg.sizer3.Add(self.show_lut, flag=wx.TOP | wx.ALIGN_LEFT, 
								   border=4)
					self.show_lut.SetValue(bool(getcfg("lut_viewer.show")))
					if not getattr(self, "lut_viewer", None):
						self.init_lut_viewer(profile=profile, 
											 show=getcfg("lut_viewer.show"))
			else:
				dlg.sizer3.Add((0, 10))
			self.show_profile_info = wx.CheckBox(dlg, -1,
												 lang.getstr("profile.info.show"))
			dlg.Bind(wx.EVT_CHECKBOX, self.profile_info_handler, 
					 id=self.show_profile_info.GetId())
			dlg.sizer3.Add(self.show_profile_info, flag=wx.TOP |
														wx.ALIGN_LEFT, 
						   border=4)
			if profile.ID == "\0" * 16:
				id = profile.calculateID(False)
			else:
				id = profile.ID
			if id in self.profile_info:
				self.show_profile_info.SetValue(
					self.profile_info[id].IsShownOnScreen())
			if installable:
				if sys.platform == "win32":
					# Get profile loader config
					cur = self.send_command("apply-profiles",
											"getcfg profile.load_on_login")
					if cur:
						try:
							cur = int(cur.split()[-1])
						except:
							pass
						else:
							setcfg("profile.load_on_login", cur)
					else:
						# Profile loader not running? Fall back to config files

						# 1. Remember current config
						items = config.cfg.items(config.ConfigParser.DEFAULTSECT)

						# 2. Read in profile loader config. Result is unison of
						#    current config and profile loader config.
						initcfg("apply-profiles")

						# 3. Restore current config (but do not override profile
						#    loader options)
						for name, value in items:
							if (name != "profile.load_on_login" and
								not name.startswith("profile_loader")):
								config.cfg.set(config.ConfigParser.DEFAULTSECT,
											   name, value)

						# 4. Remove profile loader options from current config
						for name in defaults:
							if name.startswith("profile_loader"):
								setcfg(name, None)
				if sys.platform != "darwin" or test:
					os_cal = (sys.platform == "win32" and
							  sys.getwindowsversion() >= (6, 1) and
							  util_win.calibration_management_isenabled())
					label = get_profile_load_on_login_label(os_cal)
					self.profile_load_on_login = wx.CheckBox(dlg, -1, label)
					self.profile_load_on_login.SetValue(
						bool(getcfg("profile.load_on_login") or os_cal))
					dlg.Bind(wx.EVT_CHECKBOX,
							 self.profile_load_on_login_handler, 
							 id=self.profile_load_on_login.GetId())
					dlg.sizer3.Add(self.profile_load_on_login, 
								   flag=wx.TOP | wx.ALIGN_LEFT, border=14)
					dlg.sizer3.Add((1, 4))
					if (sys.platform == "win32" and
						sys.getwindowsversion() >= (6, 1)):
						self.profile_load_by_os = wx.CheckBox(dlg, -1, 
							lang.getstr("profile.load_on_login.handled_by_os"))
						self.profile_load_by_os.SetValue(
							bool(os_cal))
						dlg.Bind(wx.EVT_CHECKBOX,
								 self.profile_load_by_os_handler, 
								 id=self.profile_load_by_os.GetId())
						dlg.sizer3.Add(self.profile_load_by_os, 
									   flag=wx.LEFT | wx.ALIGN_LEFT, border=16)
						dlg.sizer3.Add((1, 4))
						self.profile_load_on_login_handler()
				if ((sys.platform == "darwin" or (sys.platform != "win32" and 
												  self.worker.argyll_version >= 
												  [1, 1, 0])) and 
					(os.geteuid() == 0 or which("sudo"))) or \
					(sys.platform == "win32" and 
					 sys.getwindowsversion() >= (6, ) and 
					 self.worker.argyll_version > 
					 [1, 1, 1]) or test:
					# Linux, OSX or Vista and later
					# NOTE: System install scope is currently not implemented
					# correctly in dispwin 1.1.0, but a patch is trivial and
					# should be in the next version
					# 2010-06-18: Do not offer system install in DisplayCAL when
					# installing via GCM or oyranos FIXME: oyranos-monitor can't 
					# be run via sudo
					self.install_profile_user = wx.RadioButton(
						dlg, -1, lang.getstr("profile.install_user"), 
						style=wx.RB_GROUP)
					self.install_profile_user.SetValue(
						getcfg("profile.install_scope") == "u")
					dlg.Bind(wx.EVT_RADIOBUTTON, 
							 self.install_profile_scope_handler, 
							 id=self.install_profile_user.GetId())
					dlg.sizer3.Add(self.install_profile_user, 
								   flag=wx.TOP | wx.ALIGN_LEFT, border=10)
					self.install_profile_systemwide = wx.RadioButton(
						dlg, -1, lang.getstr("profile.install_local_system"))
					self.install_profile_systemwide.SetValue(
						getcfg("profile.install_scope") == "l")
					dlg.Bind(wx.EVT_RADIOBUTTON, 
							 self.install_profile_scope_handler, 
							 id=self.install_profile_systemwide.GetId())
					dlg.sizer3.Add(self.install_profile_systemwide, 
								   flag=wx.TOP | wx.ALIGN_LEFT, border=4)
					if sys.platform == "darwin" and \
					   os.path.isdir("/Network/Library/ColorSync/Profiles"):
						self.install_profile_network = wx.RadioButton(
							dlg, -1, lang.getstr("profile.install_network"))
						self.install_profile_network.SetValue(
							getcfg("profile.install_scope") == "n")
						dlg.Bind(wx.EVT_RADIOBUTTON, 
								 self.install_profile_scope_handler, 
								 id=self.install_profile_network.GetId())
						dlg.sizer3.Add(self.install_profile_network, 
									   flag=wx.TOP | wx.ALIGN_LEFT, border=4)
					self.install_profile_scope_handler(None)
				else:
					setcfg("profile.install_scope", "u")
			dlg.sizer0.SetSizeHints(dlg)
			dlg.sizer0.Layout()
			dlg.ok.SetDefault()
			dlg._disabler = BetterWindowDisabler([dlg,
												  getattr(self, "lut_viewer",
														  None)] +
												 self.profile_info.values())
			dlg.profile = profile
			dlg.profile_path = profile_path
			dlg.skip_scripts = skip_scripts
			dlg.preview = preview
			dlg.OnCloseIntercept = self.profile_finish_close_handler
			if sys.platform != "win32":
				# Make sure we stay under our dialog
				self.Bind(wx.EVT_ACTIVATE, self.modaldlg_raise_handler)
			dlg.Show()
		else:
			if isinstance(result, Exception):
				show_result_dialog(result, self)
				if getcfg("dry_run"):
					return
			InfoDialog(self, msg=failure_msg, 
					   ok=lang.getstr("ok"), 
					   bitmap=geticon(32, "dialog-error"))
			if sys.platform == "darwin":
				# For some reason, the call to enable_menus() in Show()
				# sometimes isn't enough under Mac OS X (e.g. after calibrate &
				# profile)
				self.enable_menus()
			self.start_timers(True)
			setcfg("calibration.file.previous", None)
	
	def profile_finish_close_handler(self, event):
		if event.GetEventObject() == self.modaldlg:
			result = wx.ID_CANCEL
		else:
			result = event.GetId()
		lut3d = config.is_virtual_display() or self.install_3dlut
		# madVR has an API for installing 3D LUTs (but currently no support
		# for installing into HDR slots since madVR v0.90.24 supports HDR
		# 3D LUTs)
		# Prisma has a HTTP REST interface for uploading and
		# configuring 3D LUTs
		install_3dlut_api = ((getcfg("3dlut.format") == "madVR" and
							  not getcfg("3dlut.trc").startswith("smpte2084")) or
							 config.check_3dlut_format("Prisma"))
		if result != wx.ID_OK or lut3d:
			if self.modaldlg.preview:
				if getcfg("calibration.file", False):
					# Load LUT curves from last used .cal file
					self.load_cal(silent=True)
					if not getcfg("calibration.autoload"):
						# Reload display profile into videoLUT
						self.load_display_profile_cal(True, False)
				else:
					# Load LUT curves from current display profile (if any, 
					# and if it contains curves)
					self.load_display_profile_cal(True)
				if getattr(self, "preview", None):
					self.preview.SetValue(False)
			if (result != wx.ID_OK or not self.lut3d_path or
				not os.path.isfile(self.lut3d_path) or
				not install_3dlut_api):
				self.profile_finish_consumer()
		if result == wx.ID_OK:
			producer = None
			if lut3d:
				if self.lut3d_path and os.path.isfile(self.lut3d_path):
					# 3D LUT file already exists
					if install_3dlut_api:
						filename = self.setup_patterngenerator(self.modaldlg,
															   lang.getstr("3dlut.install"),
															   True)
						if not filename:
							return
						producer = self.worker.install_3dlut
						wargs = (self.lut3d_path, filename)
						wkwargs = None
						progress_msg = lang.getstr("3dlut.install")
					else:
						# Copy to user-selectable location
						wx.CallAfter(self.lut3d_create_handler, None,
									 copy_from_path=self.lut3d_path)
				else:
					# Need to create 3D LUT
					wx.CallAfter(self.lut3d_create_handler, None)
			else:
				if getcfg("profile.install_scope") in ("l", "n"):
					result = self.worker.authenticate("dispwin",
													  lang.getstr("profile.install"),
													  self.modaldlg)
					if result not in (True, None):
						if isinstance(result, Exception):
							show_result_dialog(result, parent=self.modaldlg)
						self.modaldlg.Raise()
						return
				producer = self.worker.install_profile
				wargs = ()
				wkwargs = {"profile_path": self.modaldlg.profile_path, 
						   "skip_scripts": self.modaldlg.skip_scripts}
				progress_msg = lang.getstr("profile.install")
			if producer:
				safe_print("-" * 80)
				safe_print(progress_msg)
				self.worker.interactive = False
				self.worker.start(self.profile_finish_consumer,
								  producer, wargs=wargs, wkwargs=wkwargs,
								  parent=self.modaldlg,
								  progress_msg=progress_msg,
								  stop_timers=False, fancy=False)
	
	def profile_finish_consumer(self, result=None):
		if isinstance(result, Exception):
			show_result_dialog(result, parent=self.modaldlg)
			if not getcfg("dry_run") and not isinstance(result, (Info, Warning)):
				self.modaldlg.Raise()
				return
		elif result:
			# Check all profile install methods
			argyll_install, colord_install, oy_install, loader_install = result
			allgood = (argyll_install in (None, True) and
					   colord_install in (None, True) and
					   oy_install in (None, True) and
					   loader_install in (None, True))
			somegood = (argyll_install is True or
						colord_install is True or
						oy_install is True or
						loader_install is True)
			linux = sys.platform not in ("darwin", "win32")
			if allgood:
				msg = lang.getstr("profile.install.success")
				icon = "dialog-information"
			elif somegood and linux:
				msg = lang.getstr("profile.install.warning")
				icon = "dialog-warning"
			else:
				msg = lang.getstr("profile.install.error")
				icon = "dialog-error"
			dlg = InfoDialog(self.modaldlg, msg=msg, ok=lang.getstr("ok"), 
							 bitmap=geticon(32, icon), show=False)
			if not allgood and linux:
				sizer = wx.FlexGridSizer(0, 2, 8, 8)
				dlg.sizer3.Add(sizer, 1, flag=wx.TOP, border=12)
				for name, result in (("Argyll CMS", argyll_install),
									 ("colord", colord_install),
									 ("Oyranos", oy_install),
									 (lang.getstr("profile_loader"),
									  loader_install)):
					if result is not None:
						if result is True:
							icon = "checkmark"
							result = lang.getstr("ok")
						elif isinstance(result, Warning):
							icon = "dialog-warning"
						else:
							icon = "x"
							if not result:
								result = lang.getstr("failure")
						result = wrap(safe_unicode(result))
						sizer.Add(wx.StaticBitmap(dlg, -1, geticon(16, icon)),
								  flag=wx.TOP, border=2)
						sizer.Add(wx.StaticText(dlg, -1, ": ".join([name,
																	result])))
				dlg.sizer0.SetSizeHints(dlg)
				dlg.sizer0.Layout()
			dlg.ok.SetDefault()
			dlg.ShowModalThenDestroy(self.modaldlg)
		# Unbind automatic lowering
		self.Unbind(wx.EVT_ACTIVATE)
		self.Raise()
		del self.modaldlg._disabler
		self.modaldlg.Destroy()
		# The C part of modaldlg will not be gone instantly, so we must
		# dereference it before we can delete the python attribute
		self.modaldlg = None
		del self.modaldlg
		if sys.platform == "darwin":
			# For some reason, the call to enable_menus() in Show()
			# sometimes isn't enough under Mac OS X (e.g. after calibrate &
			# profile)
			self.enable_menus()
		self.start_timers(True)
		setcfg("calibration.file.previous", None)
	
	def profile_info_close_handler(self, event):
		if getattr(self, "show_profile_info", None):
			# If the profile install dialog is shown, just hide info window
			self.profile_info[event.GetEventObject().profileID].Hide()
			self.show_profile_info.SetValue(False)
		else:
			# Remove the frame from the hash table
			self.profile_info.pop(event.GetEventObject().profileID)
			# Closes the window
			event.Skip()
	
	def profile_info_handler(self, event=None, profile=None):
		if profile:
			pass
		elif (event and
			  event.GetEventObject() is getattr(self, "show_profile_info",
												False)):
			# Use the profile that was requested to be installed
			profile = self.modaldlg.profile
		else:
			profile = self.select_profile(title=lang.getstr("profile.info"),
										  check_profile_class=False,
										  prefer_current_profile=True,
										  ignore_current_profile=event and
																 event.GetEventObject()
																 is not self.profile_info_btn)
		if not profile:
			return
		if profile.ID == "\0" * 16:
			id = profile.calculateID(False)
		else:
			id = profile.ID
		show = (not getattr(self, "show_profile_info", None) or
				self.show_profile_info.GetValue())
		if show:
			if not id in self.profile_info:
				# Create profile info window and store in hash table
				self.profile_info[id] = ProfileInfoFrame(None, -1)
				self.profile_info[id].Unbind(wx.EVT_CLOSE)
				self.profile_info[id].Bind(wx.EVT_CLOSE,
										   self.profile_info_close_handler)
			if (not self.profile_info[id].profile or
				self.profile_info[id].profile.calculateID(False) != id):
				# Load profile if info window has no profile or ID is different
				self.profile_info[id].profileID = id
				self.profile_info[id].LoadProfile(profile)
		if self.profile_info.get(id):
			if self.profile_info[id].IsIconized() and show:
				self.profile_info[id].Restore()
			else:
				self.profile_info[id].Show(show)
			if show:
				self.profile_info[id].Raise()

	def get_commands(self):
		return (self.get_common_commands() +
				["3DLUT-maker [create filename]", "calibrate",
				 "calibrate-profile",
				 "create-colorimeter-correction",
				 "create-profile [filename]",
				 "curve-viewer [filename]",
				 appname + " [filename]", "enable-spyder2",
				 "import-colorimeter-corrections [filename...]",
				 "install-profile [filename]", "load <filename>",
				 "measure", "measure-uniformity",
				 "measurement-report [filename]", "profile",
				 "profile-info [filename]", "report-calibrated",
				 "report-uncalibrated", "set-argyll-dir [dirname]",
				 "synthprofile [filename]",
				 "testchart-editor [filename | create filename]",
				 "verify-calibration"])

	def process_data(self, data):
		""" Process data """
		if not self.IsShownOnScreen() and data[0] != "measure":
			# If we were hidden, perform necessary cleanup in case the
			# measurement window is shown and we're not starting measurements
			if isinstance(getattr(self, "_measureframe_subprocess", None),
						  sp.Popen):
				self._measureframe_subprocess.terminate()
			elif hasattr(self, "measureframe"):
				self.measureframe.close_handler(None)
			else:
				return "busy"
		response = "ok"
		if data[0] == "3DLUT-maker" and (len(data) == 1 or
										 (len(data) == 3 and
										  data[1] == "create")):
			# 3D LUT maker
			if len(data) == 3:
				self.lut3d_create_handler(None, data[-1])
			else:
				self.tab_select_handler(self.lut3d_settings_btn, True)
		elif data[0] == "curve-viewer" and len(data) < 3:
			# Curve viewer
			profile = None
			if len(data) == 2:
				path = data[1]
				if not os.path.isfile(path) and not os.path.isabs(path):
					path = get_data_path(path)
				if not path:
					return "fail"
				try:
					profile = ICCP.ICCProfile(path)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					return "fail"
			wx.CallAfter(self.init_lut_viewer, profile=profile, show=True)
		elif data[0] == "profile-info" and len(data) < 3:
			# Profile info
			profile = None
			if len(data) == 2:
				path = data[1]
				if not os.path.isfile(path) and not os.path.isabs(path):
					path = get_data_path(path)
				if not path:
					return "fail"
				try:
					profile = ICCP.ICCProfile(path)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					return "fail"
			wx.CallAfter(self.profile_info_handler, profile=profile)
		elif data[0] == "synthprofile" and len(data) < 3:
			# Synthetic profile creator
			self.synthicc_create_handler(None)
			if len(data) == 2:
				response = self.synthiccframe.process_data(data)
		elif data[0] == "testchart-editor" and (len(data) < 3 or
												(len(data) == 3 and
												 data[1] == "create")):
			# Testchart editor
			if len(data) == 2:
				path = data[1]
				if not os.path.isfile(path) and not os.path.isabs(path):
					path = get_data_path(path)
				if not path:
					return "fail"
			else:
				path = None
			if not hasattr(self, "tcframe"):
				self.init_tcframe(path=path)
				setcfg("tc.show", 1)
				self.tcframe.Show()
			else:
				if self.tcframe.IsIconized():
					self.tcframe.Restore()
				else:
					self.tcframe.Show()
				if path:
					self.tcframe.tc_load_cfg_from_ti1(path=path)
			self.tcframe.Raise()
			if len(data) == 3:
				# Create testchart
				response = self.tcframe.process_data(data)
		elif (data[0] == appname and len(data) < 3) or (data[0] == "load" and
														len(data) == 2):
			# Main window
			if self.IsIconized():
				self.Restore()
			self.Raise()
			if len(data) == 2:
				path = data[1]
				if not os.path.isfile(path) and not os.path.isabs(path):
					path = get_data_path(path)
				if not path:
					return "fail"
				else:
					self.droptarget.OnDropFiles(0, 0, [path])
		elif data[0] == "calibrate" and len(data) == 1:
			# Calibrate
			wx.CallAfter(self.calibrate_btn_handler,
						 CustomEvent(wx.EVT_BUTTON.evtType[0], 
									 self.calibrate_btn))
		elif data[0] == "calibrate-profile" and len(data) == 1:
			# Calibrate & profile
			wx.CallAfter(self.calibrate_and_profile_btn_handler,
						 CustomEvent(wx.EVT_BUTTON.evtType[0], 
						 self.calibrate_and_profile_btn))
		elif data[0] == "create-profile" and len(data) < 3:
			if len(data) == 2:
				profile_path = data[1]
			else:
				profile_path = None
			wx.CallAfter(self.create_profile_handler, None, path=profile_path)
		elif data[0] == "import-colorimeter-corrections":
			wx.CallAfter(self.import_colorimeter_corrections_handler, None,
						 paths=data[1:])
		elif data[0] == "install-profile" and len(data) < 3:
			if len(data) == 2:
				wx.CallAfter(self.install_profile_handler, profile_path=data[1],
							 install_3dlut=False)
			else:
				wx.CallAfter(self.select_install_profile_handler, None)
		elif data[0] == "measure" and len(data) == 1:
			# Start measurement
			if getattr(self, "pending_function", None):
				if isinstance(getattr(self, "_measureframe_subprocess", None),
							  sp.Popen):
					p = self._measureframe_subprocess
					self._measureframe_subprocess = Dummy()
					self._measureframe_subprocess.returncode = 255
					p.terminate()
				else:
					self.worker.wrapup(False)
					self.HideAll()
					self.call_pending_function()
			else:
				response = "fail"
		elif data[0] == "measurement-report" and len(data) < 3:
			# Measurement report
			if len(data) == 2:
				wx.CallAfter(self.measurement_report_handler,
							 CustomEvent(wx.EVT_BUTTON.evtType[0],
										 self.measurement_report_btn),
							 path=data[1])
			else:
				self.tab_select_handler(self.mr_settings_btn, True)
		elif data[0] == "profile" and len(data) == 1:
			# Profile
			wx.CallAfter(self.profile_btn_handler,
						 CustomEvent(wx.EVT_BUTTON.evtType[0], 
									 self.profile_btn))
		elif data[0] == "refresh" and len(data) == 1:
			# Refresh main window
			self.update_displays()
			self.update_controls()
			self.update_menus()
			if hasattr(self, "tcframe"):
				self.tcframe.tc_update_controls()
		elif data[0] == "restore-defaults":
			# Restore defaults
			wx.CallAfter(self.restore_defaults_handler, include=data[1:])
		elif data[0] == "setlanguage" and len(data) == 2:
			setcfg("lang", data[1])
			menuitem = self.menubar.FindItemById(lang.ldict[lang.getcode()].menuitem_id)
			event = CustomEvent(wx.EVT_MENU.typeId, menuitem)
			wx.CallAfter(self.set_language_handler, event)
		elif (data[0] in ("create-colorimeter-correction",
						  "enable-spyder2",
						  "measure-uniformity",
						  "report-calibrated", "report-uncalibrated",
						  "verify-calibration")) and len(data) == 1:
			wx.CallAfter(getattr(self, data[0].replace("-", "_") + "_handler"),
						 True)
		elif data[0] == "set-argyll-dir" and len(data) <= 2:
			if (getattr(self.worker, "thread", None) and
				self.worker.thread.isAlive()):
				return "blocked"
			if len(data) == 2:
				setcfg("argyll.dir", data[1])
				wx.CallAfter(self.check_update_controls, True)
			else:
				wx.CallAfter(self.set_argyll_bin_handler, True)
		else:
			response = "invalid"
		return response
	
	def modaldlg_raise_handler(self, event):
		""" Prevent modal dialog from being lowered (keep on top) """
		self.modaldlg.Raise()

	def observer_ctrl_handler(self, event):
		observer = self.observers_ba.get(self.observer_ctrl.GetStringSelection())
		setcfg("observer", observer)

	def init_lut_viewer(self, event=None, profile=None, show=None):
		if debug:
			safe_print("[D] init_lut_viewer", 
					   profile.getDescription() if profile else None, 
					   "show:", show)
		if LUTFrame:
			lut_viewer = getattr(self, "lut_viewer", None)
			if not lut_viewer:
				self.lut_viewer = LUTFrame(None, -1)
				self.lut_viewer.client.worker = self.worker
				self.lut_viewer.update_controls()
				self.lut_viewer.Bind(wx.EVT_CLOSE, 
									 self.lut_viewer_close_handler, 
									 self.lut_viewer)
			if not profile and not hasattr(self, "current_cal"):
				path = getcfg("calibration.file", False)
				if path:
					name, ext = os.path.splitext(path)
					if ext.lower() in (".icc", ".icm"):
						try:
							profile = ICCP.ICCProfile(path)
						except (IOError, ICCP.ICCProfileInvalidError), \
							   exception:
							msg = lang.getstr("profile.invalid") + "\n" + path
							if event or not lut_viewer:
								show_result_dialog(Error(msg), self)
							else:
								safe_print(msg)
							profile = None
					else:
						profile = cal_to_fake_profile(path)
				else:
					profile = get_display_profile() or False
			if show is None:
				show = not self.lut_viewer.IsShownOnScreen()
			if debug:
				safe_print("[D] init_lut_viewer (2)", 
						   profile.getDescription() if profile else None, 
						   "show:", show)
			self.show_lut_handler(profile=profile, show=show)
	
	def lut_viewer_load_lut(self, event=None, profile=None, force_draw=False):
		if debug:
			safe_print("[D] lut_viewer_load_lut", 
					   profile.getDescription() if profile else None, 
					   "force_draw:", force_draw)
		if LUTFrame:
			self.current_cal = profile
		if getattr(self, "lut_viewer", None) and \
		   (self.lut_viewer.IsShownOnScreen() or force_draw):
			self.lut_viewer.load_lut(profile)
	
	def show_lut_handler(self, event=None, profile=None, show=None):
		if debug:
			safe_print("[D] show_lut_handler", 
					   profile.getDescription() if profile else None, 
					   "show:", show)
		if show is None:
			show = bool((hasattr(self, "show_lut") and self.show_lut and 
						 self.show_lut.GetValue()) or 
						(not hasattr(self, "show_lut") or 
						 not self.show_lut))
		setcfg("lut_viewer.show", int(show))
		if not profile and hasattr(self, "current_cal"):
			profile = self.current_cal
		if show:
			self.lut_viewer_load_lut(event, profile, force_draw=True)
		if getattr(self, "lut_viewer", None):
			self.menuitem_show_lut.Check(show)
			if self.lut_viewer.IsIconized() and show:
				self.lut_viewer.Restore()
			else:
				self.lut_viewer.Show(show)
			if show:
				self.lut_viewer.Raise()
	
	def lut_viewer_close_handler(self, event=None):
		setcfg("lut_viewer.show", 0)
		self.lut_viewer.Hide()
		self.menuitem_show_lut.Check(False)
		if hasattr(self, "show_lut") and self.show_lut:
			self.show_lut.SetValue(self.lut_viewer.IsShownOnScreen())

	def show_advanced_options_handler(self, event=None):
		""" Show or hide advanced calibration settings """
		show_advanced_options = bool(getcfg("show_advanced_options"))
		if event:
			show_advanced_options = not show_advanced_options
			setcfg("show_advanced_options", 
				   int(show_advanced_options))
		self.panel.Freeze()
		self.menuitem_show_advanced_options.Check(show_advanced_options)
		self.menuitem_advanced_options.Enable(show_advanced_options)
		self.override_display_settle_time_mult.Show(
			show_advanced_options and
			getcfg("argyll.version") >= "1.7")
		self.display_settle_time_mult.Show(
			show_advanced_options and
			getcfg("argyll.version") >= "1.7")
		for ctrl in (self.override_min_display_update_delay_ms,
					 self.min_display_update_delay_ms,
					 self.min_display_update_delay_ms_label,
					 self.black_luminance_label,
					 self.black_luminance_ctrl,
					 # Profiling options
					 self.black_point_compensation_cb,
					 self.profile_type_label,
					 self.profile_type_ctrl,
					 self.gamap_btn):
			ctrl.GetContainingSizer().Show(ctrl,
										   show_advanced_options)
		self.whitepoint_colortemp_locus_label.Show(show_advanced_options and
			self.whitepoint_ctrl.GetSelection() != 2)
		self.whitepoint_colortemp_locus_ctrl.Show(show_advanced_options and
			self.whitepoint_ctrl.GetSelection() != 2)
		self.black_luminance_textctrl.Show(show_advanced_options and
										   bool(getcfg("calibration.black_luminance", False)))
		self.black_luminance_textctrl_label.Show(show_advanced_options and
												 bool(getcfg("calibration.black_luminance", False)))
		self.lut3d_show_controls()
		if event:
			self.show_observer_ctrl()
			self.show_trc_controls()
		self.calpanel.Layout()
		self.calpanel.Refresh()
		self.panel.Thaw()
		if event:
			self.set_size(True)
		self.update_scrollbars()

	def show_observer_ctrl(self):
		self.panel.Freeze()
		show = bool((getcfg("calibration.interactive_display_adjustment", False) or
					 getcfg("trc")) and
					getcfg("show_advanced_options") and
					self.worker.instrument_can_use_nondefault_observer())
		self.observer_label.Show(show)
		self.observer_ctrl.Show(show)
		self.calpanel.Layout()
		self.panel.Thaw()
		self.update_scrollbars()

	def update_observer_ctrl(self):
		self.observer_ctrl.SetStringSelection(self.observers_ab[getcfg("observer")])
	
	def install_profile_scope_handler(self, event):
		if self.install_profile_systemwide.GetValue():
			setcfg("profile.install_scope", "l")
			if hasattr(self.modaldlg.ok, "SetAuthNeeded"):
				self.modaldlg.ok.SetAuthNeeded(True)
		elif sys.platform == "darwin" and \
			 os.path.isdir("/Network/Library/ColorSync/Profiles") and \
			 self.install_profile_network.GetValue():
			setcfg("profile.install_scope", "n")
		elif self.install_profile_user.GetValue():
			setcfg("profile.install_scope", "u")
			if hasattr(self.modaldlg.ok, "SetAuthNeeded"):
				self.modaldlg.ok.SetAuthNeeded(False)
		self.modaldlg.buttonpanel.Layout()
	
	def start_timers(self, wrapup=False):
		if wrapup:
			self.worker.wrapup(False)
		if not self.update_profile_name_timer.IsRunning():
			self.update_profile_name_timer.Start(1000)
	
	def stop_timers(self):
		self.update_profile_name_timer.Stop()

	def synthicc_create_handler(self, event):
		""" Assign and initialize the synthetic ICC creation window """
		if not getattr(self, "synthiccframe", None):
			self.init_synthiccframe()
		if self.synthiccframe.IsShownOnScreen():
			if self.synthiccframe.IsIconized():
				self.synthiccframe.Restore()
			self.synthiccframe.Raise()
		else:
			self.synthiccframe.Show(not self.synthiccframe.IsShownOnScreen())

	def tab_select_handler(self, event, update_main_controls=False):
		if hasattr(event, "EventObject") and not event.EventObject.IsEnabled():
			return
		self.panel.Freeze()
		btn2tab = {self.display_instrument_btn: self.display_instrument_panel,
				   self.calibration_settings_btn: self.calibration_settings_panel,
				   self.profile_settings_btn: self.profile_settings_panel,
				   self.lut3d_settings_btn: self.lut3d_settings_panel,
				   self.mr_settings_btn: self.mr_settings_panel}
		for btn, tab in btn2tab.iteritems():
			if event.GetId() == btn.Id:
				if tab is self.mr_settings_panel and not tab.IsShown():
					if not hasattr(self, "XYZbpin"):
						self.mr_init_controls()
					else:
						self.mr_update_controls()
				elif tab is self.lut3d_settings_panel and not tab.IsShown():
					self.set_profile("output")
					self.lut3d_show_trc_controls()
				if hasattr(self, "install_profile_btn"):
					if tab is self.lut3d_settings_panel:
						self.install_profile_btn.SetToolTipString(
							lang.getstr("3dlut.install"))
					else:
						self.install_profile_btn.SetToolTipString(
							lang.getstr("profile.install"))
				tab.Show()
				btn._pressed = True
				btn._SetState(platebtn.PLATE_PRESSED)
			else:
				tab.Hide()
				btn._pressed = False
				btn._SetState(platebtn.PLATE_NORMAL)
		self.calpanel.Layout()
		if isinstance(event, wx.Event) or update_main_controls:
			self.update_main_controls()
		self.panel.Thaw()
		self.update_scrollbars()
		self.calpanel.Layout()
	
	def colorimeter_correction_matrix_ctrl_handler(self, event, path=None):
		measurement_mode = getcfg("measurement_mode")
		if (event and
			event.GetId() == self.colorimeter_correction_matrix_ctrl.GetId()):
			ccmx = getcfg("colorimeter_correction_matrix_file").split(":", 1)
			if self.colorimeter_correction_matrix_ctrl.GetSelection() == 0:
				# Off
				ccmx = ["", ""]
			elif self.colorimeter_correction_matrix_ctrl.GetSelection() == 1:
				# Auto
				ccmx = ["AUTO", ""]
			else:
				path = self.ccmx_item_paths[
					self.colorimeter_correction_matrix_ctrl.GetSelection() - 2]
				ccmx = ["", path]
			setcfg("colorimeter_correction_matrix_file", ":".join(ccmx))
			self.update_colorimeter_correction_matrix_ctrl_items()
		else:
			if not path:
				ccmx = getcfg("colorimeter_correction_matrix_file").split(":", 1)
				defaultDir, defaultFile = get_verified_path(None, ccmx.pop())
				dlg = wx.FileDialog(self, 
									lang.getstr("colorimeter_correction_matrix_file.choose"), 
									defaultDir=defaultDir if defaultFile else config.get_argyll_data_dir(), 
									defaultFile=defaultFile,
									wildcard=lang.getstr("filetype.ccmx") + 
											 "|*.ccmx;*.ccss", 
									style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
				dlg.Center(wx.BOTH)
				if dlg.ShowModal() == wx.ID_OK:
					path = dlg.GetPath()
				dlg.Destroy()
			if path:
				if (getcfg("colorimeter_correction_matrix_file").split(":")[0] != "AUTO" or
					path not in self.ccmx_cached_paths):
					setcfg("colorimeter_correction_matrix_file", ":" + path)
				self.update_colorimeter_correction_matrix_ctrl_items(warn_on_mismatch=True)
		if measurement_mode != getcfg("measurement_mode"):
			# Check if black point correction should be turned on
			self.measurement_mode_ctrl_handler()
	
	def colorimeter_correction_web_handler(self, event):
		""" Check the web for cccmx or ccss files """
		if self.worker.instrument_supports_ccss():
			filetype = 'ccss,ccmx'
		else:
			filetype = 'ccmx'
		params = {'get': True,
				  'type': filetype,
				  'manufacturer_id': self.worker.get_display_edid().get("manufacturer_id", ""),
				  'display': self.worker.get_display_name(False, True) or "Unknown",
				  'instrument': self.worker.get_instrument_name() or "Unknown"}
		self.worker.interactive = False
		self.worker.start(colorimeter_correction_web_check_choose, 
						  http_request, 
						  ckwargs={"parent": self}, 
						  wargs=(self, "colorimetercorrections." + domain, "GET",
								 "/index.php", params),
						  progress_msg=lang.getstr("colorimeter_correction.web_check"),
						  stop_timers=False, cancelable=False,
						  show_remaining_time=False, fancy=False)
	
	def create_colorimeter_correction_handler(self, event=None, paths=None,
											  luminance=None):
		"""
		Create a CCSS or CCMX file from one or more .ti3 files
		
		Atleast one of the ti3 files must be a measured with a spectrometer.
		
		"""
		parent = self if event else None
		id_measure_reference = wx.NewId()
		id_measure_colorimeter = wx.NewId()
		if not paths:
			dlg = ConfirmDialog(parent,
								title=lang.getstr("colorimeter_correction.create"),
								msg=lang.getstr("colorimeter_correction.create.info"), 
								ok=lang.getstr("colorimeter_correction.create"),
								cancel=lang.getstr("cancel"), 
								alt=lang.getstr("browse"), 
								bitmap=geticon(32, "dialog-information"),
								wrap=90)
			# Colorimeter correction type
			# We deliberately don't use RadioBox because there's no way to
			# set the correct background color (this matters under MSWindows
			# where the dialog background is usually white) unless you use
			# Phoenix.
			boxsizer = wx.StaticBoxSizer(wx.StaticBox(dlg, -1,
													  lang.getstr("type")),
										 wx.VERTICAL)
			dlg.sizer3.Add(boxsizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
			if sys.platform not in ("darwin", "win32"):
				boxsizer.Add((1, 8))
			dlg.correction_type_matrix = wx.RadioButton(dlg, -1,
														lang.getstr("matrix"), 
														style=wx.RB_GROUP)
			boxsizer.Add(dlg.correction_type_matrix, flag=wx.ALL | wx.EXPAND,
						 border=4)
			dlg.correction_type_spectral = wx.RadioButton(dlg, -1,
														  lang.getstr("spectral") +
														  " (i1 DisplayPro, "
														  "ColorMunki "
														  "Display, Spyder4/5)")
			boxsizer.Add(dlg.correction_type_spectral, flag=wx.ALL | wx.EXPAND,
						 border=4)
			{"matrix": dlg.correction_type_matrix,
			 "spectral": dlg.correction_type_spectral}.get(
				getcfg("colorimeter_correction.type"), "matrix").SetValue(True)
			# Get instruments
			reference_instruments = []
			colorimeters = []
			for instrument in self.worker.instruments:
				if instruments.get(instrument, {}).get("spectral"):
					reference_instruments.append(instrument)
				else:
					colorimeters.append(instrument)
			# Reference instrument
			boxsizer = wx.StaticBoxSizer(wx.StaticBox(dlg, -1,
													  "%s (%s)" %
													  (lang.getstr("instrument"),
													   lang.getstr("reference"))),
										 wx.VERTICAL)
			dlg.sizer3.Add(boxsizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
			if sys.platform not in ("darwin", "win32"):
				boxsizer.Add((1, 8))
			hsizer = wx.BoxSizer(wx.HORIZONTAL)
			boxsizer.Add(hsizer, flag=wx.EXPAND)
			dlg.reference_instrument = wx.Choice(dlg, -1,
												 choices=reference_instruments)
			hsizer.Add(dlg.reference_instrument, 1,
					   flag=wx.LEFT | wx.TOP | wx.BOTTOM |
							wx.ALIGN_CENTER_VERTICAL, border=4)
			hsizer.Add(wx.StaticText(dlg, -1,
									   lang.getstr("measurement_mode")),
						 flag=wx.LEFT | wx.RIGHT | wx.ALIGN_CENTER_VERTICAL,
						 border=8)
			dlg.measurement_mode_reference = wx.Choice(dlg, -1, choices=[])
			def set_ok_btn_state():
				dlg.ok.Enable(bool(getcfg("last_reference_ti3_path", False) and 
								   os.path.isfile(getcfg("last_reference_ti3_path")) and
								   ((getcfg("last_colorimeter_ti3_path", False) and
									 os.path.isfile(getcfg("last_colorimeter_ti3_path"))) or
									dlg.correction_type_spectral.GetValue())))
			def check_last_ccxx_ti3(event):
				cfgname = "colorimeter_correction.measurement_mode"
				if event.GetId() in (dlg.instrument.Id,
									 dlg.measurement_mode.Id,
									 dlg.observer_ctrl.Id):
					name = "colorimeter"
					instrument = dlg.instrument.GetStringSelection()
					measurement_mode = self.get_ccxx_measurement_modes(
						instrument, True).get(dlg.measurement_mode.GetStringSelection())
					observer_ctrl = dlg.observer_ctrl
				else:
					name = "reference"
					cfgname += "." + name
					instrument = dlg.reference_instrument.GetStringSelection()
					if hasattr(dlg, "modes_ab"):
						measurement_mode = dlg.modes_ab["spect"][
							dlg.measurement_mode_reference.GetSelection()]
					else:
						measurement_mode = None
					observer_ctrl = dlg.observer_reference_ctrl
				if debug or verbose >= 2:
					safe_print("check_last_ccxx_ti3", name)
					safe_print("instrument =", instrument)
					safe_print("measurement_mode =", measurement_mode)
				if self.worker.instrument_can_use_nondefault_observer(instrument):
					observer = self.observers_ba[observer_ctrl.GetStringSelection()]
				else:
					observer = defaults["observer"]
				if debug or verbose >= 2:
					safe_print("observer =", observer)
				if getcfg("last_%s_ti3_path.backup" % name, False):
					setcfg("last_%s_ti3_path" % name,
						   getcfg("last_%s_ti3_path.backup" % name))
					setcfg("last_%s_ti3_path.backup" % name, None)
				ti3 = getcfg("last_%s_ti3_path" % name, False)
				if debug or verbose >= 2:
					safe_print("last_%s_ti3_path =" % name, ti3)
				if ti3:
					if os.path.isfile(ti3):
						try:
							cgats = CGATS.CGATS(ti3)
						except (IOError, CGATS.CGATSError), exception:
							show_result_dialog(exception, dlg)
							cgats = CGATS.CGATS()
						cgats_instrument = cgats.queryv1("TARGET_INSTRUMENT")
						if cgats_instrument:
							cgats_instrument = get_canonical_instrument_name(
								cgats_instrument)
						if debug or verbose >= 2:
							safe_print("cgats_instrument =", cgats_instrument)
						if name == "reference":
							if getcfg(cfgname + ".projector"):
								cgats_measurement_mode = "p"
							else:
								cgats_measurement_mode = getcfg(cfgname)
						else:
							cgats_measurement_mode = get_cgats_measurement_mode(
								cgats, cgats_instrument)
						if cgats_measurement_mode:
							instrument_features = self.worker.get_instrument_features(instrument)
							if (instrument_features.get("adaptive_mode") and
								getcfg(cfgname + ".adaptive")):
								cgats_measurement_mode += "V"
							if (instrument_features.get("highres_mode") and
								cgats.queryv1("SPECTRAL_BANDS") > 36):
								cgats_measurement_mode += "H"
						if debug or verbose >= 2:
							safe_print("cgats_measurement_mode =", cgats_measurement_mode)
						cgats_observer = cgats.queryv1("OBSERVER")
						if not cgats_observer:
							cgats_observer = defaults["observer"]
						if debug or verbose >= 2:
							safe_print("cgats_observer =", cgats_observer)
						if (cgats_instrument != instrument or
							cgats_measurement_mode != measurement_mode or
							cgats_observer != observer):
							setcfg("last_%s_ti3_path.backup" % name,
								   getcfg("last_%s_ti3_path" % name))
							setcfg("last_%s_ti3_path" % name, None)
					else:
						setcfg("last_%s_ti3_path" % name, None)
				ti3 = getcfg("last_%s_ti3_path" % name, False)
				if debug or verbose >= 2:
					safe_print("last_%s_ti3_path =" % name, ti3)
				if ti3:
					bmp = geticon(16, "checkmark")
				else:
					bmp = geticon(16, "empty")
				getattr(dlg, "measure_" + name).SetBitmapLabel(bmp)
				getattr(dlg, "measure_" + name).Refresh()
				getattr(dlg, "measure_" + name)._bmp.SetToolTipString(ti3 or "")
				if isinstance(event, wx.Event):
					set_ok_btn_state()
			dlg.measurement_mode_reference.Bind(wx.EVT_CHOICE,
												check_last_ccxx_ti3)
			hsizer.Add(dlg.measurement_mode_reference,
					   flag=wx.RIGHT | wx.TOP | wx.BOTTOM |
							wx.ALIGN_CENTER_VERTICAL, border=8)
			# Make measure button height match instrument choice height
			btn_h = dlg.reference_instrument.Size[1]
			if sys.platform == "win32" and sys.getwindowsversion() < (6, 2):
				# Windows 7 / Vista / XP
				btn_h += 2
			dlg.measure_reference = BitmapWithThemedButton(dlg,
				id_measure_reference, geticon(16, "empty"),
				lang.getstr("measure"), size=(-1, btn_h))
			if sys.platform == "win32":
				dlg.measure_reference.SetBackgroundColour(dlg.BackgroundColour)
			dlg.measure_reference.Bind(wx.EVT_BUTTON, dlg.OnClose)
			hsizer.Add(dlg.measure_reference,
					   flag=wx.RIGHT | wx.TOP | wx.BOTTOM |
							wx.ALIGN_CENTER_VERTICAL, border=4)
			dlg.measure_reference.Enable(bool(self.worker.displays and
											  reference_instruments))
			dlg.observer_reference_label = wx.StaticText(dlg, -1, lang.getstr("observer"))
			hsizer = wx.BoxSizer(wx.HORIZONTAL)
			boxsizer.Add(hsizer, flag=wx.BOTTOM, border=8)
			hsizer.Add(dlg.observer_reference_label,
					   flag=wx.LEFT | wx.ALIGN_CENTER_VERTICAL, border=4)
			dlg.observer_reference_ctrl = wx.Choice(dlg, -1,
										  choices=self.observers_ab.values())
			dlg.observer_reference_ctrl.Bind(wx.EVT_CHOICE,
											 check_last_ccxx_ti3)
			hsizer.Add(dlg.observer_reference_ctrl,
					   flag=wx.LEFT | wx.ALIGN_CENTER_VERTICAL, border=8)
			dlg.observer_reference_ctrl.SetStringSelection(
				self.observers_ab[getcfg("colorimeter_correction.observer.reference")])
			dlg.observer_reference_label.Show(bool(getcfg("show_advanced_options")))
			dlg.observer_reference_ctrl.Show(bool(getcfg("show_advanced_options")))
			def reference_instrument_handler(event):
				mode, modes, dlg.modes_ab, modes_ba = self.get_measurement_modes(
					dlg.reference_instrument.GetStringSelection(), "spect",
					"colorimeter_correction.measurement_mode.reference")
				dlg.measurement_mode_reference.SetItems(modes["spect"])
				dlg.measurement_mode_reference.SetSelection(
					min(modes_ba["spect"].get(mode, 1),
						len(modes["spect"]) - 1))
				dlg.measurement_mode_reference.Enable(len(modes["spect"]) > 1)
				boxsizer.Layout()
				if event:
					check_last_ccxx_ti3(event)
			instrument = getcfg("colorimeter_correction.instrument.reference")
			if instrument in reference_instruments:
				dlg.reference_instrument.SetStringSelection(instrument)
			elif reference_instruments:
				dlg.reference_instrument.SetSelection(0)
			else:
				dlg.measurement_mode_reference.Disable()
			if reference_instruments:
				reference_instrument_handler(None)
			if len(reference_instruments) < 2:
				dlg.reference_instrument.Disable()
			else:
				dlg.reference_instrument.Bind(wx.EVT_CHOICE,
											  reference_instrument_handler)
			# Instrument
			boxsizer = wx.StaticBoxSizer(wx.StaticBox(dlg, -1,
													  lang.getstr("instrument")),
										 wx.VERTICAL)
			dlg.sizer3.Add(boxsizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
			if sys.platform not in ("darwin", "win32"):
				boxsizer.Add((1, 8))
			hsizer = wx.BoxSizer(wx.HORIZONTAL)
			boxsizer.Add(hsizer, flag=wx.EXPAND)
			dlg.instrument = wx.Choice(dlg, -1, choices=colorimeters)
			hsizer.Add(dlg.instrument, 1, flag=wx.LEFT | wx.TOP |  wx.BOTTOM |
											   wx.ALIGN_CENTER_VERTICAL,
					   border=4)
			hsizer.Add(wx.StaticText(dlg, -1,
									 lang.getstr("measurement_mode")),
					   flag=wx.LEFT | wx.RIGHT | wx.ALIGN_CENTER_VERTICAL,
					   border=8)
			dlg.measurement_mode = wx.Choice(dlg, -1, choices=[])
			dlg.measurement_mode.Bind(wx.EVT_CHOICE, check_last_ccxx_ti3)
			hsizer.Add(dlg.measurement_mode,
					   flag=wx.RIGHT | wx.TOP | wx.BOTTOM |
							wx.ALIGN_CENTER_VERTICAL, border=8)
			dlg.measure_colorimeter = BitmapWithThemedButton(dlg,
				id_measure_colorimeter, geticon(16, "empty"),
				lang.getstr("measure"), size=(-1, btn_h))
			if sys.platform == "win32":
				dlg.measure_colorimeter.SetBackgroundColour(dlg.BackgroundColour)
			dlg.measure_colorimeter.Bind(wx.EVT_BUTTON, dlg.OnClose)
			hsizer.Add(dlg.measure_colorimeter,
					   flag=wx.RIGHT | wx.TOP | wx.BOTTOM |
							wx.ALIGN_CENTER_VERTICAL, border=4)
			dlg.measure_colorimeter.Enable(bool(self.worker.displays and
												colorimeters))
			dlg.observer_label = wx.StaticText(dlg, -1, lang.getstr("observer"))
			hsizer = wx.BoxSizer(wx.HORIZONTAL)
			boxsizer.Add(hsizer, flag=wx.BOTTOM, border=8)
			hsizer.Add(dlg.observer_label,
					   flag=wx.LEFT | wx.ALIGN_CENTER_VERTICAL, border=4)
			dlg.observer_ctrl = wx.Choice(dlg, -1,
										  choices=self.observers_ab.values())
			dlg.observer_ctrl.Bind(wx.EVT_CHOICE, check_last_ccxx_ti3)
			hsizer.Add(dlg.observer_ctrl,
					   flag=wx.LEFT | wx.ALIGN_CENTER_VERTICAL, border=8)
			dlg.observer_ctrl.SetStringSelection(
				self.observers_ab[getcfg("colorimeter_correction.observer")])
			def show_observer_ctrl():
				instrument_name = dlg.instrument.GetStringSelection()
				show = bool(getcfg("show_advanced_options") and
							self.worker.instrument_can_use_nondefault_observer(instrument_name) and
							getcfg("colorimeter_correction.observer") != defaults["colorimeter_correction.observer"])
				dlg.observer_label.Show(show)
				dlg.observer_ctrl.Show(show)
			def instrument_handler(event):
				dlg.Freeze()
				modes = self.get_ccxx_measurement_modes(
					dlg.instrument.GetStringSelection())
				dlg.measurement_mode.SetItems(modes.values())
				dlg.measurement_mode.SetStringSelection(
					modes.get(getcfg("colorimeter_correction.measurement_mode"),
							  modes.values()[-1]))
				dlg.measurement_mode.Enable(len(modes) > 1)
				show_observer_ctrl()
				boxsizer.Layout()
				if event:
					check_last_ccxx_ti3(event)
				dlg.sizer0.SetSizeHints(dlg)
				dlg.sizer0.Layout()
				dlg.Refresh()
				dlg.Thaw()
			instrument = getcfg("colorimeter_correction.instrument")
			if instrument in colorimeters:
				dlg.instrument.SetStringSelection(instrument)
			elif colorimeters:
				dlg.instrument.SetSelection(0)
			else:
				dlg.measurement_mode.Disable()
			if colorimeters:
				instrument_handler(None)
			if len(colorimeters) < 2:
				dlg.instrument.Disable()
			else:
				dlg.instrument.Bind(wx.EVT_CHOICE, instrument_handler)
			# Bind event handlers
			def correction_type_handler(event):
				dlg.Freeze()
				for item in list(boxsizer.Children) + [boxsizer.StaticBox]:
					if isinstance(item, (wx.SizerItem, wx.Window)):
						item.Show(dlg.correction_type_matrix.GetValue())
				show_observer_ctrl()
				set_ok_btn_state()
				dlg.sizer0.SetSizeHints(dlg)
				dlg.sizer0.Layout()
				dlg.Refresh()
				dlg.Thaw()
			dlg.correction_type_matrix.Bind(wx.EVT_RADIOBUTTON,
											correction_type_handler)
			dlg.correction_type_spectral.Bind(wx.EVT_RADIOBUTTON,
											  correction_type_handler)
			# Layout
			check_last_ccxx_ti3(dlg.measurement_mode_reference)
			check_last_ccxx_ti3(dlg.measurement_mode)
			correction_type_handler(None)
			result = dlg.ShowModal()
			if result in (id_measure_reference, id_measure_colorimeter):
				setcfg("colorimeter_correction.instrument.reference",
					   dlg.reference_instrument.GetStringSelection())
				mode, modes, modes_ab, modes_ba = self.get_measurement_modes(
					dlg.reference_instrument.GetStringSelection(), "spect",
					"colorimeter_correction.measurement_mode.reference")
				mode = modes_ab.get("spect", {}).get(
					dlg.measurement_mode_reference.GetSelection()) or "l"
				setcfg("colorimeter_correction.measurement_mode.reference",
					   (strtr(mode, {"V": "", 
									 "H": ""}) if mode else None) or None)
				setcfg("colorimeter_correction.measurement_mode.reference.adaptive",
					   1 if mode and "V" in mode else 0)
				setcfg("colorimeter_correction.measurement_mode.reference.highres",
					   1 if mode and "H" in mode else 0)
				setcfg("colorimeter_correction.measurement_mode.reference.projector",
					   1 if mode and "p" in mode else None)
				observer = self.observers_ba.get(dlg.observer_reference_ctrl.GetStringSelection())
				setcfg("colorimeter_correction.observer.reference", observer)
				observer = self.observers_ba.get(dlg.observer_ctrl.GetStringSelection())
				setcfg("colorimeter_correction.observer", observer)
				setcfg("colorimeter_correction.instrument",
					   dlg.instrument.GetStringSelection())
				modes = self.get_ccxx_measurement_modes(
					dlg.instrument.GetStringSelection(), True)
				if dlg.measurement_mode.GetStringSelection() in modes:
					setcfg("colorimeter_correction.measurement_mode",
						   modes[dlg.measurement_mode.GetStringSelection()])
			elif result == wx.ID_OK:
				paths = [getcfg("last_reference_ti3_path")]
				if dlg.correction_type_matrix.GetValue():
					paths.append(getcfg("last_colorimeter_ti3_path"))
			# Restore previous TI3 paths (if any)
			for name in ("colorimeter", "reference"):
				if getcfg("last_%s_ti3_path.backup" % name, False):
					setcfg("last_%s_ti3_path" % name,
						   getcfg("last_%s_ti3_path.backup" % name))
					setcfg("last_%s_ti3_path.backup" % name, None)
			if result != wx.ID_CANCEL:
				setcfg("colorimeter_correction.type",
					   {True: "matrix",
						False: "spectral"}[dlg.correction_type_matrix.GetValue()])
			dlg.Destroy()
		else:
			result = -1
		if result == wx.ID_CANCEL:
			return
		elif result in (id_measure_reference, id_measure_colorimeter):
			# Select CCXX testchart
			ccxx_testchart = get_ccxx_testchart()
			if not ccxx_testchart:
				show_result_dialog(Error(lang.getstr("not_found",
													 lang.getstr("ccxx.ti1"))), self)
				return
			if not is_ccxx_testchart():
				# Backup testchart selection
				setcfg("testchart.file.backup", getcfg("testchart.file"))
			self.set_testchart(ccxx_testchart)
			# Backup instrument selection
			setcfg("comport.number.backup", getcfg("comport.number"))
			# Backup observer
			setcfg("observer.backup", getcfg("observer"))
			if result == id_measure_reference:
				# Switch to reference instrument
				setcfg("comport.number", self.worker.instruments.index(
					getcfg("colorimeter_correction.instrument.reference")) + 1)
				# Set measurement mode
				setcfg("measurement_mode",
					   getcfg("colorimeter_correction.measurement_mode.reference"))
				setcfg("measurement_mode.adaptive",
					   getcfg("colorimeter_correction.measurement_mode.reference.adaptive"))
				setcfg("measurement_mode.highres",
					   getcfg("colorimeter_correction.measurement_mode.reference.highres"))
				setcfg("measurement_mode.projector",
					   getcfg("colorimeter_correction.measurement_mode.reference.projector"))
				# Set observer
				setcfg("observer", getcfg("colorimeter_correction.observer.reference"))
			else:
				# Switch to colorimeter
				setcfg("comport.number", self.worker.instruments.index(
					getcfg("colorimeter_correction.instrument")) + 1)
				# Set measurement mode
				setcfg("measurement_mode",
					   getcfg("colorimeter_correction.measurement_mode"))
				# Set observer
				setcfg("observer", getcfg("colorimeter_correction.observer"))
			self.measure_handler()
			return
		try:
			ccxx_testchart = get_ccxx_testchart()
			if not ccxx_testchart:
				raise Error(lang.getstr("not_found", lang.getstr("ccxx.ti1")))
			ccxx = CGATS.CGATS(ccxx_testchart)
		except (Error, IOError, CGATS.CGATSInvalidError, 
				CGATS.CGATSInvalidOperationError, CGATS.CGATSKeyError, 
				CGATS.CGATSTypeError, CGATS.CGATSValueError), exception:
			show_result_dialog(exception, self)
			return
		cgats_list = []
		reference_ti3 = None
		colorimeter_ti3 = None
		spectral = False
		if getcfg("colorimeter_correction.type") == "matrix":
			ti3_range = (0, 1)
		else:
			ti3_range = (0, )
		for n in xrange(len(paths or ti3_range)):
			path = None
			if not paths:
				if reference_ti3:
					defaultDir, defaultFile = get_verified_path("last_colorimeter_ti3_path")
					msg = lang.getstr("measurement_file.choose.colorimeter")
				else:
					defaultDir, defaultFile = get_verified_path("last_reference_ti3_path")
					msg = lang.getstr("measurement_file.choose.reference")
				dlg = wx.FileDialog(parent, 
									msg,
									defaultDir=defaultDir,
									defaultFile=defaultFile,
									wildcard=lang.getstr("filetype.ti3") +
											 "|*.ti3;*.icm;*.icc", 
									style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
				dlg.Center(wx.BOTH)
				if dlg.ShowModal() == wx.ID_OK:
					path = dlg.GetPath()
				dlg.Destroy()
			else:
				path = paths[n]
			if path:
				try:
					if os.path.splitext(path.lower())[1] in (".icm", ".icc"):
						profile = ICCP.ICCProfile(path)
						meta = profile.tags.get("meta", {})
						cgats = self.worker.ti1_lookup_to_ti3(ccxx, profile,
															  pcs="x",
															  intent="a")[1]
						cgats.add_keyword("DATA_SOURCE",
										  meta.get("DATA_source",
												   {}).get("value",
														   "").upper() or
										  "Unknown")
						if cgats.DATA_SOURCE == "EDID":
							instrument = "EDID"
						else:
							targ = profile.tags.get("CIED",
													profile.tags.get("targ", ""))
							instrument = None
							if targ[0:4] == "CTI3":
								targ = CGATS.CGATS(targ)
								instrument = targ.queryv1("TARGET_INSTRUMENT")
							if not instrument:
								instrument = meta.get("MEASUREMENT_device",
													  {}).get("value",
															  "Unknown")
						cgats.add_keyword("TARGET_INSTRUMENT", instrument)
						spectral = "YES" if instruments.get(get_canonical_instrument_name(cgats.TARGET_INSTRUMENT),
															{}).get("spectral", False) else "NO"
						cgats.add_keyword("INSTRUMENT_TYPE_SPECTRAL", spectral)
						cgats.ARGYLL_COLPROF_ARGS = CGATS.CGATS()
						cgats.ARGYLL_COLPROF_ARGS.key = "ARGYLL_COLPROF_ARGS"
						cgats.ARGYLL_COLPROF_ARGS.parent = cgats
						cgats.ARGYLL_COLPROF_ARGS.root = cgats
						cgats.ARGYLL_COLPROF_ARGS.type = "SECTION"
						display = meta.get("EDID_model",
										   meta.get("EDID_model_id",
													{})).get("value",
															 "").encode("UTF-7")
						manufacturer = meta.get("EDID_manufacturer",
											    {}).get("value",
													    "").encode("UTF-7")
						cgats.ARGYLL_COLPROF_ARGS.add_data('-M "%s" -A "%s"' %
														   (display,
															manufacturer))
						cgats = CGATS.CGATS(str(cgats))
					else:
						cgats = CGATS.CGATS(path)
					if not cgats.queryv1("DATA"):
						raise CGATS.CGATSError("Missing DATA")
				except Exception, exception:
					safe_print(exception)
					InfoDialog(self,
							   title=lang.getstr("colorimeter_correction.create"),
							   msg=lang.getstr("error.measurement.file_invalid", path), 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
				else:
					cgats_list.append(cgats)
					# Check if measurement contains spectral values
					# Check if instrument type is spectral
					if (cgats.queryv1("SPECTRAL_BANDS") or
						cgats.queryv1("DATA_SOURCE") == "EDID"):
						if reference_ti3:
							# We already have a reference ti3
							reference_ti3 = None
							break
						reference_ti3 = cgats
						setcfg("last_reference_ti3_path", path)
						if cgats.queryv1("SPECTRAL_BANDS"):
							spectral = True
							if (event and
								getcfg("colorimeter_correction.type") == "matrix"):
								result = -1
							else:
								result = wx.ID_OK
							if result == wx.ID_OK:
								break
							elif result == wx.ID_CANCEL:
								return
					elif cgats.queryv1("INSTRUMENT_TYPE_SPECTRAL") == "YES":
						if reference_ti3:
							# We already have a reference ti3
							reference_ti3 = None
							break
						reference_ti3 = cgats
						setcfg("last_reference_ti3_path", path)
					elif cgats.queryv1("INSTRUMENT_TYPE_SPECTRAL") == "NO":
						if colorimeter_ti3:
							# We already have a colorimeter ti3
							colorimeter_ti3 = None
							break
						colorimeter_ti3 = cgats
						setcfg("last_colorimeter_ti3_path", path)
			else:
				# User canceled dialog
				return
		# Check if atleast one file has been measured with a reference
		if not reference_ti3:
			InfoDialog(self,
					   title=lang.getstr("colorimeter_correction.create"),
					   msg=lang.getstr("error.measurement.one_reference"), 
					   ok=lang.getstr("ok"), 
					   bitmap=geticon(32, "dialog-error"))
			return
		if event:
			cfgname = "colorimeter_correction.measurement_mode"
		else:
			cfgname = "measurement_mode"
		if len(cgats_list) == 2:
			if not colorimeter_ti3:
				# If 2 files, check if atleast one file has NOT been measured 
				# with a spectro (CCMX creation)
				InfoDialog(self,
						   title=lang.getstr("colorimeter_correction.create"),
						   msg=lang.getstr("error.measurement.one_colorimeter"), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
			# Use only the device combinations from CCXX testchart
			reference_new = CGATS.CGATS("BEGIN_DATA\nEND_DATA")
			reference_new.DATA_FORMAT = reference_ti3.queryv1("DATA_FORMAT")
			colorimeter_new = CGATS.CGATS("BEGIN_DATA\nEND_DATA")
			colorimeter_new.DATA_FORMAT = colorimeter_ti3.queryv1("DATA_FORMAT")
			data_reference = reference_ti3.queryv1("DATA")
			data_colorimeter = colorimeter_ti3.queryv1("DATA")
			required = ccxx.queryv(("RGB_R", "RGB_G", "RGB_B"))
			devicecombination2name = {"RGB_R=100 RGB_G=100 RGB_B=100": "white",
									  "RGB_R=100 RGB_G=0 RGB_B=0": "red",
									  "RGB_R=0 RGB_G=100 RGB_B=0": "green",
									  "RGB_R=0 RGB_G=0 RGB_B=100": "blue"}
			for i, values in required.iteritems():
				patch = OrderedDict([("RGB_R", values[0]),
									 ("RGB_G", values[1]),
									 ("RGB_B", values[2])])
				devicecombination = " ".join(["=".join([key, "%i" % value])
											  for key, value in
											  patch.iteritems()])
				name = devicecombination2name.get(devicecombination,
												  devicecombination)
				item = data_reference.queryi1(patch)
				if item:
					reference_new.DATA.add_data(item)
				else:
					show_result_dialog(lang.getstr("error.testchart.missing_fields", 
									   (os.path.basename(reference_ti3.filename),
										lang.getstr(name))))
					return
				item = data_colorimeter.queryi1(patch)
				if item:
					colorimeter_new.DATA.add_data(item)
				else:
					show_result_dialog(lang.getstr("error.testchart.missing_fields", 
									   (os.path.basename(colorimeter_ti3.filename),
									    lang.getstr(name))))
					return
			reference_ti3.queryi1("DATA").DATA = reference_new.DATA
			colorimeter_ti3.queryi1("DATA").DATA = colorimeter_new.DATA
			# If the reference comes from EDID, normalize luminance
			if reference_ti3.queryv1("DATA_SOURCE") == "EDID":
				white = colorimeter_ti3.queryi1("DATA").queryi1({"RGB_R": 100,
																 "RGB_G": 100,
																 "RGB_B": 100})
				if luminance:
					scale = luminance / 100.0
				else:
					scale = 1.0
				white = " ".join([str(v) for v in (white["XYZ_X"] * scale,
												   white["XYZ_Y"] * scale,
												   white["XYZ_Z"] * scale)])
				colorimeter_ti3.queryi1("DATA").LUMINANCE_XYZ_CDM2 = white
			# Add display base ID if missing
			self.worker.check_add_display_type_base_id(colorimeter_ti3, cfgname)
		elif not spectral:
			# If 1 file, check if it contains spectral values (CCSS creation)
			InfoDialog(self,
					   title=lang.getstr("colorimeter_correction.create"),
					   msg=lang.getstr("error.measurement.missing_spectral"), 
					   ok=lang.getstr("ok"), 
					   bitmap=geticon(32, "dialog-error"))
			return
		# Add display type
		for cgats in cgats_list:
			if not cgats.queryv1("DISPLAY_TYPE_REFRESH"):
				cgats[0].add_keyword("DISPLAY_TYPE_REFRESH",
									 {"c": "YES",
									  "l": "NO"}.get(getcfg(cfgname),
													 "NO"))
				safe_print("Added DISPLAY_TYPE_REFRESH %r" %
						   cgats[0].DISPLAY_TYPE_REFRESH)
		options_dispcal, options_colprof = get_options_from_ti3(reference_ti3)
		display = None
		manufacturer = None
		manufacturer_display = None
		for option in options_colprof:
			if option.startswith("M"):
				display = option[1:].strip(' "')
			elif option.startswith("A"):
				manufacturer = option[1:].strip(' "')
		if manufacturer:
			quirk_manufacturer = colord.quirk_manufacturer(manufacturer)
		if (manufacturer and display and
			not quirk_manufacturer.lower() in display.lower()):
			manufacturer_display = " ".join([quirk_manufacturer, display])
		elif display:
			manufacturer_display = display
		if len(cgats_list) == 2:
			instrument = colorimeter_ti3.queryv1("TARGET_INSTRUMENT")
			if instrument:
				instrument = safe_unicode(instrument, "UTF-8")
				instrument = get_canonical_instrument_name(instrument)
			description = "%s & %s" % (instrument or 
									   self.worker.get_instrument_name(),
									   manufacturer_display or
									   self.worker.get_display_name(True))
		else:
			description = manufacturer_display or self.worker.get_display_name(True)
		target_instrument = reference_ti3.queryv1("TARGET_INSTRUMENT")
		if target_instrument:
			target_instrument = safe_unicode(target_instrument, "UTF-8")
			target_instrument = get_canonical_instrument_name(target_instrument)
			description = "%s (%s)" % (description, target_instrument)
		args = []
		tech = {"YES": "Unknown"}.get(reference_ti3.queryv1("DISPLAY_TYPE_REFRESH"),
									  "LCD")
		if self.worker.argyll_version >= [1, 7, 1]:
			technology_strings = technology_strings_171
		else:
			technology_strings = technology_strings_170
		if event:
			# Allow user to alter description, display and instrument
			dlg = ConfirmDialog(
				parent, 
				title=lang.getstr("colorimeter_correction.create"),
				msg=lang.getstr("colorimeter_correction.create.details"), 
				ok=lang.getstr("ok"), cancel=lang.getstr("cancel"), 
				bitmap=geticon(32, "dialog-information"))
			boxsizer = wx.StaticBoxSizer(wx.StaticBox(dlg, -1,
													  lang.getstr("description")),
										 wx.VERTICAL)
			dlg.sizer3.Add(boxsizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
			if sys.platform not in ("darwin", "win32"):
				boxsizer.Add((1, 8))
			dlg.description_txt_ctrl = wx.TextCtrl(dlg, -1, 
												   description, 
												   size=(400, -1))
			boxsizer.Add(dlg.description_txt_ctrl, 1, 
						 flag=wx.ALL | wx.ALIGN_LEFT | wx.EXPAND, border=4)
			if not display:
				boxsizer = wx.StaticBoxSizer(wx.StaticBox(dlg, -1,
														  lang.getstr("display")),
											 wx.VERTICAL)
				dlg.sizer3.Add(boxsizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
				if sys.platform not in ("darwin", "win32"):
					boxsizer.Add((1, 8))
				dlg.display_txt_ctrl = wx.TextCtrl(dlg, -1, 
												   self.worker.get_display_name(True,
																				True), 
												   size=(400, -1))
				boxsizer.Add(dlg.display_txt_ctrl, 1, 
							 flag=wx.ALL | wx.ALIGN_LEFT | wx.EXPAND, border=4)
			if not manufacturer:
				boxsizer = wx.StaticBoxSizer(wx.StaticBox(dlg, -1,
														  lang.getstr("display.manufacturer")),
											 wx.VERTICAL)
				dlg.sizer3.Add(boxsizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
				if sys.platform not in ("darwin", "win32"):
					boxsizer.Add((1, 8))
				dlg.manufacturer_txt_ctrl = wx.TextCtrl(dlg, -1, 
														self.worker.get_display_edid().get("manufacturer", ""), 
														size=(400, -1))
				boxsizer.Add(dlg.manufacturer_txt_ctrl, 1, 
							 flag=wx.ALL | wx.ALIGN_LEFT | wx.EXPAND, border=4)
			# Display technology
			boxsizer = wx.StaticBoxSizer(wx.StaticBox(dlg, -1,
													  lang.getstr("display.tech")),
										 wx.VERTICAL)
			dlg.sizer3.Add(boxsizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
			if sys.platform not in ("darwin", "win32"):
				boxsizer.Add((1, 8))
			loctech = {}
			techloc = {}
			for technology_string in technology_strings.values():
				key = technology_string.lower().replace(" ", "_")
				loc = lang.getstr(key)
				if loc == key:
					loc = technology_string
				loctech[loc] = technology_string
				techloc[technology_string] = loc
			dlg.display_tech_ctrl = wx.Choice(dlg, -1,
											  choices=sorted(loctech.keys()))
			dlg.display_tech_ctrl.SetStringSelection(techloc[tech])
			boxsizer.Add(dlg.display_tech_ctrl,
						 flag=wx.ALL | wx.ALIGN_LEFT | wx.EXPAND, border=4)
			dlg.description_txt_ctrl.SetFocus()
			dlg.sizer0.SetSizeHints(dlg)
			dlg.sizer0.Layout()
			dlg.Center()
			result = dlg.ShowModal()
			description = safe_str(dlg.description_txt_ctrl.GetValue().strip(),
								   "UTF-8")
			if not display:
				display = dlg.display_txt_ctrl.GetValue()
			if (dlg.display_tech_ctrl.IsEnabled() and
				dlg.display_tech_ctrl.GetStringSelection()):
				tech = loctech[dlg.display_tech_ctrl.GetStringSelection()]
			if not manufacturer:
				manufacturer = dlg.manufacturer_txt_ctrl.GetValue()
			dlg.Destroy()
		else:
			result = wx.ID_OK
			description += " AUTO"
		args.extend(["-E", description])
		if display:
			args.extend(["-I", safe_str(display.strip(), "UTF-8")])
		ccxxmake_version = get_argyll_version("ccxxmake")
		if reference_ti3 and (not colorimeter_ti3 or
							  ccxxmake_version >= [1, 7]):
			if ccxxmake_version >= [1, 7]:
				args.extend(["-t", dict((v, k) for k, v in
										technology_strings.iteritems())[tech]])
			else:
				args.extend(["-T", safe_str(tech, "UTF-8")])
		if result != wx.ID_OK:
			return
		# Prepare our files
		cwd = self.worker.create_tempdir()
		ti3_tmp_names = []
		if reference_ti3:
			reference_ti3.write(os.path.join(cwd, 'reference.ti3'))
			ti3_tmp_names.append('reference.ti3')
		if colorimeter_ti3:
			# Create CCMX
			colorimeter_ti3.write(os.path.join(cwd, 'colorimeter.ti3'))
			ti3_tmp_names.append('colorimeter.ti3')
			name = "correction"
			ext = ".ccmx"
			# CCSS-capable instruments enable creating a CCMX that maps from
			# non-standard observer A used for the colorimeter measurements
			# to non-standard observer B used for the reference measurements.
			# To get correct readings (= matching reference observer B) when
			# using such a CCMX, observer A needs to be used, not observer B.
			observer = colorimeter_ti3.queryv1("OBSERVER")
			reference_observer = reference_ti3.queryv1("OBSERVER")
		else:
			# Create CCSS
			args.append("-S")
			name = "calibration"
			ext = ".ccss"
			observer = None
			reference_observer = None
		args.append("-f")
		args.append(",".join(ti3_tmp_names))
		args.append(name + ext)
		result = self.worker.create_ccxx(args, cwd)
		source = os.path.join(self.worker.tempdir, name + ext)
		if isinstance(result, Exception):
			show_result_dialog(result, self)
		elif result and os.path.isfile(source):
			# Important: Do not use parsed CGATS, order of keywords may be 
			# different than raw data so MD5 will be different
			try:
				cgatsfile = open(source, "rb")
			except Exception, exception:
				show_result_dialog(exception, self)
				self.worker.wrapup(False)
				return
			cgats = universal_newlines(cgatsfile.read())
			cgatsfile.close()
			if (reference_ti3[0].get("TARGET_INSTRUMENT") and
				not re.search('\nREFERENCE\s+".+?"\n', cgats)):
				# By default, CCSS files don't contain reference instrument
				cgats = re.sub('(\nDISPLAY\s+"[^"]*"\n)',
							   '\nREFERENCE "%s"\\1' %
							   reference_ti3[0].get("TARGET_INSTRUMENT"), cgats)
			if not re.search('\nTECHNOLOGY\s+".+?"\n', cgats) and tech:
				# By default, CCMX files don't contain technology string
				cgats = re.sub('(\nDISPLAY\s+"[^"]*"\n)',
							   '\nTECHNOLOGY "%s"\\1' %
							   safe_str(tech, "UTF-8"), cgats)
			manufacturer_id = None
			if manufacturer:
				if not pnpidcache:
					# Populate pnpidcache
					get_manufacturer_name("???")
				manufacturers = dict([name, id] for id, name in
									 pnpidcache.iteritems())
				manufacturer_id = manufacturers.get(manufacturer)
			if manufacturer_id and not re.search('\nMANUFACTURER_ID\s+".+?"\n',
												 cgats):
				# By default, CCMX/CCSS files don't contain manufacturer ID
				cgats = re.sub('(\nDISPLAY\s+"[^"]*"\n)',
							   '\nMANUFACTURER_ID "%s"\\1' %
							   safe_str(manufacturer_id, "UTF-8"), cgats)
			if manufacturer and not re.search('\nMANUFACTURER\s+".+?"\n', cgats):
				# By default, CCMX/CCSS files don't contain manufacturer
				cgats = re.sub('(\nDISPLAY\s+"[^"]*"\n)',
							   '\nMANUFACTURER "%s"\\1' %
							   safe_str(manufacturer, "UTF-8"), cgats)
			if observer and not re.search('\nOBSERVER\s+".+?"\n', cgats):
				# By default, CCMX/CCSS files don't contain observer
				cgats = re.sub('(\nDISPLAY\s+"[^"]*"\n)',
							   '\nOBSERVER "%s"\\1' %
							   safe_str(observer, "UTF-8"), cgats)
			if (reference_observer and
				not re.search('\nREFERENCE_OBSERVER\s+".+?"\n', cgats)):
				# By default, CCMX/CCSS files don't contain observer
				cgats = re.sub('(\nDISPLAY\s+"[^"]*"\n)',
							   '\nREFERENCE_OBSERVER "%s"\\1' %
							   safe_str(reference_observer, "UTF-8"), cgats)
			result = check_create_dir(config.get_argyll_data_dir())
			if isinstance(result, Exception):
				show_result_dialog(result, self)
				self.worker.wrapup(False)
				return
			if event:
				if colorimeter_ti3:
					# CCMX
					# Show reference vs corrected colorimeter values along with
					# delta E
					matrix = colormath.Matrix3x3()
					ccmx = CGATS.CGATS(cgats)
					for i, sample in ccmx.queryv1("DATA").iteritems():
						matrix.append([])
						for component in "XYZ":
							matrix[i].append(sample["XYZ_%s" % component])
					dlg = ConfirmDialog(parent,
										msg=lang.getstr("colorimeter_correction.create.success"),
										ok=lang.getstr("save"),
										cancel=lang.getstr("testchart.discard"),
										bitmap=geticon(32, "dialog-information"))
					sizer = wx.BoxSizer(wx.HORIZONTAL)
					dlg.sizer3.Add(sizer, 1, flag=wx.TOP | wx.EXPAND, border=12)
					labels = ("%s (%s)" % (get_canonical_instrument_name(
											reference_ti3.queryv1("TARGET_INSTRUMENT") or
											lang.getstr("instrument")),
										   lang.getstr("reference")),
							  "%s (%s)" % (get_canonical_instrument_name(
											ccmx.queryv1("INSTRUMENT") or
											lang.getstr("instrument")),
										   lang.getstr("corrected")))
					scale = getcfg("app.dpi") / config.get_default_dpi()
					if scale < 1:
						scale = 1
					for i, label in enumerate(labels):
						txt = wx.StaticText(dlg, -1, label, size=(80 * scale * (3 + i),
																  -1),
											style=wx.ALIGN_CENTER_HORIZONTAL)
						font = txt.Font
						font.SetWeight(wx.BOLD)
						txt.Font = font
						sizer.Add(txt, flag=wx.LEFT, border=40)
					if "gtk3" in wx.PlatformInfo:
						style = wx.BORDER_SIMPLE
					else:
						style = wx.BORDER_THEME
					grid = CustomGrid(dlg, -1, size=(640 * scale + wx.SystemSettings_GetMetric(wx.SYS_VSCROLL_X),
												     -1), style=style)
					grid.Size = grid.Size[0], grid.GetDefaultRowSize() * 4
					dlg.sizer3.Add(grid, flag=wx.TOP | wx.ALIGN_LEFT, border=4)
					grid.DisableDragColSize()
					grid.DisableDragRowSize()
					grid.SetCellHighlightPenWidth(0)
					grid.SetCellHighlightROPenWidth(0)
					grid.SetColLabelSize(grid.GetDefaultRowSize())
					grid.SetDefaultCellAlignment(wx.ALIGN_CENTER, wx.ALIGN_CENTER)
					grid.SetMargins(0, 0)
					grid.SetRowLabelAlignment(wx.ALIGN_RIGHT, wx.ALIGN_CENTER)
					grid.SetRowLabelSize(40)
					grid.SetScrollRate(0, 5)
					grid.draw_horizontal_grid_lines = False
					grid.draw_vertical_grid_lines = False
					grid.EnableEditing(False)
					grid.EnableGridLines(False)
					grid.CreateGrid(0, 9)
					for i, label in enumerate(["x", "y", "Y", "", "", "x", "y",
											   "Y", u"ΔE*00"]):
						if i in (3, 4):
							# Rectangular (width = height)
							size = grid.GetDefaultRowSize()
						else:
							size = 80 * scale
						grid.SetColSize(i, size)
						grid.SetColLabelValue(i, label)
					grid.BeginBatch()
					white_abs = []
					for j, meas in enumerate((reference_ti3,
											  colorimeter_ti3)):
						# Get absolute whitepoint
						white = (meas.queryv1("LUMINANCE_XYZ_CDM2") or
								 colormath.get_whitepoint("D65", scale=100))
						if isinstance(white, basestring):
							white = [float(v) for v in white.split()]
						white_abs.append(white)
					white_ref = [v / white_abs[0][1] for v in white_abs[0]]
					ref_data = reference_ti3.queryv1("DATA")
					tgt_data = colorimeter_ti3.queryv1("DATA")
					for i, ref in ref_data.iteritems():
						tgt = tgt_data[i]
						grid.AppendRows(1)
						row = grid.GetNumberRows() - 1
						grid.SetRowLabelValue(row, "%d" % ref.SAMPLE_ID)
						XYZ = []
						XYZabs = []
						for j, sample in enumerate((ref, tgt)):
							# Get samples
							XYZ.append([])
							for component in "XYZ":
								XYZ[j].append(sample["XYZ_%s" % component])
							# Scale to absolute brightness
							XYZabs.append(list(XYZ[j]))
							for k, value in enumerate(XYZabs[j]):
								XYZabs[j][k] = value * white_abs[j][1] / 100.0
							if j == 1:
								# Apply matrix to colorimeter measurements
								XYZabs[j] = matrix * XYZabs[j]
							# Set cell values
							for k, value in enumerate(colormath.XYZ2xyY(*XYZabs[j])):
								grid.SetCellValue(row, j * 5 + k, "%.4f" % value)
							# Show sRGB approximation of measured patch
							X, Y, Z = [v / max(white_abs[0][1],
											   (matrix * white_abs[1])[1])
									   for v in XYZabs[j]]
							# Adapt from reference white to D65
							X, Y, Z = colormath.adapt(X, Y, Z, white_ref, "D65")
							# Convert XYZ to sRGB
							RGB = [int(round(v)) for v in
								   colormath.XYZ2RGB(X, Y, Z, scale=255)]
							grid.SetCellBackgroundColour(row, 3 + j, wx.Colour(*RGB))
						if debug or verbose > 1:
							safe_print("ref %.6f %.6f %.6f, " % tuple(XYZabs[0]),
									   "col %.6f %.6f %.6f" % tuple(XYZabs[1]))
						Lab_ref = colormath.XYZ2Lab(*XYZabs[0] + [white_abs[0]])
						Lab_tgt = colormath.XYZ2Lab(*XYZabs[1] + [white_abs[0]])
						if debug or verbose > 1:
							safe_print("ref Lab %.6f %.6f %.6f, " % Lab_ref,
									   "col Lab %.6f %.6f %.6f" % Lab_tgt)
						grid.SetCellValue(row, 8, "%.4f" %
												  colormath.delta(*Lab_ref +
																  Lab_tgt +
																  ("00", ))["E"])
					grid.DefaultCellBackgroundColour = grid.LabelBackgroundColour
					grid.EndBatch()
					dlg.sizer0.SetSizeHints(dlg)
					dlg.sizer0.Layout()
					if dlg.ShowModal() != wx.ID_OK:
						self.worker.wrapup(False)
						return
				if colorimeter_correction_check_overwrite(self, cgats, True):
					self.upload_colorimeter_correction(cgats)
			else:
				path = get_cgats_path(cgats)
				with open(path, "wb") as cgatsfile:
					cgatsfile.write(cgats)
				setcfg("colorimeter_correction_matrix_file", ":" + path)
		elif result is not None:
			InfoDialog(self,
					   title=lang.getstr("colorimeter_correction.create"),
					   msg=lang.getstr("colorimeter_correction.create.failure") +
						   "\n" + "\n".join(self.worker.errors), 
					   ok=lang.getstr("cancel"), 
					   bitmap=geticon(32, "dialog-error"))
		self.worker.wrapup(False)
		return True
	
	def upload_colorimeter_correction(self, cgats):
		""" Ask the user if he wants to upload a colorimeter correction
		to the online database. Upload the file. """
		dlg = ConfirmDialog(self, 
							msg=lang.getstr("colorimeter_correction.upload.confirm"), 
							ok=lang.getstr("ok"), 
							cancel=lang.getstr("cancel"), 
							bitmap=geticon(32, "dialog-information"))
		result = dlg.ShowModal()
		dlg.Destroy()
		if result == wx.ID_OK:
			params = {"cgats": cgats}
			# Upload correction
			self.worker.interactive = False
			self.worker.start(lambda result: result, 
							  upload_colorimeter_correction, 
							  wargs=(self, params),
							  progress_msg=lang.getstr("colorimeter_correction.upload"),
							  stop_timers=False, cancelable=False,
							  show_remaining_time=False, fancy=False)
	
	def upload_colorimeter_correction_handler(self, event):
		""" Let user choose a ccss/ccmx file to upload """
		path = None
		defaultDir, defaultFile = get_verified_path("last_filedialog_path")
		dlg = wx.FileDialog(self, 
							lang.getstr("colorimeter_correction_matrix_file.choose"),
							defaultDir=defaultDir,
							defaultFile=defaultFile,
							wildcard=lang.getstr("filetype.ccmx") + 
									 "|*.ccmx;*.ccss", 
							style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
		dlg.Center(wx.BOTH)
		if dlg.ShowModal() == wx.ID_OK:
			path = dlg.GetPath()
		dlg.Destroy()
		if path:
			setcfg("last_filedialog_path", path)
			# Important: Do not use parsed CGATS, order of keywords may be 
			# different than raw data so MD5 will be different
			cgatsfile = open(path, "rb")
			cgats = cgatsfile.read()
			cgatsfile.close()
			originator = re.search('\nORIGINATOR\s+"Argyll', cgats)
			if not originator:
				InfoDialog(self,
						   msg=lang.getstr("colorimeter_correction.upload.deny"), 
						   ok=lang.getstr("cancel"), 
						   bitmap=geticon(32, "dialog-error"))
			else:
				self.upload_colorimeter_correction(cgats)

	def comport_ctrl_handler(self, event=None, force=False):
		if debug and event:
			safe_print("[D] comport_ctrl_handler called for ID %s %s event "
					   "type %s %s" % (event.GetId(), 
									   getevtobjname(event, self), 
									   event.GetEventType(), 
									   getevttype(event)))
		if self.comport_ctrl.GetSelection() > -1:
			setcfg("comport.number", self.comport_ctrl.GetSelection() + 1)
		self.menuitem_calibrate_instrument.Enable(
			bool(self.worker.get_instrument_features().get("sensor_cal")))
		self.update_measurement_modes()
		self.update_colorimeter_correction_matrix_ctrl()
		self.update_colorimeter_correction_matrix_ctrl_items(force)
	
	def import_colorimeter_corrections_handler(self, event, paths=None,
											   callafter=None,
											   callafter_args=()):
		"""
		Convert correction matrices from other profiling softwares to Argyll's
		CCMX or CCSS format (or to spyd4cal.bin in case of the Spyder4/5)
		
		Currently supported: iColor Display (native import to CCMX),
							 i1 Profiler (import to CCSS via Argyll CMS >= 1.3.4)
							 Spyder4/5 (import to spyd4cal.bin via Argyll CMS >= 1.3.6)
		
		"""
		msg = " ".join([lang.getstr("oem.import.auto"),
						lang.getstr("oem.import.auto.download_selection")])
		if sys.platform == "win32":
			msg = " ".join([lang.getstr("oem.import.auto_windows"), msg])
		result = None
		i1d3 = None
		i1d3ccss = None
		spyd4 = None
		spyd4en = None
		icd = None
		oeminst = get_argyll_util("oeminst")
		importers = OrderedDict()
		if not oeminst:
			i1d3ccss = get_argyll_util("i1d3ccss")
			spyd4en = get_argyll_util("spyd4en")
		dlg = ConfirmDialog(self, title=lang.getstr("colorimeter_correction.import"),
							msg=msg,
							ok=lang.getstr("auto"),
							cancel=lang.getstr("cancel"),
							bitmap=geticon(32, "dialog-information"),
							alt=lang.getstr("file.select"))
		dlg.sizer3.Add((1, 8))
		def check_importers(event):
			result = False
			for name in ("i1d3", "icd", "spyd4"):
				if getattr(dlg, name).IsChecked():
					result = True
					break
			dlg.ok.Enable(result)
		for (name, desc, instruments,
			 importer) in [("i1d3", "i1 Profiler",
							("i1 DisplayPro, ColorMunki Display",
							  "Spyder4", "Spyder5"), i1d3ccss or oeminst),
							("icd", "iColor Display",
							 ("DTP94", "i1 Display 2", "Spyder2",
							  "Spyder3"), True),
							("spyd4", "Spyder4/5", ("Spyder4", "Spyder5"),
							 spyd4en or oeminst)]:
			if importer:
				for instrument in instruments:
					if instrument not in desc:
						desc += " (%s)" % ", ".join(instruments)
						break
				setattr(dlg, name, wx.CheckBox(dlg, -1, desc))
				for instrument in instruments:
					if instruments == ("i1 DisplayPro, ColorMunki Display",
									   "Spyder4", "Spyder5"):
						check = "" in self.ccmx_instruments.itervalues()
					elif instruments == ("Spyder4", "Spyder5"):
						check = self.worker.spyder4_cal_exists()
					else:
						check = instrument in self.ccmx_instruments.itervalues()
					if instrument in self.worker.instruments and not check:
						getattr(dlg, name).SetValue(True)
						break
				dlg.sizer3.Add(getattr(dlg, name), flag=wx.TOP |
														wx.ALIGN_LEFT,
								   border=8)
				getattr(dlg, name).Bind(wx.EVT_CHECKBOX, check_importers)
		dlg.install_user = wx.RadioButton(dlg, -1, lang.getstr("install_user"), 
										  style=wx.RB_GROUP)
		dlg.install_user.SetValue(True)
		dlg.sizer3.Add(dlg.install_user, flag=wx.TOP | wx.ALIGN_LEFT, border=16)
		dlg.install_systemwide = wx.RadioButton(dlg, -1,
												lang.getstr("install_local_system"))
		dlg.install_user.Bind(wx.EVT_RADIOBUTTON, install_scope_handler)
		dlg.install_systemwide.Bind(wx.EVT_RADIOBUTTON,
									install_scope_handler)
		install_scope_handler(dlg=dlg)
		check_importers(None)
		dlg.sizer3.Add(dlg.install_systemwide, flag=wx.TOP | wx.ALIGN_LEFT,
					   border=4)
		dlg.sizer0.SetSizeHints(dlg)
		dlg.sizer0.Layout()
		if event:
			choice = dlg.ShowModal()
		elif paths:
			choice = wx.ID_ANY
		else:
			choice = wx.ID_OK
		for name, importer in [("i1d3", i1d3ccss or oeminst),
							   ("spyd4", spyd4en or oeminst),
							   ("icd", True)]:
			if importer and getattr(dlg, name).GetValue():
				importers[name] = importer
		asroot = dlg.install_systemwide.GetValue()
		dlg.Destroy()
		if choice == wx.ID_CANCEL:
			return
		if choice != wx.ID_OK and not paths:
			dlg = wx.FileDialog(self, 
								lang.getstr("colorimeter_correction.import.choose"),
								wildcard=lang.getstr("filetype.any") + 
										 "|*.cab;*.edr;*.exe;*.txt", 
								style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
			dlg.Center(wx.BOTH)
			choice2 = dlg.ShowModal()
			paths = [dlg.GetPath()]
			dlg.Destroy()
			if choice2 != wx.ID_OK:
				return
		elif not paths:
			paths = []
		if asroot:
			result = self.worker.authenticate(oeminst or i1d3ccss or spyd4en,
											  lang.getstr("colorimeter_correction.import"),
											  self)
			if result not in (True, None):
				if isinstance(result, Exception):
					show_result_dialog(result, self)
				return
		self.worker.interactive = False
		self.worker.start(self.import_colorimeter_corrections_consumer,
						  self.import_colorimeter_corrections_producer,
						  cargs=(callafter, callafter_args),
						  wargs=(result, i1d3, i1d3ccss, spyd4, spyd4en, icd,
								 oeminst, paths, choice == wx.ID_OK, asroot,
								 importers),
						  progress_msg=lang.getstr("colorimeter_correction.import"),
						  fancy=False)
		return (event and None) or True
	
	def import_colorimeter_correction(self, result, i1d3, i1d3ccss, spyd4,
									  spyd4en, icd, oeminst, path, asroot):
		""" Import colorimter correction(s) from path """
		if debug:
			safe_print("import_colorimeter_correction <-")
			safe_print("   result:", result)
			safe_print("   i1d3:", i1d3)
			safe_print("   i1d3ccss:", i1d3ccss)
			safe_print("   spyd4:", spyd4)
			safe_print("   spyd4en:", spyd4en)
			safe_print("   icd:", icd)
			safe_print("   oeminst:", oeminst)
			safe_print("   path:", path)
			safe_print("   asroot:", asroot)
		if path and os.path.exists(path):
			filename, ext = os.path.splitext(path)
			kind = None
			if ext.lower() == ".txt":
				kind = "icd"
				result = True
			else:
				icolordisplay = "icolordisplay" in os.path.basename(path).lower()
				if ext.lower() == ".dmg":
					if icolordisplay:
						kind = "icd"
						result = self.worker.exec_cmd(which("hdiutil"),
													  ["attach", path],
													  capture_output=True,
													  skip_scripts=True)
						if result and not isinstance(result, Exception):
							for path in glob.glob(os.path.join(os.path.sep,
															   "Volumes",
															   "iColorDisplay*",
															   "iColorDisplay*.app",
															   "Contents",
															   "Resources",
															   "DeviceCorrections.txt")):
								break
							else:
								result = Error(lang.getstr("file.missing",
														   "DeviceCorrections.txt"))
				elif i1d3ccss and ext.lower() == ".edr":
					kind = "xrite"
				elif ext.lower() in (".cab", ".exe"):
					if icolordisplay:
						kind = "icd"
						sevenzip = get_program_file("7z", "7-zip")
						if sevenzip:
							if not getcfg("dry_run"):
								# Extract from NSIS installer
								temp = self.worker.create_tempdir()
								if isinstance(temp, Exception):
									result = temp
								else:
									result = self.worker.exec_cmd(sevenzip,
																  ["e", "-y",
																   path,
																   "DeviceCorrections.txt"],
																  capture_output=True,
																  skip_scripts=True,
																  working_dir=temp)
									if (result and
										not isinstance(result, Exception)):
										path = os.path.join(temp,
															"DeviceCorrections.txt")
									else:
										self.worker.wrapup(False)
						else:
							result = Error(lang.getstr("file.missing",
													   "7z" + exe_ext))
					elif i1d3ccss and ("colormunki" in
									   os.path.basename(path).lower() or
									   "i1profiler" in
									   os.path.basename(path).lower() or
									   os.path.basename(path).lower() == "i1d3"):
						# Assume X-Rite installer
						kind = "xrite"
					elif spyd4en and ("spyder4" in
									  os.path.basename(path).lower() or
									  os.path.basename(path).lower() == "spyd4"):
						# Assume Spyder4/5
						kind = "spyder4"
			if kind == "icd":
				if (not getcfg("dry_run") and result and
					not isinstance(result, Exception)):
					# Assume iColorDisplay DeviceCorrections.txt
					ccmx_dir = config.get_argyll_data_dir()
					if not os.path.exists(ccmx_dir):
						result = check_create_dir(ccmx_dir)
						if isinstance(result, Exception):
							return result, i1d3, spyd4, icd
					safe_print(lang.getstr("colorimeter_correction.import"))
					safe_print(path)
					try:
						imported, skipped = ccmx.convert_devicecorrections_to_ccmx(path, ccmx_dir)
						if imported == 0:
							raise Info()
					except (UnicodeDecodeError,
							demjson.JSONDecodeError), exception:
						if isinstance(exception, demjson.JSONDecodeError):
							exception = exception.pretty_description()
						result = Error(lang.getstr("file.invalid") + "\n" +
									   safe_unicode(exception))
					except Info:
						result = False
					except Exception, exception:
						result = exception
					else:
						result = icd = True
						if skipped > 0:
							result = Warn(lang.getstr("colorimeter_correction.import.partial_warning",
													  ("iColor Display",
													   skipped,
													   imported + skipped)))
					self.worker.wrapup(False)
			elif kind == "xrite":
				# Import .edr
				if asroot and sys.platform == "win32":
					ccss = self.get_argyll_data_files("l", "*.ccss", True)
				result = i1d3 = self.worker.import_edr([path], asroot=asroot)
				if asroot and sys.platform == "win32":
					result = i1d3 = self.get_argyll_data_files("l", "*.ccss",
															   True) != ccss
			elif kind == "spyder4":
				# Import spyd4cal.bin
				result = spyd4 = self.worker.import_spyd4cal([path],
															 asroot=asroot)
				if asroot and sys.platform == "win32":
					result = spyd4 = self.get_argyll_data_files("l",
																"spyd4cal.bin")
			elif oeminst and not icolordisplay:
				if asroot and sys.platform == "win32":
					ccss = self.get_argyll_data_files("l", "*.ccss", True)
				result = self.worker.import_colorimeter_corrections(oeminst,
																	[path],
																	asroot)
				if (".ccss" in "".join(self.worker.output) or
					(asroot and sys.platform == "win32" and
					 self.get_argyll_data_files("l", "*.ccss", True) != ccss)):
					i1d3 = result
				if ("spyd4cal.bin" in "".join(self.worker.output) or
					(asroot and sys.platform == "win32" and
					 self.get_argyll_data_files("l", "spyd4cal.bin"))):
					spyd4 = result
			else:
				result = Error(lang.getstr("error.file_type_unsupported") +
							   "\n" + path)
		if debug:
			safe_print("import_colorimeter_correction ->")
			safe_print("   result:", result)
			safe_print("   i1d3:", i1d3)
			safe_print("   i1d3ccss:", i1d3ccss)
			safe_print("   spyd4:", spyd4)
			safe_print("   spyd4en:", spyd4en)
			safe_print("   icd:", icd)
			safe_print("   oeminst:", oeminst)
			safe_print("   path:", path)
			safe_print("   asroot:", asroot)
		return result, i1d3, spyd4, icd
	
	def import_colorimeter_corrections_producer(self, result, i1d3, i1d3ccss,
											   spyd4, spyd4en, icd, oeminst,
											   paths, auto, asroot, importers):
		""" Import colorimetercorrections from paths """
		if auto and not paths:
			paths = []
			if importers.get("icd"):
				# Look for iColorDisplay
				if sys.platform == "win32":
					paths += glob.glob(os.path.join(getenvu("PROGRAMFILES", ""),
													"Quato", "iColorDisplay",
													"DeviceCorrections.txt"))
				elif sys.platform == "darwin":
					paths += glob.glob(os.path.join(os.path.sep, "Applications", 
												   "iColorDisplay*.app",
												   "DeviceCorrections.txt"))
					paths += glob.glob(os.path.join(os.path.sep, "Volumes", 
													"iColorDisplay*", 
													"iColorDisplay*.app",
													"DeviceCorrections.txt"))
			if importers.get("i1d3") and (oeminst or i1d3ccss) and not i1d3:
				# Look for *.edr files
				if sys.platform == "win32":
					paths += glob.glob(os.path.join(getenvu("PROGRAMFILES", ""), 
													"X-Rite", "Devices", "i1d3", 
													"Calibrations", "*.edr"))
				elif sys.platform == "darwin":
					paths += glob.glob(os.path.join(os.path.sep, "Library", 
												   "Application Support", "X-Rite", 
												   "Devices", "i1d3xrdevice", 
												   "Contents", "Resources", 
												   "Calibrations", "*.edr"))
					paths += glob.glob(os.path.join(os.path.sep, "Volumes", 
													"i1Profiler", "*.exe"))
					paths += glob.glob(os.path.join(os.path.sep, "Volumes", 
													"ColorMunki Display", "*.exe"))
			if importers.get("spyd4") and (oeminst or spyd4en) and not spyd4:
				# Look for dccmtr.dll
				if sys.platform == "win32":
					paths += glob.glob(os.path.join(getenvu("PROGRAMFILES", ""), 
												   "Datacolor", "Spyder4*", 
												   "dccmtr.dll"))
					paths += glob.glob(os.path.join(getenvu("PROGRAMFILES", ""), 
												   "Datacolor", "Spyder5*", 
												   "dccmtr.dll"))
				elif sys.platform == "darwin":
					# Look for setup.exe on CD-ROM
					paths += glob.glob(os.path.join(os.path.sep, "Volumes", 
												   "Datacolor", "Data",
												   "setup.exe"))
					paths += glob.glob(os.path.join(os.path.sep, "Volumes", 
													"Datacolor_ISO", "Data",
													"setup.exe"))
		for path in paths:
			(result,
			 i1d3,
			 spyd4,
			 icd) = self.import_colorimeter_correction(result, i1d3, i1d3ccss,
													   spyd4, spyd4en, icd,
													   oeminst, path, asroot)
		paths = []
		for name, importer in importers.iteritems():
			imported = locals().get(name, False)
			if not imported and auto:
				# Automatic download
				if name == "icd" and sys.platform == "darwin":
					name += ".dmg"
				self.worker.recent.clear()
				self.worker.lastmsg.clear()
				result = self.worker.download("http://%s/%s" % (domain.lower(),
																name))
				if isinstance(result, Exception):
					break
				elif result:
					paths.append(result)
				else:
					# Cancelled
					result = None
					break
		if not isinstance(result, Exception) and result:
			for path in paths:
				(result,
				 i1d3,
				 spyd4,
				 icd) = self.import_colorimeter_correction(result, i1d3,
														   i1d3ccss, spyd4,
														   spyd4en, icd,
														   oeminst, path,
														   asroot)
		return result, i1d3, spyd4, icd
	
	def import_colorimeter_corrections_consumer(self, results, callafter=None,
												callafter_args=()):
		result, i1d3, spyd4, icd = results
		if isinstance(result, Exception):
			show_result_dialog(result, self)
		imported = []
		failures = []
		mapping = {"i1 Profiler/ColorMunki Display": i1d3,
				   "Spyder4/5": spyd4,
				   "iColor Display": icd}
		for name, subresult in mapping.iteritems():
			if subresult and not isinstance(subresult, Exception):
				imported.append(name)
			elif subresult is not None:
				failures.append(name)
		if imported:
			self.update_measurement_modes()
			self.update_colorimeter_correction_matrix_ctrl_items(True)
			InfoDialog(self,
					   msg=lang.getstr("colorimeter_correction.import.success",
									   "\n".join(imported)), 
					   ok=lang.getstr("ok"), 
					   bitmap=geticon(32, "dialog-information"))
		if failures or (not imported and result is not None):
			error = ("".join(self.worker.errors) or
					 lang.getstr("colorimeter_correction.import.failure") +
					 "\n\n" + "\n".join(failures))
			show_result_dialog(UnloggedError(error), self)
		if callafter:
			wx.CallAfter(callafter, *callafter_args)

	def import_session_archive(self, path):
		""" Import compressed session archive """
		filename, ext = os.path.splitext(path)
		basename = os.path.basename(filename)  # Without extension
		if self.check_overwrite(filename=basename):
			self.worker.start(self.import_session_archive_consumer,
							  self.import_session_archive_producer,
							  cargs=(basename, ), wargs=(path, basename, ext),
							  progress_msg=lang.getstr("archive.import"),
							  fancy=False)

	def import_session_archive_producer(self, path, basename, ext):
		temp = self.worker.create_tempdir()
		if isinstance(temp, Exception):
			return temp
		if ext.lower() == ".7z":
			sevenzip = get_program_file("7z", "7-zip")
			if sevenzip:
				# Extract from 7z archive (flat hierarchy, not using dirnames)
				result = self.worker.exec_cmd(sevenzip,
											  ["e", "-y",
											   path],
											  capture_output=True,
											  log_output=False,
											  skip_scripts=True,
											  working_dir=temp)
				if not result or isinstance(result, Exception):
					return result
				# Check if a session archive
				is_session_archive = False
				for ext in (".icc", ".icm", ".cal"):
					if os.path.isfile(os.path.join(temp, basename + ext)):
						is_session_archive = True
						break
				if not is_session_archive:
					# Doesn't seem to be a session archive
					return Error(lang.getstr("error.not_a_session_archive",
											 os.path.basename(path)))
				if os.path.isdir(os.path.join(temp, basename)):
					# Remove empty directory
					shutil.rmtree(os.path.join(temp, basename))
			else:
				return Error(lang.getstr("file.missing", "7z" + exe_ext))
		else:
			if (path.lower().endswith(".tgz") or
				path.lower().endswith(".tar.gz")):
				# Gzipped TAR archive
				archive = TarFileProper.open(path, "r", encoding="UTF-8")
				getinfo = archive.getmember
				getnames = archive.getnames
			else:
				# ZIP
				archive = zipfile.ZipFile(path, "r")
				getinfo = archive.getinfo
				getnames = archive.namelist
			try:
				with archive:
					# Check if a session archive
					info = None
					for ext in (".icc", ".icm", ".cal"):
						for name in (basename + "/" + basename + ext,
									 basename + ext):
							if isinstance(archive, zipfile.ZipFile):
								# If the ZIP file was created with Unicode
								# names stored in the file, 'name' will already
								# be Unicode. Otherwise, it'll either be 7-bit
								# ASCII or (legacy) cp437 encoding
								names = (name, safe_str(name, "cp437"))
							else:
								# Gzipped TAR archive, assume UTF-8
								names = (safe_str(name, "UTF-8"), )
							for name in names:
								try:
									info = getinfo(name)
								except KeyError:
									continue
								break
							if info:
								break
						if info:
							break
					if not info:
						# Doesn't seem to be a session archive
						return Error(lang.getstr("error.not_a_session_archive",
												 os.path.basename(path)))
					# Extract from archive (flat hierarchy, not using dirnames)
					for name in getnames():
						if not isinstance(archive, zipfile.ZipFile):
							# Gzipped TAR
							archive.extract(name, temp, False)
							continue
						# If the ZIP file was created with Unicode names stored
						# in the file, 'name' will already be Unicode.
						# Otherwise, it'll either be 7-bit ASCII or (legacy)
						# cp437 encoding
						outname = safe_unicode(name, "cp437")
						with open(os.path.join(temp, os.path.basename(outname)),
								  "wb") as outfile:
							outfile.write(archive.read(name))
			except Exception, exception:
				from traceback import format_exc
				safe_print(traceback.format_exc())
				return exception
		return os.path.join(getcfg("profile.save_path"), basename,
							basename + ext)

	def import_session_archive_consumer(self, result, basename):
		if result and not isinstance(result, Exception):
			# Copy to storage folder
			self.worker.wrapup(dst_path=os.path.join(getcfg("profile.save_path"),
													 basename,
													 basename + ".ext"))
			# Load settings from profile
			self.load_cal_handler(None, result)
		else:
			show_result_dialog(result)
			self.worker.wrapup(False)

	def display_ctrl_handler(self, event, load_lut=True,
							 update_ccmx_items=True):
		if debug:
			safe_print("[D] display_ctrl_handler called for ID %s %s event "
					   "type %s %s" % (event.GetId(), 
									   getevtobjname(event, self), 
									   event.GetEventType(), 
									   getevttype(event)))
		display_no = self.display_ctrl.GetSelection()
		profile = None
		if display_no > -1:
			setcfg("display.number", display_no + 1)
			if load_lut:
				profile = get_display_profile(display_no)
				if not getcfg("calibration.file", False):
					# Current
					self.profile_info_btn.Enable(bool(profile))
		if self.display_lut_link_ctrl.IsShown():
			self.display_lut_link_ctrl_handler(CustomEvent(
				wx.EVT_BUTTON.evtType[0], self.display_lut_link_ctrl), 
				bool(int(getcfg("display_lut.link"))))
		if load_lut:
			if debug:
				safe_print("[D] display_ctrl_handler -> lut_viewer_load_lut", 
						   profile.getDescription() if profile else None)
			self.lut_viewer_load_lut(profile=profile)
			if debug:
				safe_print("[D] display_ctrl_handler -> lut_viewer_load_lut END")
		# Check if the selected display is a pattern generator. If so,
		# don't use videoLUT for calibration. Restore previous value
		# when switching back to a display with videoLUT access.
		if config.is_patterngenerator():
			if getcfg("calibration.use_video_lut.backup", False) is None:
				setcfg("calibration.use_video_lut.backup",
					   getcfg("calibration.use_video_lut"))
				setcfg("calibration.use_video_lut", 0)
		elif getcfg("calibration.use_video_lut.backup", False) is not None:
			setcfg("calibration.use_video_lut",
				   getcfg("calibration.use_video_lut.backup"))
			setcfg("calibration.use_video_lut.backup", None)
		update_delay_ctrls = False
		if config.get_display_name() == "Resolve":
			# Special case: Resolve. Needs a minimum display update delay of
			# atleast 600 ms for repeatable measurements. This is a Resolve
			# issue. There seem to be quite a few bugs that were introduced in
			# Resolve via the version 10.1.x to 11.x transition.
			if getcfg("measure.min_display_update_delay_ms.backup", False) is None:
				setcfg("measure.override_min_display_update_delay_ms.backup",
					   getcfg("measure.override_min_display_update_delay_ms"))
				setcfg("measure.min_display_update_delay_ms.backup",
					   getcfg("measure.min_display_update_delay_ms"))
				setcfg("measure.override_min_display_update_delay_ms", 1)
				setcfg("measure.min_display_update_delay_ms", 600)
				update_delay_ctrls = True
		elif getcfg("measure.min_display_update_delay_ms.backup", False) is not None:
			setcfg("measure.override_min_display_update_delay_ms",
				   getcfg("measure.override_min_display_update_delay_ms.backup"))
			setcfg("measure.min_display_update_delay_ms",
				   getcfg("measure.min_display_update_delay_ms.backup"))
			setcfg("measure.override_min_display_update_delay_ms.backup", None)
			setcfg("measure.min_display_update_delay_ms.backup", None)
			update_delay_ctrls = True
		if (config.is_virtual_display() or
			config.get_display_name() == "SII REPEATER"):
			# Enable 3D LUT tab for madVR, Resolve & eeColor
			if getcfg("3dlut.tab.enable.backup", False) is None:
				setcfg("3dlut.tab.enable.backup", getcfg("3dlut.tab.enable"))
			setcfg("3dlut.tab.enable", 1)
		elif (getcfg("3dlut.tab.enable.backup", False) is not None and
			  not getcfg("3dlut.create")):
			setcfg("3dlut.tab.enable", getcfg("3dlut.tab.enable.backup"))
			setcfg("3dlut.tab.enable.backup", None)
		if update_delay_ctrls:
			override = bool(getcfg("measure.override_min_display_update_delay_ms"))
			getattr(self,
					"override_min_display_update_delay_ms").SetValue(override)
			self.update_display_delay_ctrl("min_display_update_delay_ms",
										   override)
		# Check if display is calibratable at all. Unset calibration update
		# checkbox if this is not the case.
		if config.is_uncalibratable_display():
			setcfg("calibration.update", False)
			self.calibration_update_cb.SetValue(False)
		if self.IsShownOnScreen():
			self.update_menus()
		if (update_ccmx_items and
			getcfg("colorimeter_correction_matrix_file").split(":")[0] == "AUTO"):
			self.update_colorimeter_correction_matrix_ctrl_items()
		else:
			self.update_estimated_measurement_times()
		self.update_main_controls()
		if getattr(self, "reportframe", None):
			self.reportframe.update_controls()
		if getattr(self, "lut3dframe", None):
			self.lut3dframe.update_controls()
		##if (event and not isinstance(event, CustomEvent) and
			##not getcfg("calibration.file", False)):
			### Set measurement report dest profile to current
			##setcfg("measurement_report.output_profile",
				   ##get_current_profile_path())
		if not isinstance(event, CustomEvent):
			if config.get_display_name().startswith("Chromecast "):
				# Show a warning re Chromecast limitation
				show_result_dialog(UnloggedWarning(lang.getstr("chromecast_limitations_warning")),
								   parent=self)
			if (config.get_display_name() == "Untethered" and
				getcfg("testchart.file") == "auto"):
				# Untethered does not support auto-optimization
				self.set_testchart()
	
	def display_delay_handler(self, event):
		mapping = {self.override_min_display_update_delay_ms.GetId(): "measure.override_min_display_update_delay_ms",
				   self.min_display_update_delay_ms.GetId(): "measure.min_display_update_delay_ms",
				   self.override_display_settle_time_mult.GetId(): "measure.override_display_settle_time_mult",
				   self.display_settle_time_mult.GetId(): "measure.display_settle_time_mult"}
		pref = mapping.get(event.GetId())
		if pref:
			ctrl = self.FindWindowById(event.GetId())
			value = ctrl.GetValue()
			if ctrl.Name.startswith("override_"):
				self.update_display_delay_ctrl(ctrl.Name[9:], value)
				value = int(value)
			setcfg(pref, value)
		self.update_estimated_measurement_times()

	def update_display_delay_ctrl(self, name, enable):
		spinctrl = getattr(self, name)
		spinctrl.Enable(enable)
		spinvalue = getcfg("measure.%s" % name)
		if not enable:
			# Restore previous environment variable value
			backup = os.getenv("ARGYLL_%s_BACKUP" % name.upper())
			current = os.getenv("ARGYLL_%s" % name.upper())
			if backup or current:
				valuetype = type(defaults["measure.%s" % name])
				try:
					spinvalue = valuetype(backup or current)
				except (TypeError, ValueError):
					pass
		spinctrl.SetValue(spinvalue)

	def display_lut_ctrl_handler(self, event):
		if debug:
			safe_print("[D] display_lut_ctrl_handler called for ID %s %s event "
					   "type %s %s" % (event.GetId(), 
									   getevtobjname(event, self), 
									   event.GetEventType(), 
									   getevttype(event)))
		try:
			i = self.displays.index(self.display_lut_ctrl.GetStringSelection())
		except ValueError:
			i = min(0, self.display_ctrl.GetSelection())
		setcfg("display_lut.number", i + 1)

	def display_lut_link_ctrl_handler(self, event, link=None):
		if debug:
			safe_print("[D] display_lut_link_ctrl_handler called for ID %s %s "
					   "event type %s %s" % (event.GetId(), 
											 getevtobjname(event, self), 
											 event.GetEventType(), 
											 getevttype(event)))
		bitmap_link = geticon(16, "stock_lock")
		bitmap_unlink = geticon(16, "stock_lock-open")
		if link is None:
			link = not bool(int(getcfg("display_lut.link")))
		link = (not len(self.worker.displays) or
				(link and self.worker.lut_access[max(min(len(self.worker.displays),
														 getcfg("display.number")),
													 0) - 1]))
		lut_no = -1
		if link:
			self.display_lut_link_ctrl.SetBitmapLabel(bitmap_link)
			try:
				lut_no = self.display_lut_ctrl.Items.index(self.display_ctrl.GetStringSelection())
			except ValueError:
				pass
		else:
			self.display_lut_link_ctrl.SetBitmapLabel(bitmap_unlink)
		set_bitmap_labels(self.display_lut_link_ctrl)
		if lut_no < 0:
			try:
				lut_no = self.display_lut_ctrl.Items.index(self.display_ctrl.Items[getcfg("display_lut.number") - 1])
			except (IndexError, ValueError):
				lut_no = min(0, self.display_ctrl.GetSelection())
		self.display_lut_ctrl.SetSelection(lut_no)
		self.display_lut_ctrl.Enable(not link and 
									 self.display_lut_ctrl.GetCount() > 1)
		setcfg("display_lut.link", int(link))
		try:
			i = self.displays.index(self.display_lut_ctrl.Items[lut_no])
		except (IndexError, ValueError):
			i = min(0, self.display_ctrl.GetSelection())
		setcfg("display_lut.number", i + 1)

	def measurement_mode_ctrl_handler(self, event=None):
		if debug:
			safe_print("[D] measurement_mode_ctrl_handler called for ID %s %s "
					   "event type %s %s" % (event.GetId(), 
											 getevtobjname(event, self), 
											 event.GetEventType(), 
											 getevttype(event)))
		v = self.get_measurement_mode()
		if v and "p" in v and self.worker.argyll_version < [1, 1, 0]:
			self.measurement_mode_ctrl.SetSelection(
				self.measurement_modes_ba[self.get_instrument_type()].get(
					defaults["measurement_mode"], 1))
			v = None
			InfoDialog(self, msg=lang.getstr("projector_mode_unavailable"), 
					   ok=lang.getstr("ok"), 
					   bitmap=geticon(32, "dialog-information"))
		if v and "V" in v and self.worker.argyll_version < [1, 1, 0] or (
			 self.worker.argyll_version[0:3] == [1, 1, 0] and (
			 "Beta" in self.worker.argyll_version_string or 
			 "RC1" in self.worker.argyll_version_string or 
			 "RC2" in self.worker.argyll_version_string)):
			# adaptive emissive mode was added in RC3
			self.measurement_mode_ctrl.SetSelection(
				self.measurement_modes_ba[self.get_instrument_type()].get(
					defaults["measurement_mode"], 1))
			v = None
			InfoDialog(self, msg=lang.getstr("adaptive_mode_unavailable"), 
					   ok=lang.getstr("ok"), 
					   bitmap=geticon(32, "dialog-information"))
		cal_changed = v != getcfg("measurement_mode") and \
					  getcfg("calibration.file", False) not in self.presets[1:]
		setcfg("measurement_mode", (strtr(v, {"V": "", 
											  "H": ""}) if v else None) or None)
		instrument_features = self.worker.get_instrument_features()
		if instrument_features.get("adaptive_mode"):
			setcfg("measurement_mode.adaptive", 1 if v and "V" in v else 0)
		if instrument_features.get("highres_mode"):
			setcfg("measurement_mode.highres", 1 if v and "H" in v else 0)
		if (v and self.worker.get_instrument_name() in ("ColorHug",
														"ColorHug2") and
			"p" in v):
			# ColorHug projector mode is just a correction matrix
			# Avoid setting ColorMunki projector mode
			v = v.replace("p", "")
		# ColorMunki projector mode is an actual special sensor dial position
		setcfg("measurement_mode.projector", 1 if v and "p" in v else None)
		self.update_colorimeter_correction_matrix_ctrl()
		self.update_colorimeter_correction_matrix_ctrl_items(update_measurement_mode=False)
		if (v and self.get_trc() and (not "c" in v or "p" in v) and
			float(self.get_black_point_correction()) > 0 and
			getcfg("calibration.black_point_correction_choice.show") and
			not getcfg("calibration.black_point_correction.auto")):
			if "c" in v:
				ok = lang.getstr("calibration.turn_on_black_point_correction")
			else:
				ok = lang.getstr("turn_off")
			title = "calibration.black_point_correction"
			msg = "calibration.black_point_correction_choice"
			cancel = "setting.keep_current"
			dlg = ConfirmDialog(self, title=lang.getstr(title), 
								msg=lang.getstr(msg), ok=ok, 
								cancel=lang.getstr(cancel), 
								bitmap=geticon(32, "dialog-question"))
			chk = wx.CheckBox(dlg, -1, lang.getstr("dialog.do_not_show_again"))
			dlg.Bind(wx.EVT_CHECKBOX, 
					 self.black_point_correction_choice_dialog_handler, 
					 id=chk.GetId())
			dlg.sizer3.Add(chk, flag=wx.TOP | wx.ALIGN_LEFT, border=12)
			dlg.sizer0.SetSizeHints(dlg)
			dlg.sizer0.Layout()
			result = dlg.ShowModal()
			dlg.Destroy()
			if result == wx.ID_OK:
				if "c" in v:
					bkpt_corr = 1.0
				else:
					bkpt_corr = 0.0
				if not cal_changed and \
				   bkpt_corr != getcfg("calibration.black_point_correction"):
					self.cal_changed()
				setcfg("calibration.black_point_correction", bkpt_corr)
				self.update_controls(update_profile_name=False)
		self.update_profile_name()
		if v == "auto":
			wx.CallAfter(show_result_dialog,
						 UnloggedInfo(lang.getstr("display.reset.info")), self)
	
	def black_point_correction_choice_dialog_handler(self, event):
		setcfg("calibration.black_point_correction_choice.show", 
			   int(not event.GetEventObject().GetValue()))

	def profile_type_ctrl_handler(self, event):
		if debug and event:
			safe_print("[D] profile_type_ctrl_handler called for ID %s %s "
					   "event type %s %s" % (event.GetId(), 
											 getevtobjname(event, self), 
											 event.GetEventType(), 
											 getevttype(event)))
		v = self.get_profile_type()
		lut_type = v in ("l", "x", "X")
		self.gamap_btn.Enable(lut_type)
		
		proftype_changed = False
		if v in ("l", "x", "X"):
			# XYZ LUT type
			if getcfg("profile.type") not in ("l", "x", "X"):
				# Disable black point compensation for LUT profiles
				setcfg("profile.black_point_compensation", 0)
				proftype_changed = True
		elif v in ("s", "S"):
			# Shaper + matrix type
			if getcfg("profile.type") not in ("s", "S"):
				# Enable black point compensation for shaper profiles
				setcfg("profile.black_point_compensation", 1)
		else:
			setcfg("profile.black_point_compensation", 0)
		if v in ("s", "S", "g", "G"):
			if getcfg("profile.type") not in ("s", "S", "g", "G"):
				proftype_changed = True
		self.update_bpc()
		self.profile_quality_ctrl.Enable(v not in ("g", "G"))
		if v in ("g", "G"):
			self.profile_quality_ctrl.SetValue(3)
			self.profile_quality_info.SetLabel(
				lang.getstr("calibration.quality.high"))
		if v != getcfg("profile.type"):
			self.profile_settings_changed()
		setcfg("profile.type", v)
		if hasattr(self, "gamapframe"):
			self.gamapframe.update_controls()
		self.set_default_testchart(force=proftype_changed)
		self.update_profile_name()
		if event:
			self.check_testchart_patches_amount()
	
	def check_testchart_patches_amount(self):
		""" Check if the selected testchart has at least the recommended
		amount of patches. Give user the choice to use the recommended amount
		if patch count is lower. """
		recommended = {"G": 6,
					   "g": 6,
					   "l": 238,
					   "lh": 124,
					   "S": 12,
					   "s": 12,
					   "X": 238,
					   "Xh": 124,
					   "x": 238,
					   "xh": 124}
		# lower quality actually needs *higher* patchcount while high quality
		# can get away with fewer patches and still improved result
		recommended = recommended.get(self.get_profile_type() + 
									  self.get_profile_quality(), 
									  recommended[self.get_profile_type()])
		patches = int(self.testchart_patches_amount.GetLabel())
		if recommended > patches and not is_ccxx_testchart():
			self.profile_quality_ctrl.Disable()
			dlg = ConfirmDialog(
				self, msg=lang.getstr("profile.testchart_recommendation"), 
				ok=lang.getstr("OK"), cancel=lang.getstr("cancel"), 
				bitmap=geticon(32, "dialog-question"))
			result = dlg.ShowModal()
			self.profile_quality_ctrl.Enable(not getcfg("profile.update") and 
											 self.get_profile_type() not in 
											 ("g", "G"))
			dlg.Destroy()
			if result == wx.ID_OK:
				setcfg("testchart.auto_optimize",
					   max(config.valid_values["testchart.auto_optimize"][1],
						   int(round(colormath.cbrt(recommended)))))
				self.set_testchart("auto")
	
	def measurement_file_check_auto_handler(self, event):
		if not getcfg("ti3.check_sanity.auto"):
			dlg = ConfirmDialog(self,
								msg=lang.getstr("measurement_file.check_sanity.auto.warning"),  
								ok=lang.getstr("ok"), 
								cancel=lang.getstr("cancel"), 
								bitmap=geticon(32, "dialog-warning"), log=False)
			result = dlg.ShowModal()
			dlg.Destroy()
			if result != wx.ID_OK:
				self.menuitem_measurement_file_check_auto.Check(False)
				return
		setcfg("ti3.check_sanity.auto", 
			   int(self.menuitem_measurement_file_check_auto.IsChecked()))
	
	def measurement_file_check_handler(self, event):
		# select measurement data (ti3 or profile)
		path = None
		defaultDir, defaultFile = get_verified_path("last_ti3_path")
		dlg = wx.FileDialog(self, lang.getstr("measurement_file.choose"), 
							defaultDir=defaultDir, defaultFile=defaultFile, 
							wildcard=lang.getstr("filetype.icc_ti3") + 
									 "|*.icc;*.icm;*.ti3", 
							style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
		dlg.Center(wx.BOTH)
		result = dlg.ShowModal()
		if result == wx.ID_OK:
			path = dlg.GetPath()
		dlg.Destroy()
		if path:
			if not os.path.exists(path):
				show_result_dialog(Error(lang.getstr("file.missing", path)),
								   self)
				return
			tags = OrderedDict()
			# Get filename and extension of file
			filename, ext = os.path.splitext(path)
			if ext.lower() != ".ti3":
				try:
					profile = ICCP.ICCProfile(path)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					show_result_dialog(Error(lang.getstr("profile.invalid") + 
											 "\n" + path), self)
					return
				if (profile.tags.get("CIED", "") or 
					profile.tags.get("targ", ""))[0:4] != "CTI3":
					show_result_dialog(Error(lang.getstr("profile.no_embedded_ti3") + 
											 "\n" + path), self)
					return
				ti3 = StringIO(profile.tags.get("CIED", "") or 
							   profile.tags.get("targ", ""))
			else:
				profile = None
				try:
					ti3 = open(path, "rU")
				except Exception, exception:
					show_result_dialog(Error(lang.getstr("error.file.open", path)),
									   self)
					return
			setcfg("last_ti3_path", path)
			ti3 = CGATS.CGATS(ti3)
			if self.measurement_file_check_confirm(ti3, True):
				if ti3.modified:
					if profile:
						# Regenerate the profile?
						dlg = ConfirmDialog(self,
											msg=lang.getstr("profile.confirm_regeneration"), 
											ok=lang.getstr("ok"),
											cancel=lang.getstr("cancel"),
											bitmap=geticon(32, "dialog-information"))
						dlg.Center()
						result = dlg.ShowModal()
						if result == wx.ID_OK:
							self.worker.wrapup(False)
							tmp_working_dir = self.worker.create_tempdir()
							if isinstance(tmp_working_dir, Exception):
								show_result_dialog(tmp_working_dir, self)
								return
							profile.tags.targ = ICCP.TextType("text\0\0\0\0" +
															  str(ti3) + "\0", 
															  "targ")
							profile.tags.DevD = profile.tags.CIED = profile.tags.targ
							tmp_path = os.path.join(tmp_working_dir,
													os.path.basename(path))
							profile.write(tmp_path)
							self.create_profile_handler(None, tmp_path, True)
					else:
						dlg = wx.FileDialog(self, lang.getstr("save_as"), 
											os.path.dirname(path), 
											os.path.basename(path), 
											wildcard=lang.getstr("filetype.ti3") + 
													 "|*.ti3", 
											style=wx.SAVE | wx.FD_OVERWRITE_PROMPT)
						dlg.Center(wx.BOTH)
						result = dlg.ShowModal()
						path = dlg.GetPath()
						dlg.Destroy()
						if result == wx.ID_OK:
							if not waccess(path, os.W_OK):
								show_result_dialog(Error(lang.getstr("error.access_denied.write",
																	 path)),
												   self)
								return
							try:
								ti3.write(path)
							except EnvironmentError, exception:
								show_result_dialog(exception, self)
				else:
					show_result_dialog(UnloggedInfo(lang.getstr("errors.none_found")),
									   self)

	def measurement_file_check_confirm(self, ti3=None, force=False, parent=None):
		if not getcfg("ti3.check_sanity.auto") and not force:
			return True
		if not ti3:
			profile_save_path = self.worker.tempdir
			if profile_save_path and os.path.isdir(profile_save_path):
				profile_name = getcfg("profile.name.expanded")
				ti3 = os.path.join(profile_save_path, 
								   make_argyll_compatible_path(profile_name) +
								   ".ti3")
				if not os.path.isfile(ti3):
					ti3 = None
			if not ti3:
				# Let the caller handle missing files
				return True
		try:
			if not isinstance(ti3, CGATS.CGATS):
				ti3 = CGATS.CGATS(ti3)
			ti3_1 = verify_ti1_rgb_xyz(ti3)
		except (IOError, CGATS.CGATSError), exception:
			show_result_dialog(exception, self)
			return False
		suspicious = check_ti3(ti3_1)
		if not suspicious:
			return True
		self.Show(start_timers=False)
		dlg = MeasurementFileCheckSanityDialog(parent or self, ti3_1,
											   suspicious, force)
		result = dlg.ShowModal()
		if result == wx.ID_OK:
			indexes = []
			for index in xrange(dlg.grid.GetNumberRows()):
				if dlg.grid.GetCellValue(index, 0) == "":
					indexes.insert(0, index)
			data = ti3_1.queryv1("DATA")
			removed = []
			for index in indexes:
				removed.insert(0, data.pop(dlg.suspicious_items[index]))
			for item in removed:
				safe_print("Removed patch #%i from TI3: %s" % (item.key, item))
			for index, fields in dlg.mods.iteritems():
				if index not in indexes:
					item = dlg.suspicious_items[index]
					for field, value in fields.iteritems():
						old = item[field]
						if old != value:
							item[field] = value
							safe_print(u"Updated patch #%s in TI3: %s %.4f \u2192 %.4f" % 
									   (item.SAMPLE_ID, field, old, value))
		dlg.Destroy()
		if result == wx.ID_CANCEL:
			return False
		elif result == wx.ID_OK:
			if ti3.modified:
				if ti3.filename and os.path.exists(ti3.filename) and not force:
					try:
						ti3.write()
					except EnvironmentError, exception:
						show_result_dialog(exception, self)
						return False
					safe_print("Written updated TI3 to", ti3.filename)
				return removed, ti3
		return True

	def profile_name_ctrl_handler(self, event):
		if debug:
			safe_print("[D] profile_name_ctrl_handler called for ID %s %s "
					   "event type %s %s" % (event.GetId(), 
											 getevtobjname(event, self), 
											 event.GetEventType(), 
											 getevttype(event)))
		oldval = self.profile_name_textctrl.GetValue()
		if not self.check_profile_name() or len(oldval) > self.maxprofilenamelength:
			wx.Bell()
			x = self.profile_name_textctrl.GetInsertionPoint()
			if oldval == "":
				newval = defaults.get("profile.name", "")
			else:
				newval = re.sub(r"[\\/:;*?\"<>|]+", "", oldval).lstrip("-")[:self.maxprofilenamelength]
			self.profile_name_textctrl.ChangeValue(newval)
			self.profile_name_textctrl.SetInsertionPoint(x - (len(oldval) - 
															  len(newval)))
		self.update_profile_name()

	def create_profile_name_btn_handler(self, event):
		self.update_profile_name()

	def create_session_archive_handler(self, event):
		""" Create 7z or ZIP archive of the currently selected profile folder """
		filename = getcfg("calibration.file", False)
		if not filename:
			return
		path_name, ext = os.path.splitext(filename)
		# Check for 7-Zip
		sevenzip = get_program_file("7z", "7-zip")
		if sevenzip:
			format = "7z"
		else:
			format = "zip"
		wildcard = lang.getstr("filetype." + format) + "|*." + format
		if format == "7z":
			wildcard += "|" + lang.getstr("filetype.zip") + "|*.zip"
		wildcard += "|" + lang.getstr("filetype.tgz") + "|*.tgz"
		# Ask where to save archive
		defaultDir, defaultFile = get_verified_path("last_archive_save_path")
		dlg = wx.FileDialog(self, lang.getstr("archive.create"), defaultDir, 
							"%s.%s" % (os.path.basename(path_name), format),
							wildcard=wildcard, style=wx.SAVE |
													 wx.FD_OVERWRITE_PROMPT)
		dlg.Center(wx.BOTH)
		result = dlg.ShowModal()
		archive_path = dlg.GetPath()
		if sevenzip and dlg.GetFilterIndex():
			# ZIP or TGZ
			sevenzip = None
		dlg.Destroy()
		if result != wx.ID_OK:
			return
		setcfg("last_archive_save_path", archive_path)
		dirname = os.path.dirname(filename)
		dirfilenames = [os.path.join(dirname, filename) for filename in
						os.listdir(dirname)]
		dirfilenames.sort()
		# Select filenames
		filenames = (glob.glob(path_name + "*") +
					 glob.glob(os.path.join(dirname, "*.ccmx")) +
					 glob.glob(os.path.join(dirname, "*.ccss")))
		filenames.sort()
		lut3d_ext = ["." + strtr(lut3d_format, {"eeColor": "txt",
												"madVR": "3dlut"})
					 for lut3d_format in
					 filter(lambda format: format not in ("icc", "icm"),
							config.valid_values["3dlut.format"])]
		has_3dlut = False
		for filename in filenames:
			if os.path.splitext(filename)[1].lower() in lut3d_ext:
				has_3dlut = True
				break
		if has_3dlut:
			# Should 3D LUT files be included?
			dlg = ConfirmDialog(self,
								msg=lang.getstr("archive.include_3dluts"), 
								ok=lang.getstr("no"), alt=lang.getstr("yes"),
								cancel=lang.getstr("cancel"), 
								bitmap=geticon(32, "dialog-question"))
			result = dlg.ShowModal()
			if result == wx.ID_CANCEL:
				return
			if result != wx.ID_OK:
				# Include 3D LUTs
				lut3d_ext = None
		self.worker.interactive = False
		self.worker.start(self.create_session_archive_consumer,
						  self.create_session_archive_producer,
						  wargs=(dirname, dirfilenames, filenames, archive_path,
								 lut3d_ext if has_3dlut else None, sevenzip),
						  progress_msg=lang.getstr("archive.create"),
						  stop_timers=False, cancelable=bool(sevenzip),
						  fancy=False)

	def create_session_archive_producer(self, dirname, dirfilenames, filenames,
										archive_path, exclude_ext, sevenzip):
		""" Create session archive """
		if sevenzip:
			# Create 7z archive
			if filenames == dirfilenames:
				# Add whole folder to archive, so that the 7z archive
				# has one folder in it containing all files
				filenames = [dirname]
			if os.path.isfile(archive_path):
				os.remove(archive_path)
			args = ["a", "-y"]
			if exclude_ext:
				for ext in exclude_ext:
					args.append("-xr!*" + ext)
			return self.worker.exec_cmd(sevenzip, args + [archive_path] + filenames,
										capture_output=True)
		else:
			# Create gzipped TAR or ZIP archive
			dirbasename = ""
			if filenames == dirfilenames:
				# Add whole folder to archive, so that the ZIP archive
				# has one folder in it containing all files
				dirbasename = os.path.basename(dirname)
			if (archive_path.lower().endswith(".tgz") or
				archive_path.lower().endswith(".tar.gz")):
				# Create gzipped tar archive
				archive = TarFileProper.open(archive_path, "w:gz", encoding="UTF-8")
				writefile = archive.add
			else:
				archive = zipfile.ZipFile(archive_path, "w",
										  zipfile.ZIP_DEFLATED)
				writefile = archive.write
			try:
				with archive:
					for filename in filenames:
						if exclude_ext:
							if os.path.splitext(filename)[1].lower() in exclude_ext:
								continue
						writefile(filename,
								  os.path.join(dirbasename,
											   os.path.basename(filename)))
			except Exception, exception:
				return exception
			else:
				return True

	def create_session_archive_consumer(self, result):
		if not result:
			result = UnloggedError("".join(self.worker.errors))
		if isinstance(result, Exception):
			show_result_dialog(result, parent=self)

	def profile_save_path_btn_handler(self, event):
		defaultPath = os.path.join(*get_verified_path("profile.save_path"))
		profile_name = getcfg("profile.name.expanded")
		dlg = wx.DirDialog(self, lang.getstr("dialog.set_profile_save_path", 
											 profile_name), 
						   defaultPath=defaultPath)
		dlg.Center(wx.BOTH)
		if dlg.ShowModal() == wx.ID_OK:
			path = dlg.GetPath()
			profile_save_dir = os.path.join(path, profile_name)
			if not os.path.isdir(profile_save_dir):
				try:
					os.makedirs(profile_save_dir)
				except:
					pass
			if not waccess(os.path.join(profile_save_dir, profile_name),
						   os.W_OK):
				show_result_dialog(Error(lang.getstr("error.access_denied.write",
													 path)), self)
				return
			try:
				os.rmdir(profile_save_dir)
			except:
				pass
			setcfg("profile.save_path", path)
			self.update_profile_name()
		dlg.Destroy()
	
	def profile_name_info_btn_handler(self, event):
		if not hasattr(self, "profile_name_tooltip_window"):
			self.profile_name_tooltip_window = TooltipWindow(
				self, msg=self.profile_name_info(), cols=2, 
				title=lang.getstr("profile.name"), 
				bitmap=geticon(32, "dialog-information"))
		else:
			self.profile_name_tooltip_window.Show()
			self.profile_name_tooltip_window.Raise()

	def profile_name_info(self):
		info = ["%nn	" + lang.getstr("computer.name"),
				"%dn	" + lang.getstr("display"),
				"%dns	" + lang.getstr("display_short"),
				"%dnw	" + lang.getstr("display") + " (" +
							lang.getstr("windows_only") + ")",
				"%dnws	" + lang.getstr("display_short") + " (" +
							lang.getstr("windows_only") + ")",
				"%out	" + lang.getstr("display.output"),
				"%ds	" + lang.getstr("edid.serial") + " (" +
							lang.getstr("if_available") + ")",
				"%crc32	" + lang.getstr("edid.crc32") + " (" +
							lang.getstr("if_available") + ")",
				"%in	" + lang.getstr("instrument"),
				"%im	" + lang.getstr("measurement_mode"),
				"%wp	" + lang.getstr("whitepoint"),
				"%cb	" + lang.getstr("calibration.luminance"),
				"%cB	" + lang.getstr("calibration.black_luminance"),
				"%cg	" + lang.getstr("trc"),
				"%ca	" + lang.getstr("calibration.ambient_viewcond_adjust"),
				"%cf	" + lang.getstr("calibration.black_output_offset"),
				"%ck	" + lang.getstr("calibration.black_point_correction")]
		if defaults["calibration.black_point_rate.enabled"]:
			info.append("%cA	" + lang.getstr("calibration.black_point_rate"))
		info.extend(["%cq	" + lang.getstr("calibration.speed"),
					 "%pq	" + lang.getstr("profile.quality"),
					 "%pt	" + lang.getstr("profile.type"),
					 "%tpa	" + lang.getstr("testchart.info")])
		return lang.getstr("profile.name.placeholders") + "\n" + \
			   "\n".join(info)
	
	def profile_hires_b2a_handler(self, event, profile=None):
		if not profile:
			profile = self.select_profile(title=lang.getstr("profile.b2a.hires"),
										  ignore_current_profile=True)
		if profile:
			if not ("A2B0" in profile.tags or "A2B1" in profile.tags):
				result = Error(lang.getstr("profile.required_tags_missing",
										   " %s ".join(["A2B0", "A2B1"]) %
										   lang.getstr("or")))
			elif (("A2B0" in profile.tags and
				   not isinstance(profile.tags.A2B0, ICCP.LUT16Type)) or
				  ("A2B1" in profile.tags and
				   not isinstance(profile.tags.A2B1, ICCP.LUT16Type))):
				result = Error(lang.getstr("profile.required_tags_missing",
										   "LUT16Type"))
			elif profile.connectionColorSpace not in ("XYZ", "Lab"):
				result = Error(lang.getstr("profile.unsupported",
										   (profile.connectionColorSpace,
											profile.connectionColorSpace)))
			else:
				result = None
			if result:
				show_result_dialog(result, self)
			else:
				self.interactive = False
				##self.profile_hires_b2a_consumer(self.worker.update_profile_B2A(profile), profile)
				self.worker.start(self.profile_hires_b2a_consumer,
								  self.worker.update_profile_B2A,
								  cargs=(profile, ),
								  wargs=(profile, ))

	def profile_hires_b2a_consumer(self, result, profile):
		self.start_timers()
		if isinstance(result, Exception):
			show_result_dialog(result, self)
		elif result:
			if not profile.fileName or not os.path.isfile(profile.fileName):
				# Let the user choose a location for the profile
				defaultDir, defaultFile = os.path.split(profile.fileName)
				dlg = wx.FileDialog(self, lang.getstr("save_as"), 
									defaultDir, defaultFile, 
									wildcard=lang.getstr("filetype.icc") + 
											 "|*" + profile_ext, 
									style=wx.SAVE | wx.FD_OVERWRITE_PROMPT)
				dlg.Center(wx.BOTH)
				result = dlg.ShowModal()
				profile_save_path = dlg.GetPath()
				dlg.Destroy()
			else:
				result = wx.ID_OK
				profile_save_path = profile.fileName
			if result == wx.ID_OK:
				filename, ext = os.path.splitext(profile_save_path)
				if ext.lower() not in (".icc", ".icm"):
					profile_save_path += profile_ext
				if not waccess(profile_save_path, os.W_OK):
					show_result_dialog(Error(lang.getstr("error.access_denied.write",
														 profile_save_path)),
									   self)
					return
				profile.setDescription(os.path.basename(filename))
				profile.calculateID()
				profile.write(profile_save_path)
				if profile_save_path == get_current_profile_path():
					self.lut3d_update_b2a_controls()
				self.install_profile_handler(None, profile_save_path,
											 install_3dlut=False)
		else:
			show_result_dialog(lang.getstr("error.profile.file_not_created"),
							   self)

	def create_profile_handler(self, event, path=None, skip_ti3_check=False):
		""" Create profile from existing measurements """
		if not check_set_argyll_bin():
			return
		if path is None:
			selectedpaths = []
			# select measurement data (ti3 or profile)
			defaultDir, defaultFile = get_verified_path("last_ti3_path")
			dlg = wx.FileDialog(self, lang.getstr("create_profile"), 
								defaultDir=defaultDir, defaultFile=defaultFile, 
								wildcard=lang.getstr("filetype.icc_ti3") + 
										 "|*.icc;*.icm;*.ti3", 
								style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST |
									  wx.FD_MULTIPLE)
			dlg.Center(wx.BOTH)
			result = dlg.ShowModal()
			if result == wx.ID_OK:
				selectedpaths = dlg.GetPaths()
			dlg.Destroy()
		elif path:
			selectedpaths = [path]
		collected_ti3s = []
		for path in selectedpaths:
			if not os.path.exists(path):
				InfoDialog(self, msg=lang.getstr("file.missing", path), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
			tags = OrderedDict()
			# Get filename and extension of source file
			source_filename, source_ext = os.path.splitext(path)
			if source_ext.lower() != ".ti3":
				try:
					profile = ICCP.ICCProfile(path)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					InfoDialog(self, msg=lang.getstr("profile.invalid") + 
										 "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
				if (profile.tags.get("CIED", "") or 
					profile.tags.get("targ", ""))[0:4] != "CTI3":
					InfoDialog(self, 
							   msg=lang.getstr("profile.no_embedded_ti3") + 
								   "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
				ti3 = StringIO(profile.tags.get("CIED", "") or 
							   profile.tags.get("targ", ""))
				# Preserve custom tags
				for tagname in ("mmod", "meta"):
					if tagname in profile.tags:
						tags[tagname] = profile.tags[tagname]
			else:
				try:
					ti3 = open(path, "rU")
				except Exception, exception:
					InfoDialog(self, msg=lang.getstr("error.file.open", path), 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
			ti3_lines = [line.strip() for line in ti3]
			ti3.close()
			if not "CAL" in ti3_lines:
				dlg = ConfirmDialog(self, 
									msg=lang.getstr("dialog.ti3_no_cal_info"), 
									ok=lang.getstr("continue"), 
									cancel=lang.getstr("cancel"), 
									bitmap=geticon(32, "dialog-warning"))
				result = dlg.ShowModal()
				dlg.Destroy()
				if result != wx.ID_OK: return
			collected_ti3s.append((path, ti3_lines))
		if collected_ti3s:
			if len(collected_ti3s) > 1:
				source_filename = os.path.splitext(defaults["last_ti3_path"])[0]
				source_ext = ".ti3"
			path = collected_ti3s[0][0]
			is_tmp = False
			tmp_working_dir = self.worker.tempdir
			if tmp_working_dir:
				if sys.platform == "win32":
					if path.lower().startswith(tmp_working_dir.lower()):
						is_tmp = True
				elif path.startswith(tmp_working_dir):
					is_tmp = True
			if is_tmp:
				defaultDir, defaultFile = get_verified_path("last_ti3_path")
			else:
				defaultDir, defaultFile = os.path.split(path)
				setcfg("last_ti3_path", path)
			# let the user choose a location for the profile
			dlg = wx.FileDialog(self, lang.getstr("save_as"), 
								defaultDir, 
								os.path.basename(source_filename) + 
								profile_ext, 
								wildcard=lang.getstr("filetype.icc") + 
										 "|*" + profile_ext, 
								style=wx.SAVE | wx.FD_OVERWRITE_PROMPT)
			dlg.Center(wx.BOTH)
			result = dlg.ShowModal()
			profile_save_path = os.path.split(dlg.GetPath())
			profile_save_path = os.path.join(profile_save_path[0], 
											 make_argyll_compatible_path(profile_save_path[1]))
			dlg.Destroy()
			if result == wx.ID_OK:
				if not waccess(profile_save_path, os.W_OK):
					show_result_dialog(Error(lang.getstr("error.access_denied.write",
														 profile_save_path)),
									   self)
					return
				filename, ext = os.path.splitext(profile_save_path)
				if ext.lower() not in (".icc", ".icm"):
					profile_save_path += profile_ext
					if os.path.exists(profile_save_path):
						dlg = ConfirmDialog(
							self, msg=lang.getstr("dialog.confirm_overwrite", 
												  (profile_save_path)), 
							ok=lang.getstr("overwrite"), 
							cancel=lang.getstr("cancel"), 
							bitmap=geticon(32, "dialog-warning"))
						result = dlg.ShowModal()
						dlg.Destroy()
						if result != wx.ID_OK:
							return
				setcfg("last_cal_or_icc_path", profile_save_path)
				setcfg("last_icc_path", profile_save_path)
				# get filename and extension of target file
				profile_name = os.path.basename(
					os.path.splitext(profile_save_path)[0])
				# create temporary working dir
				tmp_working_dir = self.worker.create_tempdir()
				if isinstance(tmp_working_dir, Exception):
					self.worker.wrapup(False)
					show_result_dialog(tmp_working_dir, self)
					return
				# Copy ti3 to temp dir
				ti3_tmp_path = os.path.join(tmp_working_dir, 
											make_argyll_compatible_path(profile_name + 
																		".ti3"))
				if len(collected_ti3s) > 1:
					# Collect files for averaging
					collected_paths = []
					for ti3_path, ti3_lines in collected_ti3s:
						collected_path = os.path.join(tmp_working_dir,
													  os.path.basename(ti3_path))
						with open(collected_path, "w") as ti3_file:
							ti3_file.write("\n".join(ti3_lines))
						collected_paths.append(collected_path)
					# Average the TI3 files
					args = ["-v"] + collected_paths + [ti3_tmp_path]
					cmd = get_argyll_util("average")
					result = self.worker.exec_cmd(cmd, args, capture_output=True,
												  skip_scripts=True)
					for collected_path in collected_paths:
						os.remove(collected_path)
					if isinstance(result, Exception) or not result:
						self.worker.wrapup(False)
						show_result_dialog(result or
										   Error("\n".join(self.worker.errors)), self)
						return
					path = ti3_tmp_path
				self.worker.options_dispcal = []
				self.worker.options_targen = []
				display_name = None
				display_manufacturer = None
				try:
					if source_ext.lower() == ".ti3":
						if path != ti3_tmp_path:
							shutil.copyfile(path, ti3_tmp_path)
					else:
						# Binary mode because we want to avoid automatic 
						# newlines conversion
						ti3 = open(ti3_tmp_path, "wb") 
						ti3.write(profile.tags.get("CIED", "") or 
								  profile.tags.get("targ", ""))
						ti3.close()
						# Get dispcal options if present
						self.worker.options_dispcal = [
							"-" + arg for arg in 
							get_options_from_profile(profile)[0]]
						if "dmdd" in profile.tags:
							display_name = profile.getDeviceModelDescription()
						if "dmnd" in profile.tags:
							display_manufacturer = profile.getDeviceManufacturerDescription()
						if is_tmp and path != ti3_tmp_path:
							profile.close()
							os.remove(path)
					ti3 = CGATS.CGATS(ti3_tmp_path)
					if ti3.queryv1("COLOR_REP") and \
					   ti3.queryv1("COLOR_REP")[:3] == "RGB":
						self.worker.options_targen = ["-d3"]
				except Exception, exception:
					handle_error(Error(u"Error - temporary .ti3 file could not "
									   u"be created: " + safe_unicode(exception)),
								 parent=self)
					self.worker.wrapup(False)
					return
				setcfg("calibration.file.previous", None)
				safe_print("-" * 80)
				if (not skip_ti3_check and
					not self.measurement_file_check_confirm(ti3)):
					self.worker.wrapup(False)
					return
				# Run colprof
				self.worker.interactive = False
				self.worker.start(
					self.profile_finish, self.worker.create_profile, ckwargs={
						"profile_path": profile_save_path, 
						"failure_msg": lang.getstr(
							"error.profile.file_not_created"),
						"install_3dlut": getcfg("3dlut.create")}, 
					wkwargs={"dst_path": profile_save_path, 
							 "display_name": display_name,
							 "display_manufacturer": display_manufacturer,
							 "tags": tags}, 
					progress_msg=lang.getstr("create_profile"))
	
	def create_profile_from_edid(self, event):
		edid = self.worker.get_display_edid()
		defaultFile = edid.get("monitor_name",
							   edid.get("ascii",
										str(edid["product_id"]))) + profile_ext
		defaultDir = get_verified_path(None, 
									   os.path.join(getcfg("profile.save_path"), 
													defaultFile))[0]
		# let the user choose a location for the profile
		dlg = wx.FileDialog(self, lang.getstr("save_as"), defaultDir, 
							defaultFile, wildcard=lang.getstr("filetype.icc") + 
												  "|*" + profile_ext, 
							style=wx.SAVE | wx.FD_OVERWRITE_PROMPT)
		dlg.Center(wx.BOTH)
		result = dlg.ShowModal()
		profile_save_path = os.path.split(dlg.GetPath())
		profile_save_path = os.path.join(profile_save_path[0], 
										 make_argyll_compatible_path(profile_save_path[1]))
		dlg.Destroy()
		if result == wx.ID_OK:
			if not waccess(profile_save_path, os.W_OK):
				show_result_dialog(Error(lang.getstr("error.access_denied.write",
													 profile_save_path)),
								   self)
				return
			profile = ICCP.ICCProfile.from_edid(edid)
			try:
				profile.write(profile_save_path)
			except Exception, exception:
				InfoDialog(self, msg=safe_unicode(exception), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
			else:
				if getcfg("profile.create_gamut_views"):
					safe_print("-" * 80)
					safe_print(lang.getstr("gamut.view.create"))
					self.worker.interactive = False
					self.worker.start(self.create_profile_from_edid_finish,
									  self.worker.calculate_gamut, 
									  cargs=(profile, ),
									  wargs=(profile_save_path, ),
									  progress_msg=lang.getstr("gamut.view.create"), 
									  resume=False)
				else:
					self.create_profile_from_edid_finish(True, profile)
	
	def create_profile_from_edid_finish(self, result, profile):
		if isinstance(result, Exception):
			show_result_dialog(result, self)
		elif result:
			if isinstance(result, tuple):
				profile.set_gamut_metadata(result[0], result[1])
				prefixes = profile.tags.meta.getvalue("prefix", "", None).split(",")
				# Set license
				profile.tags.meta["License"] = getcfg("profile.license")
				# Set device ID
				device_id = self.worker.get_device_id(quirk=True)
				if device_id:
					profile.tags.meta["MAPPING_device_id"] = device_id
					prefixes.append("MAPPING_")
					profile.tags.meta["prefix"] = ",".join(prefixes)
				profile.calculateID()
				safe_print("-" * 80)
			try:
				profile.write()
			except Exception, exception:
				show_result_dialog(exception, self)
				return
			self.profile_finish(True, profile.fileName,
								install_3dlut=getcfg("3dlut.create"))
	
	def create_profile_name(self):
		"""
		Replace placeholders in profile name with values from configuration
		
		"""
		profile_name = self.profile_name_textctrl.GetValue()
		
		# Computername
		if "%nn" in profile_name:
			profile_name = profile_name.replace("%nn",
												safe_unicode(platform.node()) or
												"\0")

		# Windows display name (EnumDisplayDevices / DeviceString)
		if "%dnws" in profile_name:
			display_win32_short = self.worker.get_display_name_short(False,
																	 False)
			profile_name = profile_name.replace("%dnws", display_win32_short or
														 "\0")
		if "%dnw" in profile_name:
			display_win32 = self.worker.get_display_name(True, False)
			profile_name = profile_name.replace("%dnw", display_win32 or "\0")

		# EDID
		if "%ds" in profile_name or "%crc32" in profile_name:
			edid = self.worker.get_display_edid()
		# Serial
		if "%ds" in profile_name:
			serial = edid.get("serial_ascii", hex(edid.get("serial_32", 0))[2:])
			if serial and serial not in ("0", "1010101", "fffffff"):
				profile_name = profile_name.replace("%ds", serial)
			else:
				profile_name = profile_name.replace("%ds", "\0")
		# CRC32
		if "%crc32" in profile_name:
			if edid.get("edid"):
				profile_name = profile_name.replace("%crc32",
													"%X" %
													(crc32(edid["edid"])
													 & 0xFFFFFFFF))
			else:
				profile_name = profile_name.replace("%crc32", "\0")

		# Display name
		if "%dns" in profile_name:
			display_short = self.worker.get_display_name_short(False, True)
			profile_name = profile_name.replace("%dns", display_short or "\0")
		if "%dn" in profile_name:
			display = self.worker.get_display_name(True, True)
			profile_name = profile_name.replace("%dn", display or "\0")

		# Output #
		if config.is_virtual_display():
			output = "\0"
		else:
			output = "#%s" % getcfg("display.number")
		profile_name = profile_name.replace("%out", output or "\0")

		# Instrument name
		if "%in" in profile_name:
			instrument = self.comport_ctrl.GetStringSelection()
			profile_name = profile_name.replace("%in", instrument or "\0")

		# Measurement mode
		if "%im" in profile_name:
			mode = ""
			measurement_mode = self.get_measurement_mode()
			if measurement_mode:
				if "c" in measurement_mode:
					mode += lang.getstr("measurement_mode.refresh")
				elif "l" in measurement_mode:
					mode += lang.getstr("measurement_mode.lcd")
				if "p" in measurement_mode:
					if mode:
						mode += "-"
					mode += lang.getstr("projector")
				if "V" in measurement_mode:
					if mode:
						mode += "-"
					mode += lang.getstr("measurement_mode.adaptive")
				if "H" in measurement_mode:
					if mode:
						mode += "-"
					mode += lang.getstr("measurement_mode.highres")
			else:
				mode += lang.getstr("default")
			profile_name = profile_name.replace("%im", mode)

		trc = self.get_trc()
		do_cal = self.interactive_display_adjustment_cb.GetValue() or trc

		# Whitepoint
		if "%wp" in profile_name:
			whitepoint = self.get_whitepoint()
			whitepoint_locus = self.get_whitepoint_locus()
			if isinstance(whitepoint, str):
				if whitepoint.find(",") < 0:
					if whitepoint_locus == "t":
						whitepoint = "D" + whitepoint
					else:
						whitepoint += "K"
				else:
					whitepoint = "x ".join(whitepoint.split(",")) + "y"
			profile_name = profile_name.replace("%wp", (do_cal and whitepoint) or
													   "\0")

		# Luminance
		if "%cb" in profile_name:
			luminance = self.get_luminance()
			profile_name = profile_name.replace("%cb", 
												"\0" if 
												luminance is None or not do_cal
												else luminance + u"cdm²")

		# Black luminance
		if "%cB" in profile_name:
			black_luminance = self.get_black_luminance()
			profile_name = profile_name.replace("%cB", 
												"\0" if 
												black_luminance is None
												or not do_cal
												else black_luminance + u"cdm²")

		# TRC / black output offset
		if "%cg" in profile_name or "%cf" in profile_name:
			black_output_offset = self.get_black_output_offset()

		# TRC
		if "%cg" in profile_name and trc:
			trc_type = self.get_trc_type()
			bt1886 = (trc == "2.4" and trc_type == "G" and
					  black_output_offset == "0")
			if bt1886:
				trc = "Rec. 1886"
			elif trc not in ("l", "709", "s", "240"):
				if trc_type == "G":
					trc += " (%s)" % lang.getstr("trc.type.absolute").lower()
			else:
				trc = strtr(trc, {"l": "L", 
								  "709": "Rec. 709", 
								  "s": "sRGB", 
								  "240": "SMPTE240M"})
		profile_name = profile_name.replace("%cg", trc or "\0")

		# Ambient adjustment
		if "%ca" in profile_name:
			ambient = self.get_ambient()
			profile_name = profile_name.replace("%ca", "\0" if ambient is None
															   or not trc
													   else ambient + "lx")

		# Black output offset
		if "%cf" in profile_name:
			f = int(float(black_output_offset) * 100)
			profile_name = profile_name.replace("%cf", ("%i%%" % f) if trc
													   else "\0")

		# Black point correction / rate
		if "%ck" in profile_name or "%cA" in profile_name:
			black_point_correction = self.get_black_point_correction()

		# Black point correction
		if "%ck" in profile_name:
			k = int(float(black_point_correction) * 100)
			auto = self.black_point_correction_auto_cb.GetValue()
			profile_name = profile_name.replace("%ck", (str(k) + "% " if k > 0 and 
														k < 100 else "") + 
													   (lang.getstr("neutral") if 
														k > 0 else "\0").lower()
													   if trc and not auto
													   else "\0")

		# Black point rate
		if "%cA" in profile_name:
			black_point_rate = self.get_black_point_rate()
			if black_point_rate and float(black_point_correction) < 1 and trc:
				profile_name = profile_name.replace("%cA", black_point_rate)
			else:
				profile_name = profile_name.replace("%cA", "\0")

		# Calibration / profile quality
		if "%cq" in profile_name or "%pq" in profile_name:
			calibration_quality = self.get_calibration_quality()
			profile_quality = getcfg("profile.quality")
			aspects = {
				"c": calibration_quality if trc else "",
				"p": profile_quality
			}
			msgs = {
				"u": "VS", 
				"h": "S", 
				"m": "M", 
				"l": "F", 
				"v": "VF",
				"": "\0"
			}
			quality = {}
			if "%cq" in profile_name:
				quality["c"] = msgs[aspects["c"]]
			if "%pq" in profile_name:
				quality["p"] = msgs[aspects["p"]]
			if len(quality) == 2 and (quality["c"] == quality["p"] or
									  quality["c"] == "\0"):
				profile_name = re.sub("%cq\W*%pq", quality["p"], profile_name)
			for q in quality:
				profile_name = profile_name.replace("%%%sq" % q, quality[q])

		# Profile type
		if "%pt" in profile_name:
			profile_type = {
				"G": "1xGamma+MTX",
				"g": "3xGamma+MTX",
				"l": "LabLUT",
				"S": "1xCurve+MTX",
				"s": "3xCurve+MTX",
				"X": "XYZLUT+MTX",
				"x": "XYZLUT"
			}.get(self.get_profile_type())
			profile_name = profile_name.replace("%pt", profile_type or "\0")

		# Amount of test patches
		if "%tpa" in profile_name:
			profile_name = profile_name.replace("%tpa", 
												self.testchart_patches_amount.GetLabel())

		# Date / time
		directives = (
			"a",
			"A",
			"b",
			"B",
			"d",
			"H",
			"I",
			"j",
			"m",
			"M",
			"p",
			"S",
			"U",
			"w",
			"W",
			"y",
			"Y"
		)
		for directive in directives:
			if "%%%s" % directive in profile_name:
				try:
					profile_name = profile_name.replace("%%%s" % directive, 
														strftime("%%%s" % 
																 directive))
				except UnicodeDecodeError:
					pass

		# All whitespace to space
		profile_name = re.sub("\s", " ", profile_name)

		# Get rid of inserted NULL bytes
		# Try to keep spacing intact
		if "\0" in profile_name:
			profile_name = re.sub("^(\0[_\- ]?)+|([_\- ]?\0)+$", "", profile_name)
			# Surrounded by underscores
			while "_\0" in profile_name or "\0_" in profile_name:
				while re.search("_\0+_", profile_name):
					profile_name = re.sub("_\0+_", "_", profile_name)
				profile_name = re.sub("_\0+", "_", profile_name)
				profile_name = re.sub("\0+_", "_", profile_name)
			# Surrounded by dashes
			while "-\0" in profile_name or "\0-" in profile_name:
				while re.search("-\0+-", profile_name):
					profile_name = re.sub("-\0+-", "-", profile_name)
				profile_name = re.sub("-\0+", "-", profile_name)
				profile_name = re.sub("\0+-", "-", profile_name)
			# Surrounded by whitespace
			while " \0" in profile_name or "\0 " in profile_name:
				while re.search(" \0+ ", profile_name):
					profile_name = re.sub(" \0+ ", " ", profile_name)
				profile_name = re.sub(" \0+", " ", profile_name)
				profile_name = re.sub("\0+ ", " ", profile_name)
			profile_name = re.sub("\0+", "", profile_name)

		# Get rid of characters considered invalid for filenames and shorten
		# to a length of <maxprofilenamelength> chars
		# Also strip leading dashes which might trick Argyll tools into
		# mistaking parts of the profile name as an option parameter
		return re.sub(r"[\\/:;*?\"<>|]+", "_", profile_name).lstrip("-")[:self.maxprofilenamelength]

	def update_profile_name(self, event=None):
		profile_name = self.create_profile_name()
		if not self.check_profile_name(profile_name):
			self.profile_name_textctrl.ChangeValue(getcfg("profile.name"))
			profile_name = self.create_profile_name()
			if not self.check_profile_name(profile_name):
				self.profile_name_textctrl.ChangeValue(
					defaults.get("profile.name", ""))
				profile_name = self.create_profile_name()
		profile_name = make_argyll_compatible_path(profile_name)
		if profile_name != self.profile_name.GetLabel():
			setcfg("profile.name", self.profile_name_textctrl.GetValue())
			self.profile_name.SetToolTipString(profile_name)
			self.profile_name.SetLabel(profile_name.replace("&", "&&"))
			setcfg("profile.name.expanded", profile_name)

	def check_profile_name(self, profile_name=None):
		if profile_name is None:
			profile_name = self.profile_name_textctrl.GetValue()
		if (re.match(r"^[^\\/:;*?\"<>|]+$", profile_name) and
			not profile_name.startswith("-")):
			return True
		else:
			return False

	def get_ambient(self):
		if self.ambient_viewcond_adjust_cb.GetValue():
			return str(stripzeros(
				self.ambient_viewcond_adjust_textctrl.GetValue()))
		return None

	def get_argyll_data_files(self, scope, wildcard, include_lastmod=False):
		"""
		Get paths of Argyll data files.
		
		scope should be a string containing "l" (local system) and/or "u" (user)
		
		"""
		data_files = []
		if sys.platform != "darwin":
			if "l" in scope:
				for commonappdata in config.commonappdata:
					data_files += glob.glob(os.path.join(commonappdata, "color",
														 wildcard))
					data_files += glob.glob(os.path.join(commonappdata, "ArgyllCMS",
														 wildcard))
			if "u" in scope:
				data_files += glob.glob(os.path.join(config.appdata, "color",
													 wildcard))
		else:
			if "l" in scope:
				data_files += glob.glob(os.path.join(config.library, "color",
													 wildcard))
				data_files += glob.glob(os.path.join(config.library, "ArgyllCMS",
													 wildcard))
				if (self.worker.argyll_version >= [1, 9] and
					self.worker.argyll_version <= [1, 9, 1]):
					# Argyll CMS 1.9 and 1.9.1 use *nix locations due to a
					# configuration problem
					data_files += glob.glob(os.path.join("/usr/local/share",
														 "ArgyllCMS", wildcard))
			if "u" in scope:
				data_files += glob.glob(os.path.join(config.library_home, "color",
													 wildcard))
				if (self.worker.argyll_version >= [1, 9] and
					self.worker.argyll_version <= [1, 9, 1]):
					# Argyll CMS 1.9 and 1.9.1 use *nix locations due to a
					# configuration problem
					data_files += glob.glob(os.path.join(config.home, ".local", "share",
														 "ArgyllCMS", wildcard))
		if "u" in scope:
			data_files += glob.glob(os.path.join(config.appdata, "ArgyllCMS",
												 wildcard))
		if include_lastmod:
			filenames = list(data_files)
			data_files = []
			for filename in filenames:
				try:
					lastmod = os.stat(filename).st_mtime
				except EnvironmentError:
					lastmod = -1
				data_files.append((filename, lastmod))
		return data_files
	
	def get_instrument_type(self):
		# Return the instrument type, "color" (colorimeter) or "spect" 
		# (spectrometer)
		spect = self.worker.get_instrument_features().get("spectral", False)
		return "spect" if spect else "color"

	def get_measurement_mode(self):
		""" Return the measurement mode as string.
		
		Examples
		
		Argyll options -V -H (adaptive highres mode)
		Returned string 'VH'
		
		Argyll option -yl
		Returned string 'l'
		
		Argyll options -p -H (projector highres mode)
		Returned string 'pH'
		
		"""
		return self.measurement_modes_ab.get(self.get_instrument_type(), {}).get(
			self.measurement_mode_ctrl.GetSelection())

	def get_profile_type(self):
		return self.profile_types_ab.get(self.profile_type_ctrl.GetSelection(),
										 getcfg("profile.type"))

	def get_whitepoint(self):
		if self.whitepoint_ctrl.GetSelection() == 0:
			# Native
			return None
		elif self.whitepoint_ctrl.GetSelection() == 1:
			# Color temperature in kelvin
			return str(stripzeros(
				self.whitepoint_colortemp_textctrl.GetValue().replace(",", 
																	  ".")))
		elif self.whitepoint_ctrl.GetSelection() == 2:
			x = self.whitepoint_x_textctrl.GetValue()
			try:
				x = round(x, 4)
			except ValueError:
				pass
			y = self.whitepoint_y_textctrl.GetValue()
			try:
				y = round(y, 4)
			except ValueError:
				pass
			return str(stripzeros(x)) + "," + str(stripzeros(y))

	def get_whitepoint_locus(self):
		n = self.whitepoint_colortemp_locus_ctrl.GetSelection()
		if not n in self.whitepoint_colortemp_loci_ab:
			n = 0
		return str(self.whitepoint_colortemp_loci_ab[n])

	def get_luminance(self):
		if self.luminance_ctrl.GetSelection() == 0:
			return None
		else:
			return str(stripzeros(self.luminance_textctrl.GetValue()))

	def get_black_luminance(self):
		if self.black_luminance_ctrl.GetSelection() == 0:
			return None
		else:
			return str(stripzeros(
				self.black_luminance_textctrl.GetValue()))

	def get_black_output_offset(self):
		return str(Decimal(self.black_output_offset_ctrl.GetValue()) / 100)

	def get_black_point_correction(self):
		return str(Decimal(self.black_point_correction_ctrl.GetValue()) / 100)

	def get_black_point_rate(self):
		if defaults["calibration.black_point_rate.enabled"]:
			return str(self.black_point_rate_floatctrl.GetValue())
		else:
			return None

	def get_trc_type(self):
		if self.trc_type_ctrl.GetSelection() == 1:
			return "G"
		else:
			return "g"

	def get_trc(self):
		if self.trc_ctrl.GetSelection() in (1, 4, 7):
			return str(stripzeros(self.trc_textctrl.GetValue().replace(",", 
																	   ".")))
		elif self.trc_ctrl.GetSelection() == 2:
			return "l"
		elif self.trc_ctrl.GetSelection() == 3:
			return "709"
		elif self.trc_ctrl.GetSelection() == 5:
			return "240"
		elif self.trc_ctrl.GetSelection() == 6:
			return "s"
		else:
			return ""

	def get_calibration_quality(self):
		return self.quality_ab[self.calibration_quality_ctrl.GetValue()]

	def get_profile_quality(self):
		return self.quality_ab[self.profile_quality_ctrl.GetValue() + 1]

	def profile_settings_changed(self):
		##cal = getcfg("calibration.file", False)
		##if cal:
			##filename, ext = os.path.splitext(cal)
			##if ext.lower() in (".icc", ".icm"):
				##if not os.path.exists(filename + ".cal") and \
				   ##not cal in self.presets:
					##self.cal_changed()
					##return
		if not self.updatingctrls:
			setcfg("settings.changed", 1)
			if self.calibration_file_ctrl.GetStringSelection()[0] != "*":
				sel = self.calibration_file_ctrl.GetSelection()
				if sel > 0:
					items = self.calibration_file_ctrl.GetItems()
					items[sel] = "* " + items[sel]
					self.calibration_file_ctrl.Freeze()
					self.calibration_file_ctrl.SetItems(items)
					self.calibration_file_ctrl.SetSelection(sel)
					self.calibration_file_ctrl.Thaw()

	def testchart_ctrl_handler(self, event):
		if debug:
			safe_print("[D] testchart_ctrl_handler called for ID %s %s event "
					   "type %s %s" % (event.GetId(), 
									   getevtobjname(event, self), 
									   event.GetEventType(), 
									   getevttype(event)))
		self.set_testchart(self.testcharts[self.testchart_ctrl.GetSelection()])
		wx.CallAfter(self.check_testchart_patches_amount)

	def testchart_btn_handler(self, event, path=None):
		if path is None:
			defaultDir, defaultFile = get_verified_path("testchart.file")
			dlg = wx.FileDialog(self, lang.getstr("dialog.set_testchart"), 
								defaultDir=defaultDir, 
								defaultFile=defaultFile, 
								wildcard=lang.getstr("filetype.icc_ti1_ti3") + 
										 "|*.icc;*.icm;*.ti1;*.ti3", 
								style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
			dlg.Center(wx.BOTH)
			result = dlg.ShowModal()
			if result == wx.ID_OK:
				path = dlg.GetPath()
			dlg.Destroy()
		if path:
			if not os.path.exists(path):
				InfoDialog(self, msg=lang.getstr("file.missing", path), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
			filename, ext = os.path.splitext(path)
			if ext.lower() in (".icc", ".icm"):
				try:
					profile = ICCP.ICCProfile(path)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					InfoDialog(self, msg=lang.getstr("profile.invalid") + 
										 "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
				ti3_lines = [line.strip() for 
							 line in StringIO(profile.tags.get("CIED", "") or 
											  profile.tags.get("targ", ""))]
				if not "CTI3" in ti3_lines:
					InfoDialog(self, 
							   msg=lang.getstr("profile.no_embedded_ti3") + 
								   "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
			self.set_testchart(path)
			writecfg()
			self.profile_settings_changed()

	def testchart_patches_amount_ctrl_handler(self, event):
		auto = self.testchart_patches_amount_ctrl.GetValue()
		if event:
			setcfg("testchart.auto_optimize", auto)
			self.profile_settings_changed()
		proftype = getcfg("profile.type")
		if auto >= 3:
			s = min(auto, 11) * 4 - 3
			g = s * 3 - 2
			patches_amount = get_total_patches(4, 4, s, g, auto, auto, 0) + 34
			if auto > 4:
				patches_amount += 120
			elif auto > 3:
				# Increment to 271 patches of default testchart for LUT profiles
				patches_amount += 83
			else:
				# Increment to 154 patches of small testchart for LUT profiles
				patches_amount += 41
			if event and proftype not in ("l", "x", "X"):
				setcfg("profile.type", "x" if getcfg("3dlut.create") else "X")
		else:
			patches_amount = 73
			if event and proftype not in ("g", "G", "s", "S"):
				setcfg("profile.type", "S" if getcfg("trc") else "s")
		if proftype != getcfg("profile.type"):
			self.update_profile_type_ctrl()
			# Reset profile type to previous value so the handler method will
			# recognize a change in profile type and update BPC accordingly
			setcfg("profile.type", proftype)
			self.profile_type_ctrl_handler(None)
		self.testchart_patches_amount.SetLabel(str(patches_amount))
		self.update_estimated_measurement_time("testchart")
		self.update_profile_name()

	def create_testchart_btn_handler(self, event):
		if not hasattr(self, "tcframe"):
			self.init_tcframe()
		elif not hasattr(self.tcframe, "ti1") or \
			 getcfg("testchart.file") not in (self.tcframe.ti1.filename, "auto"):
			self.tcframe.tc_load_cfg_from_ti1(cfg="testchart.file",
				parent_set_chart_methodname="set_testchart")
		setcfg("tc.show", 1)
		self.tcframe.Show()
		self.tcframe.Raise()
		return

	def init_tcframe(self, path=None):
		self.tcframe = TestchartEditor(self, path=path)

	def set_default_testchart(self, alert=True, force=False):
		path = getcfg("testchart.file")
		##print "set_default_testchart", path
		if getcfg("profile.type") in ("l", "x", "X"):
			# cLUT
			if getcfg("testchart.auto_optimize") < 3:
				setcfg("testchart.auto_optimize", 5)
		else:
			# Gamma or shaper + matrix
			if getcfg("testchart.auto_optimize") > 2:
				setcfg("testchart.auto_optimize", 2)
		if path == "auto":
			self.set_testchart(path)
			return
		if os.path.basename(path) in self.dist_testchart_names:
			path = self.dist_testcharts[
				self.dist_testchart_names.index(os.path.basename(path))]
			if debug:
				safe_print("[D] set_default_testchart testchart.file:", path)
			setcfg("testchart.file", path)
		if force or (lang.getstr(os.path.basename(path)) in [""] +
					 self.default_testchart_names) or not os.path.isfile(path):
			if (not force and lang.getstr(os.path.basename(path)) in [""] +
				self.default_testchart_names):
				ti1 = os.path.basename(path)
			else:
				ti1 = self.testchart_defaults[self.get_profile_type()].get(
					self.get_profile_quality(), 
					self.testchart_defaults[self.get_profile_type()][None])
			if ti1 != "auto":
				path = get_data_path(os.path.join("ti1", ti1))
				if not path or not os.path.isfile(path):
					if alert:
						InfoDialog(self, 
								   msg=lang.getstr("error.testchart.missing", ti1), 
								   ok=lang.getstr("ok"), 
								   bitmap=geticon(32, "dialog-error"))
					elif verbose >= 1:
						safe_print(lang.getstr("error.testchart.missing", ti1))
					return False
			else:
				path = ti1
			self.set_testchart(path)
			return True
		return None

	def set_testcharts(self, path=None):
		idx = self.testchart_ctrl.GetSelection()
		self.testchart_ctrl.Freeze()
		self.testchart_ctrl.SetItems(self.get_testchart_names(path))
		self.testchart_ctrl.SetSelection(idx)
		self.testchart_ctrl.Thaw()

	def set_testchart(self, path=None, update_profile_name=True):
		if path is None:
			path = getcfg("testchart.file")
		##print "set_testchart", path
		if path == "auto" and config.get_display_name() == "Untethered":
			self._current_testchart_path = path
			if self.IsShown():
				wx.CallAfter(show_result_dialog,
					UnloggedInfo(lang.getstr("testchart.auto_optimize.untethered.unsupported")),
					self)
			path = getcfg("calibration.file", False)
			if not path or path.lower().endswith(".cal"):
				path = defaults["testchart.file"]
		self.create_testchart_btn.Enable(path != "auto" and
			not getcfg("profile.update"))
		self.menuitem_testchart_edit.Enable(self.create_testchart_btn.Enabled)
		self.testchart_patches_amount_label.Show(path == "auto")
		self.testchart_patches_amount_ctrl.Show(path == "auto")
		if path == "auto":
			if path != getcfg("testchart.file"):
				self.profile_settings_changed()
			setcfg("testchart.file", path)
			if path not in self.testcharts:
				self.set_testcharts(path)
			self.testchart_ctrl.SetSelection(0)
			self.testchart_ctrl.SetToolTipString("")
			self.worker.options_targen = ["-d3"]
			auto = getcfg("testchart.auto_optimize") or 7
			self.testchart_patches_amount_ctrl.SetValue(auto)
			self.testchart_patches_amount_ctrl_handler(None)
			self._current_testchart_path = path
		else:
			self.set_testchart_from_path(path)
		self.check_testchart()
		if update_profile_name:
			self.update_profile_name()

	def set_testchart_from_path(self, path):
		result = check_file_isfile(path)
		if isinstance(result, Exception):
			show_result_dialog(result, self)
			self.set_default_testchart(force=True)
			return
		if getattr(self, "_current_testchart_path", None) == path:
			# Nothing to do
			return
		filename, ext = os.path.splitext(path)
		try:
			if ext.lower() in (".ti1", ".ti3"):
				if ext.lower() == ".ti3":
					ti1 = CGATS.CGATS(ti3_to_ti1(open(path, "rU")))
				else:
					ti1 = CGATS.CGATS(path)
			else: # icc or icm profile
				profile = ICCP.ICCProfile(path)
				ti1 = CGATS.CGATS(ti3_to_ti1(profile.tags.get("CIED", "") or 
											 profile.tags.get("targ", "")))
			try:
				ti1_1 = verify_ti1_rgb_xyz(ti1)
			except CGATS.CGATSError, exception:
				msg = {CGATS.CGATSKeyError: lang.getstr("error.testchart.missing_fields", 
														(path, 
														 "RGB_R, RGB_G, RGB_B, "
														 " XYZ_X, XYZ_Y, XYZ_Z"))}.get(exception.__class__,
																					   lang.getstr("error.testchart.invalid",
																								   path) + 
																					   "\n" + 
																					   lang.getstr(safe_str(exception)))
				InfoDialog(self, 
						   msg=msg, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				self.set_default_testchart(force=True)
				return
			if path != getcfg("calibration.file", False):
				self.profile_settings_changed()
			if debug:
				safe_print("[D] set_testchart testchart.file:", path)
			setcfg("testchart.file", path)
			if path not in self.testcharts:
				self.set_testcharts(path)
			# The case-sensitive index could fail because of 
			# case insensitive file systems, e.g. if the 
			# stored filename string is 
			# "C:\Users\Name\AppData\DisplayCAL\storage\MyFile"
			# but the actual filename is 
			# "C:\Users\Name\AppData\DisplayCAL\storage\myfile"
			# (maybe because the user renamed the file)
			idx = index_fallback_ignorecase(self.testcharts, path)
			self.testchart_ctrl.SetSelection(idx)
			self.testchart_ctrl.SetToolTipString(path)
			if ti1.queryv1("COLOR_REP") and \
			   ti1.queryv1("COLOR_REP")[:3] == "RGB":
				self.worker.options_targen = ["-d3"]
			self.testchart_patches_amount.SetLabel(
				str(ti1.queryv1("NUMBER_OF_SETS")))
			self._current_testchart_path = path
		except Exception, exception:
			error = traceback.format_exc() if debug else exception
			InfoDialog(self, 
					   msg=lang.getstr("error.testchart.read", path) + 
						   "\n\n" + safe_unicode(error), 
					   ok=lang.getstr("ok"), 
					   bitmap=geticon(32, "dialog-error"))
			self.set_default_testchart(force=True)
		else:
			self.update_estimated_measurement_time("testchart")
			if hasattr(self, "tcframe") and \
			   self.tcframe.IsShownOnScreen() and \
			   (not hasattr(self.tcframe, "ti1") or 
				getcfg("testchart.file") != self.tcframe.ti1.filename):
				self.tcframe.tc_load_cfg_from_ti1(cfg="testchart.file",
					parent_set_chart_methodname="set_testchart")

	def check_testchart(self):
		if is_ccxx_testchart():
			self.set_ccxx_measurement_mode()
		else:
			self.restore_measurement_mode()
		self.update_colorimeter_correction_matrix_ctrl()
		if not self.updatingctrls:
			self.update_main_controls()

	def get_testchart_names(self, path=None):
		testchart_names = []
		self.testcharts = []
		if path is None:
			path = getcfg("testchart.file")
		##print "get_testchart_names", path
		if path != "auto" and os.path.exists(path):
			testchart_dir = os.path.dirname(path)
			try:
				testcharts = listdir_re(testchart_dir, 
										"\.(?:icc|icm|ti1|ti3)$")
			except Exception, exception:
				safe_print(u"Error - directory '%s' listing failed: %s" % 
						   tuple(safe_unicode(s) for s in (testchart_dir, 
														   exception)))
			else:
				for testchart_name in testcharts:
					if testchart_name not in testchart_names:
						testchart_names.append(testchart_name)
						self.testcharts.append(os.pathsep.join((testchart_name, 
																testchart_dir)))
		default_testcharts = get_data_path("ti1", "\.(?:icc|icm|ti1|ti3)$")
		if isinstance(default_testcharts, list):
			for testchart in default_testcharts:
				testchart_dir = os.path.dirname(testchart)
				testchart_name = os.path.basename(testchart)
				if testchart_name not in testchart_names:
					testchart_names.append(testchart_name)
					self.testcharts.append(os.pathsep.join((testchart_name, 
															testchart_dir)))
		self.testcharts = ["auto"] + natsort(self.testcharts)
		self.testchart_names = []
		i = 0
		for chart in self.testcharts:
			chart = chart.split(os.pathsep)
			chart.reverse()
			self.testcharts[i] = os.path.join(*chart)
			if chart[-1] == "auto":
				testchart_name = "auto_optimized"
			else:
				testchart_name = chart[-1]
			self.testchart_names.append(lang.getstr(testchart_name))
			i += 1
		return self.testchart_names

	def set_argyll_bin_handler(self, event, silent=False, callafter=None,
							   callafter_args=()):
		""" Set Argyll CMS binary executables directory """
		if (getattr(self.worker, "thread", None) and
			self.worker.thread.isAlive()):
			wx.Bell()
			return
		if ((event and set_argyll_bin(self, silent, callafter, callafter_args)) or
			(not event and check_argyll_bin())):
			self.check_update_controls(True, callafter=callafter,
									   callafter_args=callafter_args)
			if sys.platform == "win32":
				self.send_command("apply-profiles",
								  'setcfg argyll.dir "%s" force' %
								  getcfg("argyll.dir"))

	def check_update_controls(self, event=None, silent=False, callafter=None,
							  callafter_args=()):
		"""
		Update controls and menuitems when changes in displays or instruments
		are detected.
		
		Return True if update was needed and carried out, False otherwise.
		
		"""
		if self.worker.is_working():
			return
		argyll_bin_dir = self.worker.argyll_bin_dir
		argyll_version = list(self.worker.argyll_version)
		displays = list(self.worker.displays)
		comports = list(self.worker.instruments)
		if event:
			enumerate_ports = not isinstance(event, wx.DisplayChangedEvent)
		else:
			# Use configured value
			enumerate_ports = getcfg("enumerate_ports.auto")
		if event or silent:
			args = (self.check_update_controls_consumer, 
					self.check_update_controls_producer)
			kwargs = dict(cargs=(argyll_bin_dir, argyll_version, displays,
								 comports, event, callafter, callafter_args),
						  wkwargs={"silent": True,
								   "enumerate_ports": enumerate_ports,
								   "displays": displays,
								   "profile_loader_load_cal":
								   isinstance(event, wx.DisplayChangedEvent)})
			if silent:
				self.thread = delayedresult.startWorker(*args, **kwargs)
			else:
				kwargs["progress_msg"] = lang.getstr("enumerating_displays_and_comports")
				kwargs["stop_timers"] = False
				kwargs["show_remaining_time"] = False
				kwargs["fancy"] = False
				self.worker.start(*args, **kwargs)
		else:
			self.worker.enumerate_displays_and_ports(silent,
													 enumerate_ports=enumerate_ports)
			return self.check_update_controls_consumer(True, argyll_bin_dir,
													   argyll_version, displays, 
													   comports, event,
													   callafter,
													   callafter_args)

	def check_update_controls_producer(self, silent=False, enumerate_ports=True,
									   displays=None,
									   profile_loader_load_cal=False):
		result = self.worker.enumerate_displays_and_ports(silent,
														  enumerate_ports=enumerate_ports)
		if (sys.platform == "win32" and displays != self.worker.displays and
			profile_loader_load_cal and
			not util_win.calibration_management_isenabled()):
			# Tell profile loader to load calibration
			self.send_command("apply-profiles",
							  "apply-profiles display-changed")
		return result
	
	def check_update_controls_consumer(self, result, argyll_bin_dir,
									   argyll_version, displays, comports,
									   event=None, callafter=None,
									   callafter_args=None):
		if isinstance(result, delayedresult.DelayedResult):
			try:
				result.get()
			except Exception, exception:
				if hasattr(exception, "originalTraceback"):
					error = exception.originalTraceback
				else:
					error = traceback.format_exc()
				result = Error(error)
		if isinstance(result, Exception):
			raise result
		if argyll_bin_dir != self.worker.argyll_bin_dir or \
		   argyll_version != self.worker.argyll_version:
			self.show_advanced_options_handler()
			self.worker.measurement_modes = {}
			self.update_measurement_modes()
			if comports == self.worker.instruments:
				self.update_colorimeter_correction_matrix_ctrl()
			self.update_black_point_rate_ctrl()
			self.update_drift_compensation_ctrls()
			self.update_profile_type_ctrl_items()
			self.profile_type_ctrl.SetSelection(
				self.profile_types_ba.get(getcfg("profile.type"), 
				self.profile_types_ba.get(defaults["profile.type"], 0)))
			self.lut3d_init_input_profiles()
			self.lut3d_update_controls()
			if hasattr(self, "aboutdialog"):
				if self.aboutdialog.IsShownOnScreen():
					self.aboutdialog_handler(None)
			if hasattr(self, "extra_args"):
				self.extra_args.update_controls()
			if hasattr(self, "gamapframe"):
				visible = self.gamapframe.IsShownOnScreen()
				self.gamapframe.Close()
				self.gamapframe.Destroy()
				del self.gamapframe
				if visible:
					self.gamap_btn_handler(None)
			if getattr(self, "lut3dframe", None):
				visible = self.lut3dframe.IsShownOnScreen()
				self.lut3dframe.Close()
				self.lut3dframe.Destroy()
				del self.lut3dframe
				if visible:
					self.lut3d_create_handler(None)
			if getattr(self, "reportframe", None):
				visible = self.reportframe.IsShownOnScreen()
				self.reportframe.Close()
				self.reportframe.Destroy()
				del self.reportframe
				if visible:
					self.measurement_report_create_handler(None)
			if hasattr(self, "tcframe"):
				visible = self.tcframe.IsShownOnScreen()
				self.tcframe.tc_close_handler()
				self.tcframe.Destroy()
				del self.tcframe
				if visible:
					self.create_testchart_btn_handler(None)
		if displays != self.worker.displays:
			self.update_displays(update_ccmx_items=True)
			if verbose >= 1: safe_print(lang.getstr("display_detected"))
		if comports != self.worker.instruments:
			self.update_comports()
			if verbose >= 1: safe_print(lang.getstr("comport_detected"))
			if event and not callafter:
				# Check if we should import colorimeter corrections
				# or other instrument setup
				self.check_instrument_setup()
		if displays != self.worker.displays or \
		   comports != self.worker.instruments:
			if self.IsShownOnScreen():
				self.update_menus()
			self.update_main_controls()
			returnvalue = True
		else:
			returnvalue = False
		if len(self.worker.displays):
			if getcfg("calibration.file", False):
				# Load LUT curves from last used .cal file
				self.load_cal(silent=True)
			else:
				# Load LUT curves from current display profile (if any, 
				# and if it contains curves)
				self.load_display_profile_cal(None)
		if callafter:
			callafter(*callafter_args)
		return returnvalue

	def check_instrument_setup(self, callafter=None, callafter_args=()):
		# Check if we should import colorimeter corrections
		# or do other instrument specific setup
		if getcfg("colorimeter_correction_matrix_file") in ("AUTO:", ""):
			# Check for applicable corrections
			ccmx_instruments = self.ccmx_instruments.itervalues()
			i1d3 = ("i1 DisplayPro, ColorMunki Display" in
					self.worker.instruments and
					not "" in ccmx_instruments)
			icd = (("DTP94" in self.worker.instruments and
					not "DTP94" in ccmx_instruments) or
				   ("i1 Display 2" in self.worker.instruments and
					not "i1 Display 2" in ccmx_instruments) or
				   ("Spyder2" in self.worker.instruments and
					not "Spyder2" in ccmx_instruments) or
				   ("Spyder3" in self.worker.instruments and
					not "Spyder3" in ccmx_instruments))
		else:
			# Already using a suitable correction
			i1d3 = False
			icd = False
		spyd2 = ("Spyder2" in self.worker.instruments and
				 not self.worker.spyder2_firmware_exists())
		spyd4 = (("Spyder4" in self.worker.instruments or
				  "Spyder5" in self.worker.instruments) and
				 not self.worker.spyder4_cal_exists())
		if spyd2:
			spyd2 = self.enable_spyder2_handler(True,
												i1d3 or icd or spyd4,
												callafter=callafter,
												callafter_args=callafter_args)
		result = spyd2
		if not spyd2 and (i1d3 or icd or spyd4):
			result = self.import_colorimeter_corrections_handler(True,
				callafter=callafter, callafter_args=callafter_args)
		if not result and callafter:
			callafter(*callafter_args)

	def load_cal_handler(self, event, path=None, update_profile_name=True, 
						 silent=False, load_vcgt=True):
		""" Load settings and calibration """
		if not check_set_argyll_bin():
			return
		if path is None:
			wildcard = lang.getstr("filetype.cal_icc") + "|*.cal;*.icc;*.icm"
			sevenzip = get_program_file("7z", "7-zip")
			if sevenzip:
				wildcard += ";*.7z"
			wildcard += ";*.tar.gz;*.tgz;*.zip"
			defaultDir, defaultFile = get_verified_path("last_cal_or_icc_path")
			dlg = wx.FileDialog(self, lang.getstr("dialog.load_cal"), 
								defaultDir=defaultDir, defaultFile=defaultFile, 
								wildcard=wildcard, 
								style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
			dlg.Center(wx.BOTH)
			if dlg.ShowModal() == wx.ID_OK:
				path = dlg.GetPath()
			dlg.Destroy()
		if path:
			if getcfg("settings.changed") and not self.settings_confirm_discard():
				return
			if not os.path.exists(path):
				sel = self.calibration_file_ctrl.GetSelection()
				if len(self.recent_cals) > sel and \
				   self.recent_cals[sel] == path:
					self.recent_cals.remove(self.recent_cals[sel])
					recent_cals = []
					for recent_cal in self.recent_cals:
						if recent_cal not in self.presets:
							recent_cals.append(recent_cal)
					setcfg("recent_cals", os.pathsep.join(recent_cals))
					self.calibration_file_ctrl.Delete(sel)
					cal = getcfg("calibration.file", False) or ""
					if not cal in self.recent_cals:
						self.recent_cals.append(cal)
					# The case-sensitive index could fail because of 
					# case insensitive file systems, e.g. if the 
					# stored filename string is 
					# "C:\Users\Name\AppData\DisplayCAL\storage\MyFile"
					# but the actual filename is 
					# "C:\Users\Name\AppData\DisplayCAL\storage\myfile"
					# (maybe because the user renamed the file)
					idx = index_fallback_ignorecase(self.recent_cals, cal)
					self.calibration_file_ctrl.SetSelection(idx)
				InfoDialog(self, msg=lang.getstr("file.missing", path), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return

			filename, ext = os.path.splitext(path)
			if ext.lower() in (".7z", ".tar.gz", ".tgz", ".zip"):
				self.import_session_archive(path)
				return
			if ext.lower() in (".icc", ".icm"):
				try:
					profile = ICCP.ICCProfile(path)
				except (IOError, ICCP.ICCProfileInvalidError), exception:
					InfoDialog(self, msg=lang.getstr("profile.invalid") + 
										 "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
				if profile.profileClass != "mntr" or \
				   profile.colorSpace != "RGB":
					InfoDialog(self, msg=lang.getstr("profile.unsupported", 
													 (profile.profileClass, 
													  profile.colorSpace)) + 
										 "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
				cal = StringIO(profile.tags.get("CIED", "") or 
							   profile.tags.get("targ", ""))
			else:
				try:
					cal = open(path, "rU")
				except Exception, exception:
					InfoDialog(self, msg=lang.getstr("error.file.open", path), 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
			ti3_lines = [line.strip() for line in cal]
			cal.close()
			setcfg("last_cal_or_icc_path", path)
			update_ccmx_items = True
			set_size = True
			display_match = False
			instrument_id = None
			instrument_match = False
			if ext.lower() in (".icc", ".icm"):
				setcfg("last_icc_path", path)
				if path not in self.presets:
					setcfg("3dlut.output.profile", path)
					setcfg("measurement_report.output_profile", path)
				# Disable 3D LUT tab when switching from madVR / Resolve
				setcfg("3dlut.tab.enable", 0)
				setcfg("3dlut.tab.enable.backup", 0)
				(options_dispcal, 
				 options_colprof) = get_options_from_profile(profile)
				# Get and set the display
				# First try to find the correct display by comparing
				# the model (if present)
				display_name = profile.getDeviceModelDescription()
				# Second try to find the correct display by comparing
				# the EDID hash (if present)
				edid_md5 = profile.tags.get("meta", {}).get("EDID_md5",
															{}).get("value")
				if display_name or edid_md5:
					display_name_indexes = []
					edid_md5_indexes = []
					for i, edid in enumerate(self.worker.display_edid):
						if display_name in (edid.get("monitor_name", False),
											self.worker.display_names[i]):
							display_name_indexes.append(i)
						if edid_md5 == edid.get("hash", False):
							edid_md5_indexes.append(i)
					if len(display_name_indexes) == 1:
						display_index = display_name_indexes[0]
						safe_print("Found display device matching model "
								   "description at index #%i" % display_index)
					elif len(edid_md5_indexes) == 1:
						display_index = edid_md5_indexes[0]
						safe_print("Found display device matching EDID MD5 "
								   "at index #%i" % display_index)
					else:
						# We got several matches. As we can't be sure which
						# is the right one, do nothing.
						display_index = None
					if display_index is not None:
						# Found it
						display_match = True
						setcfg("display.number", display_index + 1)
						self.get_set_display()
						if config.get_display_name() in ("madVR", "Resolve",
														 "SII REPEATER"):
							# Don't disable 3D LUT tab when switching from
							# madVR / Resolve / eeColor
							setcfg("3dlut.tab.enable.backup", 1)
				# Get and set the instrument
				instrument_id = profile.tags.get("meta",
												 {}).get("MEASUREMENT_device",
														 {}).get("value")
				if instrument_id:
					for i, instrument in enumerate(self.worker.instruments):
						if instrument.lower() == instrument_id:
							# Found it
							instrument_match = True
							setcfg("comport.number", i + 1)
							self.update_comports()
							# No need to update ccmx items in update_controls,
							# as comport_ctrl_handler took care of it
							update_ccmx_items = False
							# comport_ctrl_handler already called set_size
							set_size = False
							break
			else:
				try:
					(options_dispcal, 
					 options_colprof) = get_options_from_cal(path)
				except (IOError, CGATS.CGATSError), exception:
					InfoDialog(self, msg=lang.getstr("calibration.file.invalid") + 
										 "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
					return
			black_point_correction = False
			if options_dispcal or options_colprof:
				if debug:
					safe_print("[D] options_dispcal:", options_dispcal)
				if debug:
					safe_print("[D] options_colprof:", options_colprof)
				ccxxsetting = getcfg("colorimeter_correction_matrix_file").split(":", 1)[0]
				ccmx = None
				# Check if TRC was set
				trc = False
				if options_dispcal:
					for o in options_dispcal:
						if o[0] in ("g", "G"):
							trc = True
				# Restore defaults
				self.restore_defaults_handler(
					include=("calibration", 
							 "drift_compensation", 
							 "measure.darken_background", 
							 "measure.override_min_display_update_delay_ms",
							 "measure.min_display_update_delay_ms",
							 "measure.override_display_settle_time_mult",
							 "measure.display_settle_time_mult",
							 "observer",
							 "trc", 
							 "whitepoint"), 
					exclude=("calibration.black_point_correction_choice.show", 
							 "calibration.update", 
							 "calibration.use_video_lut",
							 "measure.darken_background.show_warning", 
							 "trc.should_use_viewcond_adjust.show_msg"),
					override={"trc": ""} if not trc else None)
				# Parse options
				if options_dispcal:
					self.worker.options_dispcal = ["-" + arg for arg 
												   in options_dispcal]
					for o in options_dispcal:
						if o[0] == "d" and o[1:] in ("web", "madvr"):
							# Special case web and madvr so it can be used in
							# preset templates which are TI3 files
							for i, display_name in enumerate(self.worker.display_names):
								if (display_name.lower() == o[1:] and
									getcfg("display.number") != i + 1):
									# Found it
									display_match = True
									setcfg("display.number", i + 1)
									self.get_set_display()
									break
							continue
						if o[0] == "m":
							setcfg("calibration.interactive_display_adjustment", 0)
							continue
						##if o[0] == "o":
							##setcfg("profile.update", 1)
							##continue
						##if o[0] == "u":
							##setcfg("calibration.update", 1)
							##continue
						if o[0] == "q":
							setcfg("calibration.quality", o[1])
							continue
						if o[0] == "y" and getcfg("measurement_mode") != "auto":
							setcfg("measurement_mode", o[1])
							continue
						if o[0] in ("t", "T"):
							setcfg("whitepoint.colortemp.locus", o[0])
							if o[1:]:
								setcfg("whitepoint.colortemp",
									   int(float(o[1:])))
							setcfg("whitepoint.x", None)
							setcfg("whitepoint.y", None)
							continue
						if o[0] == "w":
							o = o[1:].split(",")
							setcfg("whitepoint.colortemp", None)
							setcfg("whitepoint.x", o[0])
							setcfg("whitepoint.y", o[1])
							continue
						if o[0] == "b":
							setcfg("calibration.luminance", o[1:])
							continue
						if o[0] in ("g", "G"):
							setcfg("trc.type", o[0])
							setcfg("trc", o[1:])
							continue
						if o[0] == "f":
							setcfg("calibration.black_output_offset", 
								   o[1:])
							continue
						if o[0] == "a":
							setcfg("calibration.ambient_viewcond_adjust", 1)
							setcfg("calibration.ambient_viewcond_adjust.lux", o[1:])
							continue
						if o[0] == "k":
							if stripzeros(o[1:]) >= 0:
								black_point_correction = True
								setcfg("calibration.black_point_correction",
									   o[1:])
							continue
						if o[0] == "A":
							setcfg("calibration.black_point_rate", 
								   o[1:])
							continue
						if o[0] == "B":
							setcfg("calibration.black_luminance", 
								   o[1:])
							continue
						if o[0] in ("p", "P") and len(o[1:]) >= 5:
							setcfg("dimensions.measureframe", o[1:])
							setcfg("dimensions.measureframe.unzoomed", 
								   o[1:])
							continue
						if o[0] == "V":
							setcfg("measurement_mode.adaptive", 1)
							continue
						if o[0:2] == "YA":
							setcfg("measurement_mode.adaptive", 0)
							continue
						if o[0] == "H":
							setcfg("measurement_mode.highres", 1)
							continue
						if o[0] == "p" and len(o[1:]) == 0:
							setcfg("measurement_mode.projector", 1)
							continue
						if o[0] == "F":
							setcfg("measure.darken_background", 1)
							continue
						if o[0] == "X":
							o = o.split(None, 1)
							ccmx = o[-1][1:-1]
							if not os.path.isabs(ccmx):
								ccmx = os.path.join(os.path.dirname(path), ccmx)
							# Need to update ccmx items again even if
							# comport_ctrl_handler already did
							update_ccmx_items = True
							continue
						if o[0] == "I":
							if "b" in o[1:]:
								setcfg("drift_compensation.blacklevel", 1)
							if "w" in o[1:]:
								setcfg("drift_compensation.whitelevel", 1)
							continue
						if o[0] == "Q":
							setcfg("observer", o[1:])
							# Need to update ccmx items again even if
							# comport_ctrl_handler already did because CCMX
							# observer may override calibration observer
							update_ccmx_items = True
							continue
					if trc and not black_point_correction:
						setcfg("calibration.black_point_correction.auto", 1)
				if not ccmx:
					ccxx = (glob.glob(os.path.join(os.path.dirname(path), "*.ccmx")) or
							glob.glob(os.path.join(os.path.dirname(path), "*.ccss")))
					if ccxx and len(ccxx) == 1:
						ccmx = ccxx[0]
						update_ccmx_items = True
				if ccmx:
					setcfg("colorimeter_correction_matrix_file",
						   "%s:%s" % (ccxxsetting, ccmx))
				if options_colprof:
					# restore defaults
					self.restore_defaults_handler(
						include=("profile", "gamap_", "3dlut.create",
								 "3dlut.output.profile.apply_cal",
								 "3dlut.trc", "testchart.auto_optimize"), 
						exclude=("3dlut.tab.enable.backup", "profile.update",
								 "profile.name", "gamap_default_intent"))
					for o in options_colprof:
						if o[0] == "q":
							setcfg("profile.quality", o[1])
							continue
						if o[0] == "b":
							setcfg("profile.quality.b2a", o[1] or "l")
							continue
						if o[0] == "a":
							setcfg("profile.type", o[1])
							continue
						if o[0] in ("s", "S"):
							o = o.split(None, 1)
							setcfg("gamap_profile", o[-1][1:-1])
							setcfg("gamap_perceptual", 1)
							if o[0] == "S":
								setcfg("gamap_saturation", 1)
							continue
						if o[0] == "c":
							setcfg("gamap_src_viewcond", o[1:])
							continue
						if o[0] == "d":
							setcfg("gamap_out_viewcond", o[1:])
							continue
						if o[0] == "t":
							setcfg("gamap_perceptual_intent", o[1:])
							continue
						if o[0] == "T":
							setcfg("gamap_saturation_intent", o[1:])
							continue
				setcfg("calibration.file", path)
				if "CTI3" in ti3_lines:
					if debug:
						safe_print("[D] load_cal_handler testchart.file:", path)
					setcfg("testchart.file", path)
				if 'USE_BLACK_POINT_COMPENSATION "YES"' in ti3_lines:
					setcfg("profile.black_point_compensation", 1)
				elif 'USE_BLACK_POINT_COMPENSATION "NO"' in ti3_lines:
					setcfg("profile.black_point_compensation", 0)
				if 'HIRES_B2A "YES"' in ti3_lines:
					setcfg("profile.b2a.hires", 1)
				elif 'HIRES_B2A "NO"' in ti3_lines:
					setcfg("profile.b2a.hires", 0)
				if 'SMOOTH_B2A "YES"' in ti3_lines:
					if not 'HIRES_B2A "NO"' in ti3_lines:
						setcfg("profile.b2a.hires", 1)
					setcfg("profile.b2a.hires.smooth", 1)
				elif 'SMOOTH_B2A "NO"' in ti3_lines:
					if not 'HIRES_B2A "YES"' in ti3_lines:
						setcfg("profile.b2a.hires", 0)
					setcfg("profile.b2a.hires.smooth", 0)
				if 'BEGIN_DATA_FORMAT' in ti3_lines:
					cfgend = ti3_lines.index('BEGIN_DATA_FORMAT')
					cfgpart = CGATS.CGATS("\n".join(ti3_lines[:cfgend]))
					lut3d_trc_set = False
					for keyword, cfgname in {"SMOOTH_B2A_SIZE":
											 "profile.b2a.hires.size",
											 "HIRES_B2A_SIZE":
											 "profile.b2a.hires.size",
											 "MIN_DISPLAY_UPDATE_DELAY_MS":
											 "measure.min_display_update_delay_ms",
											 "DISPLAY_SETTLE_TIME_MULT":
											 "measure.display_settle_time_mult",
											 "AUTO_OPTIMIZE":
											 "testchart.auto_optimize",
											 "3DLUT_SOURCE_PROFILE":
											 "3dlut.input.profile",
											 "3DLUT_TRC":
											 "3dlut.trc",
											 "3DLUT_HDR_PEAK_LUMINANCE":
											 "3dlut.hdr_peak_luminance",
											 "3DLUT_HDR_MAXCLL":
											 "3dlut.hdr_maxcll",
											 "3DLUT_GAMMA":
											 "3dlut.trc_gamma",
											 "3DLUT_DEGREE_OF_BLACK_OUTPUT_OFFSET":
											 "3dlut.trc_output_offset",
											 "3DLUT_INPUT_ENCODING":
											 "3dlut.encoding.input",
											 "3DLUT_OUTPUT_ENCODING":
											 "3dlut.encoding.output",
											 "3DLUT_GAMUT_MAPPING_MODE":
											 "3dlut.gamap.use_b2a",
											 "3DLUT_RENDERING_INTENT":
											 "3dlut.rendering_intent",
											 "3DLUT_FORMAT":
											 "3dlut.format",
											 "3DLUT_SIZE":
											 "3dlut.size",
											 "3DLUT_INPUT_BITDEPTH":
											 "3dlut.bitdepth.input",
											 "3DLUT_OUTPUT_BITDEPTH":
											 "3dlut.bitdepth.output",
											 "3DLUT_APPLY_CAL":
											 "3dlut.output.profile.apply_cal"}.iteritems():
						cfgvalue = cfgpart.queryv1(keyword)
						if keyword in ("MIN_DISPLAY_UPDATE_DELAY_MS",
									   "DISPLAY_SETTLE_TIME_MULT"):
							backup = getcfg("measure.override_%s.backup" %
											keyword.lower(), False)
							if (cfgvalue is not None and display_match and
								(instrument_match or not instrument_id)):
								# Only set display update delay if a matching
								# display/instrument stored in profile meta
								# tag or no instrument ID (i.e. a preset)
								if backup is None:
									setcfg("measure.override_%s.backup" %
										   keyword.lower(),
										   getcfg("measure.override_" +
												  keyword.lower()))
									setcfg("measure.%s.backup" %
										   keyword.lower(),
										   getcfg("measure." +
												  keyword.lower()))
								setcfg("measure.override_" + keyword.lower(), 1)
							elif backup is not None:
								setcfg("measure.override_" +
									   keyword.lower(), backup)
								cfgvalue = getcfg("measure.%s.backup" %
												  keyword.lower())
								setcfg("measure.override_%s.backup" %
									   keyword.lower(), None)
								setcfg("measure.%s.backup" %
									   keyword.lower(), None)
						elif cfgvalue is not None:
							if keyword == "AUTO_OPTIMIZE" and cfgvalue:
								setcfg("testchart.file", "auto")
							elif keyword == "3DLUT_GAMMA":
								try:
									cfgvalue = float(cfgvalue)
								except:
									pass
								else:
									if cfgvalue < 0:
										gamma_type = "B"
										cfgvalue = abs(cfgvalue)
									else:
										gamma_type = "b"
									setcfg("3dlut.trc_gamma_type", gamma_type)
									# Sync measurement report settings
									setcfg("measurement_report.trc_gamma_type",
										   gamma_type)
									setcfg("measurement_report.apply_black_offset", 0)
									setcfg("measurement_report.apply_trc", 1)
							elif keyword == "3DLUT_GAMUT_MAPPING_MODE":
								if cfgvalue == "G":
									cfgvalue = 0
								else:
									cfgvalue = 1
							if keyword.startswith("3DLUT"):
								setcfg("3dlut.create", 1)
								setcfg("3dlut.tab.enable", 1)
								setcfg("3dlut.tab.enable.backup", 1)
						if cfgvalue is not None:
							cfgvalue = safe_unicode(cfgvalue, "UTF-7")
							setcfg(cfgname, cfgvalue)
							# Sync measurement report settings
							if cfgname == "3dlut.input.profile":
								setcfg("measurement_report.simulation_profile",
									   cfgvalue)
								setcfg("measurement_report.use_simulation_profile", 1)
								setcfg("measurement_report.use_simulation_profile_as_output", 1)
							elif cfgname in ("3dlut.trc_gamma",
											 "3dlut.trc_output_offset"):
								cfgname = cfgname.replace("3dlut",
														  "measurement_report")
								setcfg(cfgname, cfgvalue)
							elif cfgname == "3dlut.format":
								if cfgvalue == "madVR":
									setcfg("3dlut.enable", 1)
								if cfgvalue in ("eeColor", "madVR"):
									setcfg("measurement_report.use_devlink_profile", 0)
							elif cfgname == "3dlut.trc":
								lut3d_trc_set = True
					# Make sure 3D LUT TRC enumeration matches parameters for
					# older profiles not containing 3DLUT_TRC
					if not lut3d_trc_set:
						if (getcfg("3dlut.trc_gamma_type") == "B" and
							getcfg("3dlut.trc_output_offset") == 0 and
							getcfg("3dlut.trc_gamma") == 2.4):
							setcfg("3dlut.trc", "bt1886")  # BT.1886
						elif (getcfg("3dlut.trc_gamma_type") == "b" and
							getcfg("3dlut.trc_output_offset") == 1 and
							getcfg("3dlut.trc_gamma") == 2.2):
							setcfg("3dlut.trc", "gamma2.2")  # Pure power gamma 2.2
						else:
							setcfg("3dlut.trc", "customgamma")  # Custom
				if not display_match:
					self.update_menus()
					if not update_ccmx_items:
						self.update_estimated_measurement_time("cal")
				self.lut3d_set_path()
				if config.get_display_name() == "Resolve":
					setcfg("3dlut.enable", 0)
					setcfg("measurement_report.use_devlink_profile", 1)
				elif config.get_display_name(None, True) == "Prisma":
					setcfg("3dlut.enable", 1)
					setcfg("measurement_report.use_devlink_profile", 0)
				self.update_controls(
					update_profile_name=update_profile_name,
					update_ccmx_items=update_ccmx_items)
				if set_size:
					self.set_size(True)
				writecfg()

				if ext.lower() in (".icc", ".icm"):
					if load_vcgt:
						# load calibration into lut
						self.load_cal(silent=True)
					if options_dispcal and options_colprof:
						return
					elif options_dispcal:
						msg = lang.getstr("settings_loaded.cal_and_lut")
					else:
						msg = lang.getstr("settings_loaded.profile_and_lut")
				elif options_dispcal and options_colprof:
					msg = lang.getstr("settings_loaded.cal_and_profile")
				elif options_dispcal:
					if not load_vcgt:
						msg = lang.getstr("settings_loaded.cal")
					else:
						# load calibration into lut
						self.load_cal(silent=True)
						msg = lang.getstr("settings_loaded.cal_and_lut")
				else:
					msg = lang.getstr("settings_loaded.profile")

				#if not silent:
					#InfoDialog(self, msg=msg + "\n" + path, ok=lang.getstr("ok"), 
							   #bitmap=geticon(32, "dialog-information"))
				return
			elif ext.lower() in (".icc", ".icm"):
				sel = self.calibration_file_ctrl.GetSelection()
				if len(self.recent_cals) > sel and self.recent_cals[sel] == path:
					self.recent_cals.remove(self.recent_cals[sel])
					self.calibration_file_ctrl.Delete(sel)
					cal = getcfg("calibration.file", False) or ""
					if not cal in self.recent_cals:
						self.recent_cals.append(cal)
					# The case-sensitive index could fail because of 
					# case insensitive file systems, e.g. if the 
					# stored filename string is 
					# "C:\Users\Name\AppData\DisplayCAL\storage\MyFile"
					# but the actual filename is 
					# "C:\Users\Name\AppData\DisplayCAL\storage\myfile"
					# (maybe because the user renamed the file)
					idx = index_fallback_ignorecase(self.recent_cals, cal)
					self.calibration_file_ctrl.SetSelection(idx)
				if not silent:
					InfoDialog(self, msg=lang.getstr("no_settings") + 
										 "\n" + path, 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
				return

			# Old .cal file without ARGYLL_DISPCAL_ARGS section
			
			setcfg("last_cal_path", path)

			# Restore defaults
			self.restore_defaults_handler(
				include=("calibration", 
						 "profile.update", 
						 "measure.override_min_display_update_delay_ms",
						 "measure.min_display_update_delay_ms",
						 "measure.override_display_settle_time_mult",
						 "measure.display_settle_time_mult",
						 "trc", 
						 "whitepoint"), 
				exclude=("calibration.black_point_correction_choice.show", 
						 "calibration.update", 
						 "trc.should_use_viewcond_adjust.show_msg"))

			self.worker.options_dispcal = []
			settings = []
			for line in ti3_lines:
				line = line.strip().split(" ", 1)
				if len(line) > 1:
					value = line[1][1:-1] # strip quotes
					if line[0] == "DEVICE_CLASS":
						if value != "DISPLAY":
							InfoDialog(self, 
									   msg=lang.getstr(
										   "calibration.file.invalid") + 
										   "\n" + path, 
									   ok=lang.getstr("ok"), 
									   bitmap=geticon(32, "dialog-error"))
							return
					elif line[0] == "DEVICE_TYPE":
						measurement_mode = value.lower()[0]
						if measurement_mode in ("c", "l"):
							setcfg("measurement_mode", measurement_mode)
							self.worker.options_dispcal.append("-y" + 
															   measurement_mode)
					elif line[0] == "NATIVE_TARGET_WHITE":
						setcfg("whitepoint.colortemp", None)
						setcfg("whitepoint.x", None)
						setcfg("whitepoint.y", None)
						settings.append(lang.getstr("whitepoint"))
					elif line[0] == "TARGET_WHITE_XYZ":
						XYZ = value.split()
						i = 0
						try:
							for component in XYZ:
								# Normalize to 0.0 - 1.0
								XYZ[i] = float(component) / 100
								i += 1
						except ValueError, exception:
							continue
						x, y, Y = XYZ2xyY(XYZ[0], XYZ[1], XYZ[2])
						k = XYZ2CCT(XYZ[0], XYZ[1], XYZ[2])
						if not lang.getstr("whitepoint") in settings:
							setcfg("whitepoint.colortemp", None)
							setcfg("whitepoint.x", round(x, 4))
							setcfg("whitepoint.y", round(y, 4))
							self.worker.options_dispcal.append(
								"-w%s,%s" % (getcfg("whitepoint.x"), 
											 getcfg("whitepoint.y")))
							settings.append(lang.getstr("whitepoint"))
						setcfg("calibration.luminance", 
							   stripzeros(round(Y * 100, 3)))
						self.worker.options_dispcal.append(
							"-b%s" % getcfg("calibration.luminance"))
						settings.append(lang.getstr("calibration.luminance"))
					elif line[0] == "TARGET_GAMMA":
						setcfg("trc", None)
						if value in ("L_STAR", "REC709", "SMPTE240M", "sRGB"):
							setcfg("trc.type", "g")
						if value == "L_STAR":
							setcfg("trc", "l")
						elif value == "REC709":
							setcfg("trc", "709")
						elif value == "SMPTE240M":
							setcfg("trc", "240")
						elif value == "sRGB":
							setcfg("trc", "s")
						else:
							try:
								value = stripzeros(value)
								if float(value) < 0:
									setcfg("trc.type", "G")
									value = abs(value)
								else:
									setcfg("trc.type", "g")
								setcfg("trc", value)
							except ValueError:
								continue
						self.worker.options_dispcal.append(
							"-" + getcfg("trc.type") + str(getcfg("trc")))
						settings.append(lang.getstr("trc"))
					elif line[0] == "DEGREE_OF_BLACK_OUTPUT_OFFSET":
						setcfg("calibration.black_output_offset", 
							   stripzeros(value))
						self.worker.options_dispcal.append(
							"-f%s" % getcfg("calibration.black_output_offset"))
						settings.append(
							lang.getstr("calibration.black_output_offset"))
					elif line[0] == "BLACK_POINT_CORRECTION":
						if stripzeros(value) >= 0:
							black_point_correction = True
							setcfg("calibration.black_point_correction", 
								   stripzeros(value))
							self.worker.options_dispcal.append(
								"-k%s" % 
								getcfg("calibration.black_point_correction"))
						settings.append(
							lang.getstr("calibration.black_point_correction"))
					elif line[0] == "TARGET_BLACK_BRIGHTNESS":
						setcfg("calibration.black_luminance", 
							   stripzeros(value))
						self.worker.options_dispcal.append(
							"-B%s" % getcfg("calibration.black_luminance"))
						settings.append(lang.getstr("calibration.black_luminance"))
					elif line[0] == "QUALITY":
						setcfg("calibration.quality", value.lower()[0])
						self.worker.options_dispcal.append(
							"-q" + getcfg("calibration.quality"))
						settings.append(lang.getstr("calibration.quality"))
			if not black_point_correction:
				setcfg("calibration.black_point_correction.auto", 1)

			setcfg("calibration.file", path)
			self.update_controls(update_profile_name=update_profile_name)
			if "CTI3" in ti3_lines:
				if debug:
					safe_print("[D] load_cal_handler testchart.file:", path)
				setcfg("testchart.file", path)
			writecfg()
			if load_vcgt:
				# load calibration into lut
				self.load_cal(silent=True)
			if len(settings) == 0:
				msg = lang.getstr("no_settings")
			else:
				msg = lang.getstr("settings_loaded", ", ".join(settings))
			if not silent and len(settings) == 0:
				InfoDialog(self, msg=msg + "\n" + path, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-information"))
				if (load_vcgt and getattr(self, "lut_viewer", None) and
					sys.platform == "win32"):
					# Needed under Windows when using double buffering
					self.lut_viewer.Refresh()

	def delete_calibration_handler(self, event):
		cal = getcfg("calibration.file", False)
		if cal and os.path.exists(cal):
			caldir = os.path.dirname(cal)
			try:
				dircontents = os.listdir(caldir)
			except Exception, exception:
				InfoDialog(self, msg=safe_unicode(exception), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				return
			self.related_files = {}
			for entry in dircontents:
				fn, ext = os.path.splitext(entry)
				if ext.lower() in (".app", script_ext):
					fn, ext = os.path.splitext(fn)
				if (fn.startswith(os.path.splitext(os.path.basename(cal))[0]) or
					ext.lower() in (".ccss", ".ccmx")):
					self.related_files[entry] = True
			self.dlg = dlg = ConfirmDialog(
				self, msg=lang.getstr("dialog.confirm_delete"), 
				ok=lang.getstr("delete"), cancel=lang.getstr("cancel"), 
				bitmap=geticon(32, "dialog-warning"))
			if self.related_files:
				scale = getcfg("app.dpi") / config.get_default_dpi()
				if scale < 1:
					scale = 1
				scrolled = ScrolledPanel(dlg, -1, style=wx.VSCROLL)
				sizer = scrolled.Sizer = wx.BoxSizer(wx.VERTICAL)
				dlg.sizer3.Add(scrolled, flag=wx.TOP | wx.EXPAND, border=12)
				for i, related_file in enumerate(self.related_files):
					if i:
						sizer.Add((0, 4))
					chk = wx.CheckBox(scrolled, -1, related_file)
					chk.SetValue(self.related_files[related_file])
					dlg.Bind(wx.EVT_CHECKBOX, 
							 self.delete_calibration_related_handler, 
							 id=chk.GetId())
					sizer.Add(chk, flag=wx.ALIGN_LEFT)
				scrolled.SetupScrolling()
				scrolled.MinSize = (min(scrolled.GetVirtualSize()[0] + 4 * scale +
										wx.SystemSettings_GetMetric(wx.SYS_VSCROLL_X),
										self.GetDisplay().ClientArea[2] -
										(12 * 3 + 32) * scale),
									min(((chk.Size[1] + 4) *
										 min(len(self.related_files),
											 20) - 4) * scale,
										max(self.GetDisplay().ClientArea[3] -
											dlg.Size[1] - 40 * scale,
											chk.Size[1])))
				dlg.sizer0.SetSizeHints(dlg)
				dlg.sizer0.Layout()
				dlg.Center()
			result = dlg.ShowModal()
			dlg.Destroy()
			if result == wx.ID_OK:
				delete_related_files = []
				if self.related_files:
					for related_file in self.related_files:
						if self.related_files[related_file]:
							delete_related_files.append(
								os.path.join(os.path.dirname(cal), 
											 related_file))
				if sys.platform == "darwin":
					trashcan = lang.getstr("trashcan.mac")
				elif sys.platform == "win32":
					trashcan = lang.getstr("trashcan.windows")
				else:
					trashcan = lang.getstr("trashcan.linux")
				orphan_related_files = delete_related_files
				try:
					if (sys.platform == "darwin" and 
						len(delete_related_files) + 1 == len(dircontents) and 
						".DS_Store" in dircontents) or \
					   len(delete_related_files) == len(dircontents):
						# Delete whole folder
						deleted = trash([os.path.dirname(cal)])
					else:
						deleted = trash(delete_related_files)
					orphan_related_files = filter(lambda related_file:  
												  os.path.exists(related_file), 
												  delete_related_files)
					if orphan_related_files:
						InfoDialog(self, 
								   msg=lang.getstr("error.deletion", trashcan) + 
									   "\n\n" + 
									   "\n".join(os.path.basename(related_file) 
												 for related_file in 
												 orphan_related_files), 
								   ok=lang.getstr("ok"), 
								   bitmap=geticon(32, "dialog-error"))
				except TrashAborted, exception:
					if exception.args[0] == -1:
						# Whole operation was aborted
						return
				except TrashcanUnavailableError, exception:
					InfoDialog(self, 
							   msg=lang.getstr("error.trashcan_unavailable", 
											   trashcan), 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
				except Exception, exception:
					InfoDialog(self, 
							   msg=lang.getstr("error.deletion", trashcan) + 
								   "\n\n" + safe_unicode(exception), 
							   ok=lang.getstr("ok"), 
							   bitmap=geticon(32, "dialog-error"))
				# The case-sensitive index could fail because of 
				# case insensitive file systems, e.g. if the 
				# stored filename string is 
				# "C:\Users\Name\AppData\DisplayCAL\storage\MyFile"
				# but the actual filename is 
				# "C:\Users\Name\AppData\DisplayCAL\storage\myfile"
				# (maybe because the user renamed the file)
				idx = index_fallback_ignorecase(self.recent_cals, cal)
				self.recent_cals.remove(cal)
				self.calibration_file_ctrl.Delete(idx)
				setcfg("calibration.file", None)
				setcfg("settings.changed", 1)
				recent_cals = []
				for recent_cal in self.recent_cals:
					if recent_cal not in self.presets:
						recent_cals.append(recent_cal)
				setcfg("recent_cals", os.pathsep.join(recent_cals))
				update_colorimeter_correction_matrix_ctrl_items = False
				update_testcharts = False
				for path in delete_related_files:
					if path not in orphan_related_files:
						if (os.path.splitext(path)[1].lower() in (".ccss",
																  ".ccmx")):
							self.delete_colorimeter_correction_matrix_ctrl_item(path)
							update_colorimeter_correction_matrix_ctrl_items = True
						elif path in self.testcharts:
							update_testcharts = True
				if update_testcharts:
					self.set_testcharts()
				self.update_controls(False,
									 update_colorimeter_correction_matrix_ctrl_items)
				self.load_display_profile_cal()
	
	def delete_calibration_related_handler(self, event):
		chk = self.dlg.FindWindowById(event.GetId())
		self.related_files[chk.GetLabel()]=chk.GetValue()
	
	def aboutdialog_handler(self, event):
		if hasattr(self, "aboutdialog"):
			self.aboutdialog.Destroy()
		self.aboutdialog = AboutDialog(self, -1, 
									   lang.getstr("menu.about"), 
									   size=(100, 100))
		self.aboutdialog.BackgroundColour = wx.SystemSettings.GetColour(wx.SYS_COLOUR_WINDOW)
		items = []
		scale = max(getcfg("app.dpi") / config.get_default_dpi(), 1)
		items.append(wx_Panel(self.aboutdialog, -1,
							  size=(-1, int(round(6 * scale)))))
		items[-1].BackgroundColour = "#66CC00"
		items.append(get_header(self.aboutdialog, getbitmap("theme/header", False),
								label=wrap(lang.getstr("header"), 32),
								size=(320, 120), repeat_sub_bitmap_h=(220, 0, 2, 184)))
		bmp = getbitmap("theme/gradient", False)
		if bmp.Size[0] >= 8 and bmp.Size[1] >= 96:
			separator = BitmapBackgroundPanel(self.aboutdialog, size=(-1, 1))
			separator.SetBackgroundColour(wx.SystemSettings.GetColour(wx.SYS_COLOUR_3DSHADOW))
			items.append(separator)
			shadow = BitmapBackgroundPanel(self.aboutdialog, size=(-1, 15))
			bmp = bmp.GetSubBitmap((0, 1, 8, 15)).ConvertToImage().Mirror(False).ConvertToBitmap()
			image = bmp.ConvertToImage()
			databuffer = image.GetDataBuffer()
			for i, byte in enumerate(databuffer):
				if byte > "\0":
					databuffer[i] = chr(int(min(round(ord(byte) *
													  (255.0 / 223.0)), 255)))
			bmp = image.ConvertToBitmap()
			shadow.BackgroundColour = self.aboutdialog.BackgroundColour
			shadow.SetBitmap(bmp)
			shadow.blend = True
			items.append(shadow)
		items.append((1, 8))
		version_title = version_short
		if VERSION > VERSION_BASE:
			version_title += " Beta"
		items.append(wx.StaticText(self.aboutdialog, -1, u"%s %s © %s" %
								   (appname, version_title, author)))
		items.append(HyperLinkCtrl(
			self.aboutdialog, -1, label=domain, 
			URL="https://%s/" % domain))
		items.append(wx.StaticText(self.aboutdialog, -1, ""))
		items.append(wx.StaticText(self.aboutdialog, -1,
								   u"Argyll CMS %s © Graeme Gill" %
								   self.worker.argyll_version_string))
		items.append(HyperLinkCtrl(
			self.aboutdialog, -1, label="argyllcms.com", 
			URL="http://www.argyllcms.com"))
		items.append(wx.StaticText(self.aboutdialog, -1, ""))
		items.append(wx.StaticText(self.aboutdialog, -1, 
								   u"%s:" % lang.getstr("translations")))
		lauthors = {}
		for lcode in lang.ldict:
			lauthor = lang.ldict[lcode].get("!author", "")
			language = lang.ldict[lcode].get("!language", "")
			if lauthor and language:
				if not lauthors.get(lauthor):
					lauthors[lauthor] = []
				lauthors[lauthor].append(language)
		lauthors = [(lauthors[lauthor], lauthor) for lauthor in lauthors]
		lauthors.sort()
		for langs, lauthor in lauthors:
			items.append(wx.StaticText(self.aboutdialog, -1, 
									   "%s - %s" % (", ".join(langs), lauthor)))
		items.append(wx.StaticText(self.aboutdialog, -1, ""))
		match = re.match("([^(]+)\s*(\([^(]+\))?\s*(\[[^[]+\])?", sys.version)
		if match:
			pyver_long = match.groups()
		else:
			pyver_long = [sys.version]
		items.append(wx.StaticText(self.aboutdialog, -1, 
								   "Python " + pyver_long[0].strip()))
		items.append(HyperLinkCtrl(
			self.aboutdialog, -1, label="python.org", 
			URL="https://www.python.org/"))
		items.append(wx.StaticText(self.aboutdialog, -1, ""))
		items.append(wx.StaticText(self.aboutdialog, -1, "wxPython " + 
														 wx.version()))
		items.append(HyperLinkCtrl(
			self.aboutdialog, -1, label="wxpython.org", 
			URL="https://www.wxpython.org/"))
		items.append(wx.StaticText(self.aboutdialog, -1, ""))
		items.append(wx.StaticText(self.aboutdialog, -1,
								   lang.getstr("audio.lib",
											   "%s %s" % (audio._lib, 
														  audio._lib_version))))
		items.append(wx.StaticText(self.aboutdialog, -1, ""))
		for item in items:
			if isinstance(item, HyperLinkCtrl):
				item.BackgroundColour = self.aboutdialog.BackgroundColour
		self.aboutdialog.add_items(items)
		self.aboutdialog.ok.BackgroundColour = self.aboutdialog.BackgroundColour
		self.aboutdialog.Layout()
		self.aboutdialog.Center()
		self.aboutdialog.Show()
	
	def readme_handler(self, event):
		if lang.getcode() == "fr":
			readme = get_data_path("README-fr.html")
		else:
			readme = None
		if not readme:
			readme = get_data_path("README.html")
		if readme:
			launch_file(readme)
	
	def license_handler(self, event):
		license = get_data_path("LICENSE.txt")
		if not license:
			# Debian
			license = "/usr/share/common-licenses/GPL-3"
		if license and os.path.isfile(license):
			launch_file(license)
	
	def help_support_handler(self, event):
		launch_file("https://%s/#help" % domain)
	
	def bug_report_handler(self, event):
		launch_file("https://%s/#reportbug" % domain)
	
	def app_update_check_handler(self, event, silent=False, argyll=False):
		if not hasattr(self, "app_update_check") or \
		   not self.app_update_check.isAlive():
			self.app_update_check = threading.Thread(target=app_update_check, 
													 args=(self, silent,
														   False, argyll))
			self.app_update_check.start()
	
	def app_auto_update_check_handler(self, event):
		setcfg("update_check", 
			   int(self.menuitem_app_auto_update_check.IsChecked()))

	def infoframe_toggle_handler(self, event=None, show=None):
		if show is None:
			show = not self.infoframe.IsShownOnScreen()
		setcfg("log.show", int(show))
		if show:
			self.log()
		else:
			logbuffer.truncate(0)
		self.infoframe.Show(show)
		self.menuitem_show_log.Check(show)
		self.menuitem_log_autoshow.Enable(not show)
	
	def infoframe_autoshow_handler(self, event):
		setcfg("log.autoshow", int(self.menuitem_log_autoshow.IsChecked()))

	def HideAll(self):
		self.stop_timers()
		if hasattr(self, "gamapframe"):
			self.gamapframe.Hide()
		if hasattr(self, "aboutdialog"):
			self.aboutdialog.Hide()
		if hasattr(self, "extra_args"):
			self.extra_args.Hide()
		logbuffer.truncate(0)
		self.infoframe.Hide()
		if hasattr(self, "tcframe"):
			self.tcframe.Hide()
		if getattr(self, "lut_viewer", None) and \
		   self.lut_viewer.IsShownOnScreen():
			self.lut_viewer.Hide()
		if getattr(self, "lut3dframe", None):
			self.lut3dframe.Hide()
		if getattr(self, "reportframe", None):
			self.reportframe.Hide()
		if getattr(self, "synthiccframe", None):
			self.synthiccframe.Hide()
		for profile_info in self.profile_info.values():
			profile_info.Close()
		self.Hide()
		self.enable_menus(False)

	def Show(self, show=True, start_timers=True):
		if not self.IsShownOnScreen():
			if hasattr(self, "tcframe"):
				self.tcframe.Show(getcfg("tc.show"))
			if getcfg("log.show"):
				wx.CallAfter(self.infoframe_toggle_handler, show=True)
			if (LUTFrame and getcfg("lut_viewer.show") and
				self.worker.argyll_version > [0, 0, 0]):
				if getattr(self, "lut_viewer", None):
					self.init_lut_viewer(show=True)
				else:
					# Using wx.CallAfter fixes wrong positioning under wxGTK
					# with wxPython 3 on first initialization
					wx.CallAfter(self.init_lut_viewer, show=True)
			else:
				setcfg("lut_viewer.show", 0)
			for profile_info in reversed(self.profile_info.values()):
				profile_info.Show()
		if start_timers:
			self.start_timers()
		self.enable_menus()
		wx.Frame.Show(self, show)

	def OnClose(self, event=None):
		if (getattr(self.worker, "thread", None) and
			self.worker.thread.isAlive()):
			if isinstance(event, wx.CloseEvent) and event.CanVeto():
				event.Veto()
			self.worker.abort_subprocess(True)
			return
		if sys.platform == "darwin" or debug: self.focus_handler(event)
		if not hasattr(self, "tcframe") or self.tcframe.tc_close_handler():
			# If resources are missing, XRC shows an error dialog.
			# If the user never closees that dialog before he quits the
			# application, this dialog will hinder exiting the main loop.
			win = self.get_top_window()
			if isinstance(win, wx.Dialog) and win.IsModal():
				win.RequestUserAttention()
				win.Raise()
				if isinstance(event, wx.CloseEvent) and event.CanVeto():
					event.Veto()
				return
			for win in wx.GetTopLevelWindows():
				if win and not win.IsBeingDeleted():
					if isinstance(win, VisualWhitepointEditor):
						win.Close(force=True)
			writecfg()
			if getattr(self, "thread", None) and self.thread.isAlive():
				self.Disable()
				if debug:
					safe_print("Waiting for child thread to exit...")
				self.thread.join()
			self.listening = False
			if isinstance(getattr(self.worker, "madtpg", None),
						  madvr.MadTPG_Net):
				self.worker.madtpg.shutdown()
			self.HideAll()
			if self.worker.tempdir and os.path.isdir(self.worker.tempdir):
				self.worker.wrapup(False)
			wx.GetApp().ExitMainLoop()
		elif isinstance(event, wx.CloseEvent) and event.CanVeto():
			event.Veto()


class StartupFrame(wx.Frame):

	def __init__(self):
		title = "%s %s" % (appname, version_short)
		if VERSION > VERSION_BASE:
			title += " Beta"
		wx.Frame.__init__(self, None, title="%s: %s" % (title,
														lang.getstr("startup")),
						  style=wx.FRAME_SHAPED | wx.NO_BORDER)
		self.SetIcons(config.get_icon_bundle([256, 48, 32, 16], appname))
		if wx.VERSION >= (2, 8, 12, 1):
			# Setup shape. Required to get rid of window shadow under Ubuntu.
			# Note that shaped windows seem to be broken (won't show at all)
			# with wxGTK 2.8.12.0 and possibly earlier.
			self.mask_bmp = getbitmap("theme/splash-mask")
			if wx.Platform == "__WXGTK__":
				# wxGTK requires that the window be created before you can
				# set its shape, so delay the call to SetWindowShape until
				# this event.
				self.Bind(wx.EVT_WINDOW_CREATE, self.SetWindowShape)
			else:
				# On wxMSW and wxMac the window has already been created.
				self.SetWindowShape()

		# Setup splash screen
		self.splash_bmp = getbitmap("theme/splash")
		self.splash_anim = []
		for pth in get_data_path("theme/splash_anim", r"\.png$") or []:
			self.splash_anim.append(wx.Bitmap(pth))
		self.zoom_scales = []
		if getcfg("splash.zoom"):
			# Zoom in instead of fade
			numframes = 15
			self.splash_alpha = self.splash_bmp.ConvertToImage().GetAlphaData()
			minv = 1.0 / self.splash_bmp.Size[0]
			for x in xrange(numframes):
				scale = minv + colormath.specialpow(0.35 + 
													x / (numframes - 1.0) * (1 - 0.35),
													-2084) * (1 - minv)
				self.zoom_scales.append(scale)
			self.zoom_scales.append(1.02)
			self.zoom_scales.append(1.0)
		# Fade in major version number
		self.splash_version_anim = []
		splash_version = getbitmap("theme/splash_version")
		if splash_version:
			im = splash_version.ConvertToImage()
			for alpha in [0, .2, .4, .6, .8, 1, .95, .9, .85, .8, .75]:
				imcopy = im.AdjustChannels(1, 1, 1, alpha)
				self.splash_version_anim.append(imcopy.ConvertToBitmap())
		self.frame = 0
		clientarea = self.GetDisplay().ClientArea
		self.splash_x, self.splash_y = (clientarea[0] +
										int(clientarea[2] / 2.0 -
											self.splash_bmp.Size[0] / 2.0),
										clientarea[1] +
										int(clientarea[3] / 2.0 -
											self.splash_bmp.Size[1] / 2.0))
		self.Pulse("\n".join([lang.getstr("welcome_back"
							  if hascfg("recent_cals")
							  else "welcome"), lang.getstr("startup")]))

		self._bufferbitmap = wx.EmptyBitmap(self.splash_bmp.Size[0],
											self.splash_bmp.Size[1])
		self._buffereddc = wx.MemoryDC(self._bufferbitmap)
		self.worker = Worker()
		# Grab a bitmap of the screen area we're going to draw on
		if sys.platform != "darwin":
			dc = wx.ScreenDC()
			# Grabbing from ScreenDC is not supported under Mac OS X
			self._buffereddc.Blit(0, 0, self.splash_bmp.Size[0],
								  self.splash_bmp.Size[1], dc, self.splash_x,
								  self.splash_y)
		elif not isinstance(self.worker.create_tempdir(), Exception):
			# Use screencapture utility under Mac OS X
			splashdimensions = (self.splash_x, self.splash_y,
							    self.splash_bmp.Size[0],
							    self.splash_bmp.Size[1])
			is_mavericks = intlist(mac_ver()[0].split(".")) >= [10, 9]
			if is_mavericks:
				# Under 10.9 we can specify screen region as arguments
				extra_args = ["-R%i,%i,%i,%i" % splashdimensions]
			else:
				extra_args = []
			bmp_path = os.path.join(self.worker.tempdir, "screencap.png")
			if self.worker.exec_cmd(which("screencapture"),
									extra_args + ["-x", "screencap.png"],
									capture_output=True, skip_scripts=True,
									silent=True) and os.path.isfile(bmp_path):
				bmp = wx.Bitmap(bmp_path)
				if bmp.IsOk():
					if (not is_mavericks and
						bmp.Size[0] >= self.splash_x + self.splash_bmp.Size[0] and
						bmp.Size[1] >= self.splash_y + self.splash_bmp.Size[1]):
						# Pre 10.9 we have to get the splashscreen region
						# from the full screenshot bitmap
						bmp = bmp.GetSubBitmap(splashdimensions)
					elif (is_mavericks and
						  bmp.Size[0] == self.splash_bmp.Size[0] * 2 and
						  bmp.Size[1] == self.splash_bmp.Size[1] * 2):
						# Retina, screencapture is double our bitmap size
						if wx.VERSION > (3, ):
							quality = wx.IMAGE_QUALITY_BILINEAR
						else:
							quality = wx.IMAGE_QUALITY_HIGH
						img = bmp.ConvertToImage()
						img.Rescale(self.splash_bmp.Size[0],
									self.splash_bmp.Size[1], quality)
						bmp = img.ConvertToBitmap()
					self._buffereddc.DrawBitmap(bmp, 0, 0)
				self.worker.wrapup(False)
		self.SetClientSize(self.splash_bmp.Size)
		self.SetPosition((self.splash_x, self.splash_y))
		self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)
		self.Bind(wx.EVT_PAINT, self.OnPaint)
		if len(self.zoom_scales):
			self._alpha = 255
		else:
			self.SetTransparent(0)
			self._alpha = 0

		audio.safe_init()
		if audio._lib:
			safe_print(lang.getstr("audio.lib", "%s %s" % (audio._lib,
														   audio._lib_version)))
		# Startup sound
		# Needs to be stereo!
		if getcfg("startup_sound.enable"):
			self.startup_sound = audio.Sound(get_data_path("theme/intro_new.wav"))
			self.startup_sound.volume = .8
			self.startup_sound.safe_play()

		self.Show()

		# We need to use CallLater instead of CallAfter otherwise dialogs
		# will not show while the main frame is not yet initialized
		wx.CallLater(1, self.startup)

	def startup(self):
		if sys.platform not in ("darwin", "win32"):
			# Drawing of window shadow can be prevented under some desktop
			# environments that would normally try to draw a shadow by never
			# making the window fully opaque
			endalpha = 254
		else:
			endalpha = 255
		if self.IsShown() and self._alpha < endalpha:
			self._alpha += 15
			if self._alpha > endalpha:
				self._alpha = endalpha
			self.SetTransparent(self._alpha)
			if sys.platform not in ("darwin", "win32"):
				self.Refresh()
				self.Update()
			wx.CallLater(1, self.startup)
			return
		if self.frame < (len(self.zoom_scales) + len(self.splash_anim) +
						 len(self.splash_version_anim)) - 1:
			self.frame += 1
			self.Refresh()
			self.Update()
			if self.frame < len(self.zoom_scales):
				wx.CallLater(1, self.startup)
			else:
				wx.CallLater(1000 / 30.0, self.startup)
			return
		# Give 10 seconds for display & instrument enumeration to run.
		# This should be plenty and will kill the subprocess in case it hangs.
		self.timeout = wx.CallLater(10000, self.worker.abort_subprocess)
		delayedresult.startWorker(self.setup_frame, 
								  self.worker.enumerate_displays_and_ports,
								  wkwargs={"enumerate_ports":
										   getcfg("enumerate_ports.auto") or
										   not getcfg("instruments", raw=True),
										   "silent": True})

	def setup_frame(self, result):
		if self.timeout.IsRunning():
			self.timeout.Stop()
		self.timeout = None
		try:
			result.get()
		except Exception, exception:
			if hasattr(exception, "originalTraceback"):
				error = exception.originalTraceback
			else:
				error = traceback.format_exc()
			raise Error(error)
		if verbose >= 1:
			safe_print(lang.getstr("initializing_gui"))
		app = wx.GetApp()
		app.frame = MainFrame(self.worker)
		self.setup_frame_finish(app)

	def setup_frame_finish(self, app):
		if self.IsShown() and self._alpha > 0:
			self._alpha -= 15
			if self._alpha < 0:
				self._alpha = 0
			self.SetTransparent(self._alpha)
			if sys.platform not in ("darwin", "win32"):
				self.Refresh()
				self.Update()
			wx.CallLater(1, self.setup_frame_finish, app)
			return
		app.SetTopWindow(app.frame)
		app.frame.listen()
		app.frame.Show()
		app.process_argv(1)
		wx.CallAfter(app.frame.Raise)
		# Check for updates if configured
		if getcfg("update_check"):
			# Give time for the main window to gain focus before checking for
			# update, otherwise the main window may steal the update
			# confirmation dialog's focus which looks weird
			wx.CallAfter(app.frame.app_update_check_handler, None, silent=True)
		else:
			# Check if we need to run instrument setup
			wx.CallAfter(app.frame.check_instrument_setup, check_donation,
						 (app.frame, VERSION > VERSION_BASE))
		# If resources are missing, XRC shows an error dialog which immediately
		# gets hidden when we close ourselves because we are the parent.
		# Hide instead.
		win = app.frame.get_top_window()
		if isinstance(win, wx.Dialog):
			self.Hide()
		else:
			self.Close()

	def OnEraseBackground(self, event):
		pass

	def OnPaint(self, event):
		if sys.platform != "win32":
			# AutoBufferedPaintDCFactory is the magic needed for crisp text
			# rendering in HiDPI mode under OS X and Linux
			cls = wx.AutoBufferedPaintDCFactory
		else:
			cls = wx.BufferedPaintDC
		self.Draw(cls(self))

	def Draw(self, dc):
		# Background
		dc.SetBackgroundMode(wx.TRANSPARENT)
		if isinstance(dc, wx.ScreenDC):
			dc.StartDrawingOnTop()
			x, y = self.splash_x, self.splash_y
		else:
			dc.Clear()
			if hasattr(self, "_buffereddc"):
				dc.Blit(0, 0, self.splash_bmp.Size[0],
						self.splash_bmp.Size[1], self._buffereddc, 0, 0)
			x = y = 0
		if self.frame < len(self.zoom_scales):
			pdc = dc
			bufferbitmap = wx.EmptyBitmap(self.splash_bmp.Size[0],
										  self.splash_bmp.Size[1])
			dc = wx.MemoryDC()
			dc.SelectObject(bufferbitmap)
			dc.SetBackgroundMode(wx.TRANSPARENT)
		dc.DrawBitmap(self.splash_bmp, x, y)
		# Text
		rect = wx.Rect(0, int(self.splash_bmp.Size[1] * 0.75),
					   self.splash_bmp.Size[0], 40)
		dc.SetFont(self.GetFont())
		# Version label
		label_str = version_short
		if VERSION > VERSION_BASE:
			label_str += " Beta"
		dc.SetTextForeground("#101010")
		yoff = 10
		scale = getcfg("app.dpi") / config.get_default_dpi()
		if scale > 1:
			yoff = int(round(yoff * scale))
		yoff -= 10
		dc.DrawLabel(label_str, wx.Rect(rect.x, 110 + yoff, rect.width,
										32), wx.ALIGN_CENTER |
															wx.ALIGN_TOP)
		dc.SetTextForeground(wx.BLACK)
		dc.DrawLabel(label_str, wx.Rect(rect.x, 111 + yoff, rect.width,
										32), wx.ALIGN_CENTER |
															wx.ALIGN_TOP)
		dc.SetTextForeground("#CCCCCC")
		dc.DrawLabel(label_str, wx.Rect(rect.x, 112 + yoff, rect.width,
										32), wx.ALIGN_CENTER |
															wx.ALIGN_TOP)
		# Message
		dc.SetTextForeground("#101010")
		dc.DrawLabel(self._msg, wx.Rect(rect.x, rect.y + 2, rect.width,
										rect.height), wx.ALIGN_CENTER |
													  wx.ALIGN_TOP)
		dc.SetTextForeground(wx.BLACK)
		dc.DrawLabel(self._msg, wx.Rect(rect.x, rect.y + 1, rect.width,
										rect.height), wx.ALIGN_CENTER |
													  wx.ALIGN_TOP)
		dc.SetTextForeground("#CCCCCC")
		dc.DrawLabel(self._msg, rect, wx.ALIGN_CENTER | wx.ALIGN_TOP)
		if self.frame < len(self.zoom_scales):
			# Zoom
			dc.DrawBitmap(self.splash_anim[0], x, y)
			dc.SelectObject(wx.NullBitmap)
			scale = self.zoom_scales[self.frame]
			frame = bufferbitmap.ConvertToImage()
			frame.SetAlphaData(self.splash_alpha)
			if scale < 1:
				frame = frame.Blur(int(round(1 * (1 - scale))))
			if wx.VERSION > (3, ):
				quality = wx.IMAGE_QUALITY_BILINEAR
			else:
				quality = wx.IMAGE_QUALITY_HIGH
			frame.Rescale(max(int(round(self.splash_bmp.Size[0] * scale)), 1),
						  max(int(round(self.splash_bmp.Size[1] * scale)), 1),
						  quality)
			frame.Resize(self.splash_bmp.Size,
						 (int(round(self.splash_bmp.Size[0] / 2 - frame.Width / 2)),
						  int(round(self.splash_bmp.Size[1] / 2 - frame.Height / 2))))
			pdc.DrawBitmap(frame.ConvertToBitmap(), x, y)
		else:
			# Animation
			if self.splash_anim:
				dc.DrawBitmap(self.splash_anim[min(self.frame - len(self.zoom_scales),
												   len(self.splash_anim) - 1)], x, y)
			if self.frame > len(self.zoom_scales) + len(self.splash_anim) - 1:
				dc.DrawBitmap(self.splash_version_anim[self.frame -
													   len(self.zoom_scales) -
													   len(self.splash_anim)],
							  x, y)
		if isinstance(dc, wx.ScreenDC):
			dc.EndDrawingOnTop()

	def Pulse(self, msg=None):
		if msg:
			self._msg = msg
			if self.IsShown():
				self.Refresh()
				self.Update()
		return True, False

	def SetWindowShape(self, *evt):
		r = wx.RegionFromBitmapColour(self.mask_bmp, wx.BLACK)
		self.hasShape = self.SetShape(r)

	UpdatePulse = Pulse


class MeasurementFileCheckSanityDialog(ConfirmDialog):
	
	def __init__(self, parent, ti3, suspicious, force=False):
		scale = getcfg("app.dpi") / config.get_default_dpi()
		if scale < 1:
			scale = 1
		ConfirmDialog.__init__(self, parent,
							   title=os.path.basename(ti3.filename)
									 if ti3.filename
									 else lang.getstr("measurement_file.check_sanity"),
							   ok=lang.getstr("ok"),
							   cancel=lang.getstr("cancel"),
							   alt=lang.getstr("invert_selection"),
							   bitmap=geticon(32, "dialog-warning"), wrap=120)
		msg_col1 = lang.getstr("warning.suspicious_delta_e")
		msg_col2 = lang.getstr("warning.suspicious_delta_e.info")

		margin = 12

		dlg = self
		
		dlg.sizer3.Remove(0)  # Remove message textbox
		dlg.message.Destroy()
		dlg.sizer4 = wx.BoxSizer(wx.HORIZONTAL)
		dlg.sizer3.Add(dlg.sizer4)
		dlg.message_col1 = wx.StaticText(dlg, -1, msg_col1)
		dlg.message_col1.Wrap(450 * scale)
		dlg.sizer4.Add(dlg.message_col1, flag=wx.RIGHT, border = 20)
		dlg.message_col2 = wx.StaticText(dlg, -1, msg_col2)
		dlg.message_col2.Wrap(450 * scale)
		dlg.sizer4.Add(dlg.message_col2, flag=wx.LEFT, border = 20)

		dlg.Unbind(wx.EVT_BUTTON, dlg.alt)
		dlg.Bind(wx.EVT_BUTTON, dlg.invert_selection_handler, id=dlg.alt.GetId())

		dlg.select_all_btn = wx.Button(dlg.buttonpanel, -1,
									   lang.getstr("deselect_all"))
		dlg.sizer2.Insert(2, (margin, margin))
		dlg.sizer2.Insert(2, dlg.select_all_btn)
		dlg.Bind(wx.EVT_BUTTON, dlg.select_all_handler,
				 id=dlg.select_all_btn.GetId())

		dlg.ti3 = ti3
		dlg.suspicious = suspicious
		dlg.mods = {}
		dlg.force = force

		if "gtk3" in wx.PlatformInfo:
			style = wx.BORDER_SIMPLE
		else:
			style = wx.BORDER_THEME
		dlg.grid = CustomGrid(dlg, -1, size=(940 * scale, 200 * scale), style=style)
		grid = dlg.grid
		grid.DisableDragRowSize()
		grid.SetCellHighlightPenWidth(0)
		grid.SetCellHighlightROPenWidth(0)
		grid.SetDefaultCellAlignment(wx.ALIGN_CENTER, wx.ALIGN_CENTER)
		grid.SetMargins(0, 0)
		grid.SetRowLabelAlignment(wx.ALIGN_RIGHT, wx.ALIGN_CENTER)
		grid.SetScrollRate(5, 5)
		grid.draw_horizontal_grid_lines = False
		grid.draw_vertical_grid_lines = False
		grid.CreateGrid(0, 15)
		grid.SetColLabelSize(int(round(self.grid.GetDefaultRowSize() * 2.4)))
		dc = wx.MemoryDC(wx.EmptyBitmap(1, 1))
		dc.SetFont(grid.GetLabelFont())
		w, h = dc.GetTextExtent("99%s" % dlg.ti3.DATA[dlg.ti3.NUMBER_OF_SETS -
													  1].SAMPLE_ID)
		grid.SetRowLabelSize(max(w, grid.GetDefaultRowSize()))
		w, h = dc.GetTextExtent("9999999999")
		for i in xrange(grid.GetNumberCols()):
			if i in (4, 5) or i > 8:
				attr = wx.grid.GridCellAttr()
				attr.SetReadOnly(True) 
				grid.SetColAttr(i, attr)
			if i == 0:
				size = 22 * scale
			elif i in (4, 5):
				size = self.grid.GetDefaultRowSize()
			else:
				size = w
			grid.SetColSize(i, size)
		for i, label in enumerate(["", "R %", "G %", "B %", "", "", "X", "Y", "Z",
								   u"\u0394E*00\nXYZ A/B",
								   u"0.5 \u0394E*00\nRGB A/B",
								   u"\u0394E*00\nRGB-XYZ",
								   u"\u0394L*00\nRGB-XYZ",
								   u"\u0394C*00\nRGB-XYZ",
								   u"\u0394H*00\nRGB-XYZ"]):
			grid.SetColLabelValue(i, label)
		attr = wx.grid.GridCellAttr()
		#attr.SetReadOnly(True)
		attr.SetRenderer(CustomCellBoolRenderer())
		grid.SetColAttr(0, attr)
		font = grid.GetDefaultCellFont()
		if font.PointSize > 11:
			font.PointSize = 11
			grid.SetDefaultCellFont(font)
		grid.DisableDragColSize()
		grid.EnableGridLines(False)

		black = ti3.queryi1({"RGB_R": 0, "RGB_G": 0, "RGB_B": 0})
		if black:
			black = black["XYZ_X"], black["XYZ_Y"], black["XYZ_Z"]
		dlg.black = black
		white = ti3.queryi1({"RGB_R": 100, "RGB_G": 100, "RGB_B": 100})
		if white:
			white = white["XYZ_X"], white["XYZ_Y"], white["XYZ_Z"]
		dlg.white = white
		dlg.suspicious_items = []
		grid.BeginBatch()
		for i, (prev, item, delta, sRGB_delta, prev_delta_to_sRGB,
				delta_to_sRGB) in enumerate(suspicious):
			for cur in (prev, item):
				if cur and cur not in dlg.suspicious_items:
					dlg.suspicious_items.append(cur)
					grid.AppendRows(1)
					row = grid.GetNumberRows() - 1
					grid.SetRowLabelValue(row, "%d" % cur.SAMPLE_ID)
					RGB = []
					for k, label in enumerate("RGB"):
						value = cur["RGB_%s" % label]
						grid.SetCellValue(row, 1 + k, "%.4f" % value)
						RGB.append(value)
					XYZ = []
					for k, label in enumerate("XYZ"):
						value = cur["XYZ_%s" % label]
						grid.SetCellValue(row, 6 + k, "%.4f" % value)
						XYZ.append(value)
					if cur is prev:
						dlg.update_row(row, RGB, XYZ, None, None,
									   prev_delta_to_sRGB)
					else:
						dlg.update_row(row, RGB, XYZ, delta, sRGB_delta,
									   delta_to_sRGB)
		grid.EndBatch()

		grid.Bind(wx.EVT_KEY_DOWN, dlg.key_handler)
		grid.Bind(wx.grid.EVT_GRID_CELL_CHANGE, dlg.cell_change_handler)
		grid.Bind(wx.grid.EVT_GRID_CELL_LEFT_CLICK, dlg.cell_click_handler)

		dlg.sizer3.Add(grid, 1, flag=wx.TOP | wx.ALIGN_LEFT, border=12)

		dlg.buttonpanel.Layout()
		dlg.sizer0.SetSizeHints(dlg)
		dlg.sizer0.Layout()

		# This workaround is needed to update cell colours
		grid.SelectAll()
		grid.ClearSelection()

		dlg.Center()
	
	def cell_change_handler(self, event):
		dlg = self
		grid = dlg.grid
		if event.Col > 0:
			item = dlg.suspicious_items[event.Row]
			label = "_RGB__XYZ"[event.Col]
			if event.Col < 6:
				label = "RGB_%s" % label
			else:
				label = "XYZ_%s" % label
			strval = "0" + grid.GetCellValue(event.Row,
											 event.Col).replace(",", ".")
			try:
				value = float(strval)
				if (label[:3] == "RGB" or label == "XYZ_Y") and value > 100:
					raise ValueError("Value %r is invalid" % value)
				elif value < 0:
					raise ValueError("Negative value %r is invalid" % value)
			except ValueError:
				wx.Bell()
				strval = "%.4f" % item[label]
				if "." in strval:
					strval = strval.rstrip("0").rstrip(".")
				grid.SetCellValue(event.Row, event.Col,
								  re.sub("^0+(?!\.)", "", strval) or "0")
			else:
				grid.SetCellValue(event.Row, event.Col,
								  re.sub("^0+(?!\.)", "", strval) or "0")
				RGB = []
				for i in (1, 2, 3):
					RGB.append(float(grid.GetCellValue(event.Row, i)))
				XYZ = []
				for i in (6, 7, 8):
					XYZ.append(float(grid.GetCellValue(event.Row, i)))
				# Update row
				(sRGBLab, Lab, delta_to_sRGB,
				 criteria1,
				 debuginfo) = check_ti3_criteria1(RGB, XYZ, dlg.black,
												  dlg.white,
												  print_debuginfo=True)
				if grid.GetCellValue(event.Row, 9):
					prev = dlg.suspicious_items[event.Row - 1]
					prev_RGB = prev["RGB_R"], prev["RGB_G"], prev["RGB_B"]
					prev_XYZ = prev["XYZ_X"], prev["XYZ_Y"], prev["XYZ_Z"]
					(prev_sRGBLab, prev_Lab, prev_delta_to_sRGB,
					 prev_criteria1,
					 prev_debuginfo) = check_ti3_criteria1(prev_RGB, prev_XYZ,
														   dlg.black, dlg.white,
														   print_debuginfo=False)
					(delta,
					 sRGB_delta,
					 criteria2) = check_ti3_criteria2(prev_Lab, Lab,
													  prev_sRGBLab, sRGBLab,
													  prev_RGB, RGB)
				else:
					delta, sRGB_delta = (None, ) * 2
				dlg.update_row(event.Row, RGB, XYZ, delta, sRGB_delta,
							   delta_to_sRGB)

				if item[label] != value:
					if not dlg.mods.get(event.Row):
						dlg.mods[event.Row] = {}
					dlg.mods[event.Row][label] = value

				dlg.ok.Enable(not dlg.force or bool(dlg.mods))

				# This workaround is needed to update cell colours
				cells = grid.GetSelection()
				grid.SelectAll()
				grid.ClearSelection()
				for row, col in cells:
					grid.SelectBlock(row, col, row, col, True)
		else:
			dlg.check_select_status()

	def cell_click_handler(self, event):
		if event.Col == 0:
			if self.grid.GetCellValue(event.Row, event.Col):
				value = ""
			else:
				value = "1"
			self.grid.SetCellValue(event.Row, event.Col, value)
			self.check_select_status()
		event.Skip()
	
	def check_select_status(self, has_false_values=None, has_true_values=None):
		dlg = self
		if None in (has_false_values, has_true_values):
			for index in xrange(dlg.grid.GetNumberRows()):
				if dlg.grid.GetCellValue(index, 0) != "1":
					has_false_values = True
				else:
					has_true_values = True
		dlg.ok.Enable(has_false_values or not self.force or bool(dlg.mods))
		if has_true_values:
			dlg.select_all_btn.SetLabel(lang.getstr("deselect_all"))
		else:
			dlg.select_all_btn.SetLabel(lang.getstr("select_all"))
	
	def invert_selection_handler(self, event):
		dlg = self
		has_false_values = False
		has_true_values = False
		for index in xrange(dlg.grid.GetNumberRows()):
			if dlg.grid.GetCellValue(index, 0) == "1":
				value = ""
				has_false_values = True
			else:
				value = "1"
				has_true_values = True
			dlg.grid.SetCellValue(index, 0, value)
		self.check_select_status(has_false_values, has_true_values)

	def key_handler(self, event):
		dlg = self
		if event.KeyCode == wx.WXK_SPACE:
			if dlg.grid.GridCursorCol == 0:
				dlg.cell_click_handler(CustomGridCellEvent(wx.grid.EVT_GRID_CELL_CHANGE.evtType[0],
														   dlg.grid,
														   dlg.grid.GridCursorRow,
														   dlg.grid.GridCursorCol))
		else:
			event.Skip()
	
	def mark_cell(self, row, col, ok=False):
		grid = self.grid
		font = grid.GetCellFont(row, col)
		font.SetWeight(wx.FONTWEIGHT_NORMAL if ok else wx.FONTWEIGHT_BOLD)
		grid.SetCellFont(row, col, font)
		grid.SetCellTextColour(row, col, grid.GetDefaultCellTextColour() if ok
										 else wx.Colour(204, 0, 0))
	
	def select_all_handler(self, event):
		dlg = self
		if dlg.select_all_btn.GetLabel() == lang.getstr("select_all"):
			value = "1"
		else:
			value = ""
		for index in xrange(dlg.grid.GetNumberRows()):
			dlg.grid.SetCellValue(index, 0, value)
		self.check_select_status(not value, value)
	
	def update_row(self, row, RGB, XYZ, delta, sRGB_delta, delta_to_sRGB):
		dlg = self
		grid = dlg.grid
		RGB255 = [int(round(float(str(v * 2.55)))) for v in RGB]
		dlg.grid.SetCellBackgroundColour(row, 4,
										 wx.Colour(*RGB255))
		if dlg.white:
			XYZ = colormath.adapt(XYZ[0], XYZ[1], XYZ[2],
								  dlg.white, "D65")
		RGB255 = [int(round(float(str(v)))) for v in
				  colormath.XYZ2RGB(XYZ[0] / 100.0,
									XYZ[1] / 100.0,
									XYZ[2] / 100.0, scale=255)]
		dlg.grid.SetCellBackgroundColour(row, 5,
										 wx.Colour(*RGB255))
		grid.SetCellValue(row, 0, "1" if (not delta or (delta["E_ok"] and
														delta["L_ok"])) and
										 delta_to_sRGB["ok"]
									  else "")
		for col in xrange(3):
			dlg.mark_cell(row, 6 + col, (not delta or (delta["E_ok"] and
													   (delta["L_ok"] or
														col != 1))) and
										delta_to_sRGB["ok"])
		if delta:
			grid.SetCellValue(row, 9, "%.2f" % delta["E"])
			dlg.mark_cell(row, 9, delta["E_ok"])
			if sRGB_delta:
				grid.SetCellValue(row, 10, "%.2f" % sRGB_delta["E"])
		for col, ELCH in enumerate("ELCH"):
			grid.SetCellValue(row, 11 + col, "%.2f" % delta_to_sRGB[ELCH])
			dlg.mark_cell(row, 11 + col, delta_to_sRGB["%s_ok" % ELCH])


def main():
	initcfg()
	lang.init()
	# Startup messages
	if verbose >= 1:
		safe_print(lang.getstr("startup"))
	if sys.platform != "darwin":
		if not autostart:
			safe_print(lang.getstr("warning.autostart_system"))
		if not autostart_home:
			safe_print(lang.getstr("warning.autostart_user"))
	app = BaseApp(0)  # Don't redirect stdin/stdout
	app.TopWindow = StartupFrame()
	app.MainLoop()

if __name__ == "__main__":
	
	main()
