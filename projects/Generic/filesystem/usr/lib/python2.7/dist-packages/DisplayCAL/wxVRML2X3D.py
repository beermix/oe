# -*- coding: utf-8 -*-

import os
import sys

from meta import name as appname
from safe_print import safe_print
from util_os import launch_file, make_win32_compatible_long_path, waccess
from util_str import safe_unicode
from worker import Worker, show_result_dialog
from wxaddons import wx
from wxfixes import GenBitmapButton as BitmapButton
from wxwindows import BaseApp, BaseFrame, FileDrop
import config
import localization as lang
import x3dom


class VRML2X3DFrame(BaseFrame):

	def __init__(self, html, embed, view, force, cache):
		BaseFrame.__init__(self, None, wx.ID_ANY,
						   lang.getstr("vrml_to_x3d_converter"),
						   style=wx.DEFAULT_FRAME_STYLE & ~(wx.MAXIMIZE_BOX |
															wx.RESIZE_BORDER),
						   name="vrml2x3dframe")
		self.SetIcons(config.get_icon_bundle([256, 48, 32, 16],
											  appname +
											  "-VRML-to-X3D-converter"))
		self.cache = cache
		self.embed = embed
		self.force = force
		self.html = html
		self.worker = Worker(self)
		sizer = wx.BoxSizer(wx.HORIZONTAL)
		self.SetSizer(sizer)
		panel = wx.Panel(self)
		sizer.Add(panel)
		panelsizer = wx.BoxSizer(wx.HORIZONTAL)
		panel.SetSizer(panelsizer)
		self.btn = BitmapButton(panel, wx.ID_ANY,
								config.geticon(256, "document-open"), 
								style=wx.NO_BORDER)
		self.btn.SetToolTipString(lang.getstr("file.select"))
		self.btn.Bind(wx.EVT_BUTTON, lambda event:
									  vrmlfile2x3dfile(None,
													   html=html,
													   embed=embed,
													   view=view,
													   force=force,
													   cache=cache,
													   worker=self.worker))
		self.droptarget = FileDrop(self)
		vrml_drop_handler = lambda vrmlpath: vrmlfile2x3dfile(vrmlpath,
															  html=html,
															  embed=embed,
															  view=view,
															  force=force,
															  cache=cache,
															  worker=self.worker)
		self.droptarget.drophandlers = {
			".vrml": vrml_drop_handler,
			".vrml.gz": vrml_drop_handler,
			".wrl": vrml_drop_handler,
			".wrl.gz": vrml_drop_handler,
			".wrz": vrml_drop_handler
		}
		self.btn.SetDropTarget(self.droptarget)
		panelsizer.Add(self.btn, flag=wx.ALL, border=12)
		self.Fit()
		self.SetMinSize(self.GetSize())
		self.SetMaxSize(self.GetSize())

	def get_commands(self):
		return (self.get_common_commands() +
			    ["VRML-to-X3D-converter [filename...]",
				 "load <filename...>"])

	def process_data(self, data):
		if data[0] in ("VRML-to-X3D-converter", "load"):
			if self.IsIconized():
				self.Restore()
			self.Raise()
			if len(data) > 1:
				self.droptarget.OnDropFiles(0, 0, data[1:])
			return "ok"
		return "invalid"


def main():
	if "--help" in sys.argv[1:]:
		safe_print("Usage: %s [--embed] [--no-gui] [--view] [FILE]" % sys.argv[0])
		safe_print("Convert VRML file to X3D")
		safe_print("The output is written to FILENAME.x3d(.html)")
		safe_print("")
		safe_print("  --embed      Embed viewer components in HTML instead of "
				   "referencing them")
		safe_print("  --force      Force fresh download of viewer components")
		safe_print("  --no-cache   Don't use viewer components cache (only "
				   "uses existing cache if")
		safe_print("               embedding components, can be overridden "
				   "with --force)")
		safe_print("  --no-gui     Don't show GUI (terminal mode)")
		safe_print("  --no-html    Don't generate HTML file")
		safe_print("  --view       View the generated file (if --no-gui)")
		safe_print("  FILE         Filename of VRML file to convert")
		return
	config.initcfg("VRML-to-X3D-converter")
	lang.init()
	lang.update_defaults()
	cache = not "--no-cache" in sys.argv[1:]
	embed = "--embed" in sys.argv
	force = "--force" in sys.argv
	html = not "--no-html" in sys.argv[1:]
	if "--no-gui" in sys.argv[1:]:
		view = "--view" in sys.argv[1:]
		for arg in sys.argv[1:]:
			if os.path.isfile(arg):
				vrmlfile2x3dfile(safe_unicode(arg), html=html, embed=embed,
								 view=view, force=force, cache=cache)
	else:
		view = not "--no-view" in sys.argv[1:]
		app = BaseApp(0)
		app.TopWindow = VRML2X3DFrame(html, embed, view, force, cache)
		if sys.platform == "darwin":
			app.TopWindow.init_menubar()
		wx.CallLater(1, _main, app)
		app.MainLoop()

def _main(app):
	app.TopWindow.listen()
	app.process_argv()
	app.TopWindow.Show()


def vrmlfile2x3dfile(vrmlpath=None, x3dpath=None, html=True, embed=False,
					 view=False, force=False, cache=True, worker=None):
	""" Convert VRML to HTML. Output is written to <vrmlfilename>.x3d.html
	unless you set x3dpath to desired output path, or False to be prompted
	for an output path. """
	while not vrmlpath or not os.path.isfile(vrmlpath):
		if "--no-gui" in sys.argv[1:]:
			if not vrmlpath or vrmlpath.startswith("--"):
				safe_print("No filename given.")
			else:
				safe_print("%r is not a file." % vrmlpath)
			sys.exit(1)
		if not wx.GetApp():
			app = BaseApp(0)
		defaultDir, defaultFile = config.get_verified_path("last_vrml_path")
		dlg = wx.FileDialog(None, lang.getstr("file.select"),
							defaultDir=defaultDir, 
							defaultFile=defaultFile, 
							wildcard=lang.getstr("filetype.vrml") +
									 "|*.vrml;*.vrml.gz;*.wrl.gz;*.wrl;*.wrz", 
							style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)
		dlg.Center(wx.BOTH)
		result = dlg.ShowModal()
		vrmlpath = dlg.GetPath()
		dlg.Destroy()
		if result != wx.ID_OK:
			return
		config.setcfg("last_vrml_path", vrmlpath)
		config.writecfg(module="VRML-to-X3D-converter",
						options=("last_vrml_path", ))
	filename, ext = os.path.splitext(vrmlpath)
	if x3dpath is None:
		x3dpath = filename + ".x3d"
	if x3dpath:
		dirname = os.path.dirname(x3dpath)
	while not x3dpath or not waccess(dirname, os.W_OK):
		if "--no-gui" in sys.argv[1:]:
			if not x3dpath:
				safe_print("No HTML output filename given.")
			else:
				safe_print("%r is not writable." % dirname)
			sys.exit(1)
		if not wx.GetApp():
			app = BaseApp(0)
		if x3dpath:
			defaultDir, defaultFile = os.path.split(x3dpath)
		else:
			defaultFile = os.path.basename(filename) + ".x3d"
		dlg = wx.FileDialog(None, lang.getstr("error.access_denied.write",
											  dirname),
							defaultDir=defaultDir, 
							defaultFile=defaultFile, 
							wildcard=lang.getstr("filetype.x3d") +
									 "|*.x3d", 
							style=wx.SAVE | wx.FD_OVERWRITE_PROMPT)
		dlg.Center(wx.BOTH)
		result = dlg.ShowModal()
		dlg.Destroy()
		if result != wx.ID_OK:
			return
		x3dpath = dlg.GetPath()
		dirname = os.path.dirname(x3dpath)
	vrmlpath, x3dpath = [safe_unicode(path) for path in (vrmlpath, x3dpath)]
	if sys.platform == "win32":
		vrmlpath = make_win32_compatible_long_path(vrmlpath)
		x3dpath = make_win32_compatible_long_path(x3dpath)
	if html:
		finalpath = x3dpath + ".html"
		if sys.platform == "win32":
			finalpath = make_win32_compatible_long_path(finalpath)
			x3dpath = finalpath[:-5]
	else:
		finalpath = x3dpath
	if worker:
		worker.clear_cmd_output()
		worker.start(lambda result:
					 show_result_dialog(result, wx.GetApp().GetTopWindow())
					 if isinstance(result, Exception)
					 else result and view and launch_file(finalpath),
					 x3dom.vrmlfile2x3dfile,
					 wargs=(vrmlpath, x3dpath, html, embed, force, cache,
							worker),
					 progress_title=lang.getstr("vrml_to_x3d_converter"),
					 progress_start=1,
					 resume=worker.progress_wnd and
							worker.progress_wnd.IsShownOnScreen(), fancy=False)
	else:
		result = x3dom.vrmlfile2x3dfile(vrmlpath, x3dpath, html, embed, force,
										cache, None)
		if not isinstance(result, Exception) and result and view:
			launch_file(finalpath)
		else:
			sys.exit(1)


if __name__ == "__main__":
	main()
