# -*- coding: utf-8 -*-

from time import gmtime, strftime
import math
import os
import sys

from config import get_data_path, initcfg, getcfg, geticon, hascfg, setcfg
from log import safe_print
from meta import name as appname
from util_str import strtr
from worker import Error, get_current_profile_path, show_result_dialog
import CGATS
import ICCProfile as ICCP
import config
import localization as lang
import worker
from wxTestchartEditor import TestchartEditor
from wxwindows import BaseApp, BaseFrame, FileDrop, InfoDialog, wx
from wxfixes import TempXmlResource
import xh_fancytext
import xh_filebrowsebutton
import xh_hstretchstatbmp
import xh_bitmapctrls

from wx import xrc


class ReportFrame(BaseFrame):

	""" Measurement report creation window """
	
	def __init__(self, parent=None):
		BaseFrame.__init__(self, parent, -1, lang.getstr("measurement_report"))
		self.Bind(wx.EVT_CLOSE, self.OnClose)
		
		self.SetIcons(config.get_icon_bundle([256, 48, 32, 16], appname))

		res = TempXmlResource(get_data_path(os.path.join("xrc", "report.xrc")))
		res.InsertHandler(xh_fancytext.StaticFancyTextCtrlXmlHandler())
		res.InsertHandler(xh_filebrowsebutton.FileBrowseButtonWithHistoryXmlHandler())
		res.InsertHandler(xh_hstretchstatbmp.HStretchStaticBitmapXmlHandler())
		res.InsertHandler(xh_bitmapctrls.BitmapButton())
		res.InsertHandler(xh_bitmapctrls.StaticBitmap())
		self.panel = res.LoadPanel(self, "panel")

		self.Sizer = wx.BoxSizer(wx.VERTICAL)
		self.Sizer.Add(self.panel, 1, flag=wx.EXPAND)
		
		self.set_child_ctrls_as_attrs(self)

		self.measurement_report_btn = wx.Button(self.panel, -1,
												lang.getstr("measure"))
		self.panel.Sizer.Insert(2, self.measurement_report_btn,
								flag=wx.RIGHT | wx.BOTTOM | wx.ALIGN_RIGHT,
								border=16)

		self.worker = worker.Worker(self)
		self.worker.set_argyll_version("xicclu")

		BaseFrame.setup_language(self)
		self.mr_setup_language()
		self.mr_init_controls()
		self.mr_init_frame()

	def mr_init_controls(self):
		for which in ("chart", "simulation_profile", "devlink_profile",
					  "output_profile"):
			ctrl = self.FindWindowByName("%s_ctrl" % which)
			setattr(self, "%s_ctrl" % which, ctrl)
			ctrl.changeCallback = getattr(self, "%s_ctrl_handler" % which)
			if which not in ("devlink_profile", "output_profile"):
				if which == "chart":
					wildcard = "\.(cie|ti1|ti3)$"
				else:
					wildcard = "\.(icc|icm)$"
				history = []
				if which == "simulation_profile":
					standard_profiles = config.get_standard_profiles(True)
					basenames = []
					for path in standard_profiles:
						basename = os.path.basename(path)
						if not basename in basenames:
							basenames.append(basename)
							history.append(path)
				else:
					paths = get_data_path("ref", wildcard) or []
					for path in paths:
						basepath, ext = os.path.splitext(path)
						if not (path.lower().endswith(".ti2") and
								basepath + ".cie" in paths):
							history.append(path)
				history = sorted(history, key=lambda path:
											  os.path.basename(path).lower())
				ctrl.SetHistory(history)
			ctrl.SetMaxFontSize(11)
			# Drop targets
			handler = getattr(self, "%s_drop_handler" % which)
			if which.endswith("_profile"):
				drophandlers = {".icc": handler,
								".icm": handler}
			else:
				drophandlers = {".cgats": handler,
								".cie": handler,
								".ti1": handler,
								".ti2": handler,
								".ti3": handler,
								".txt": handler}
			ctrl.SetDropTarget(FileDrop(self, drophandlers))

		# Bind event handlers
		self.fields_ctrl.Bind(wx.EVT_CHOICE,
							  self.fields_ctrl_handler)
		self.chart_btn.Bind(wx.EVT_BUTTON, self.chart_btn_handler)
		self.simulation_profile_cb.Bind(wx.EVT_CHECKBOX,
									  self.use_simulation_profile_ctrl_handler)
		self.use_simulation_profile_as_output_cb.Bind(wx.EVT_CHECKBOX,
													  self.use_simulation_profile_as_output_handler)
		self.enable_3dlut_cb.Bind(wx.EVT_CHECKBOX, self.enable_3dlut_handler)
		self.apply_none_ctrl.Bind(wx.EVT_RADIOBUTTON,
								  self.apply_trc_ctrl_handler)
		self.apply_black_offset_ctrl.Bind(wx.EVT_RADIOBUTTON,
										  self.apply_trc_ctrl_handler)
		self.apply_trc_ctrl.Bind(wx.EVT_RADIOBUTTON,
								 self.apply_trc_ctrl_handler)
		self.mr_trc_ctrl.Bind(wx.EVT_CHOICE, self.mr_trc_ctrl_handler)
		self.mr_trc_gamma_ctrl.Bind(wx.EVT_COMBOBOX,
								 self.mr_trc_gamma_ctrl_handler)
		self.mr_trc_gamma_ctrl.Bind(wx.EVT_KILL_FOCUS,
								 self.mr_trc_gamma_ctrl_handler)
		self.mr_trc_gamma_type_ctrl.Bind(wx.EVT_CHOICE,
									  self.mr_trc_gamma_type_ctrl_handler)
		self.mr_black_output_offset_ctrl.Bind(wx.EVT_SLIDER,
										   self.mr_black_output_offset_ctrl_handler)
		self.mr_black_output_offset_intctrl.Bind(wx.EVT_TEXT,
											  self.mr_black_output_offset_ctrl_handler)
		self.simulate_whitepoint_cb.Bind(wx.EVT_CHECKBOX,
										 self.simulate_whitepoint_ctrl_handler)
		self.simulate_whitepoint_relative_cb.Bind(wx.EVT_CHECKBOX,
												  self.simulate_whitepoint_relative_ctrl_handler)
		self.devlink_profile_cb.Bind(wx.EVT_CHECKBOX,
									 self.use_devlink_profile_ctrl_handler)
		self.output_profile_current_btn.Bind(wx.EVT_BUTTON,
											 self.output_profile_current_ctrl_handler)
		
		self.mr_update_controls()

	def mr_init_frame(self):
		self.measurement_report_btn.SetDefault()

		self.update_layout()
		
		config.defaults.update({
			"position.reportframe.x": self.GetDisplay().ClientArea[0] + 40,
			"position.reportframe.y": self.GetDisplay().ClientArea[1] + 60,
			"size.reportframe.w": self.GetMinSize()[0],
			"size.reportframe.h": self.GetMinSize()[1]})

		if (hascfg("position.reportframe.x") and
			hascfg("position.reportframe.y") and
			hascfg("size.reportframe.w") and
			hascfg("size.reportframe.h")):
			self.SetSaneGeometry(int(getcfg("position.reportframe.x")),
								 int(getcfg("position.reportframe.y")),
								 int(getcfg("size.reportframe.w")),
								 int(getcfg("size.reportframe.h")))
		else:
			self.Center()
	
	def OnClose(self, event=None):
		if (self.IsShownOnScreen() and not self.IsMaximized() and
			not self.IsIconized()):
			x, y = self.GetScreenPosition()
			setcfg("position.reportframe.x", x)
			setcfg("position.reportframe.y", y)
			setcfg("size.reportframe.w", self.GetSize()[0])
			setcfg("size.reportframe.h", self.GetSize()[1])
		config.writecfg()
		if event:
			event.Skip()
	
	def apply_trc_ctrl_handler(self, event):
		v = self.apply_trc_ctrl.GetValue()
		setcfg("measurement_report.apply_trc", int(v))
		setcfg("measurement_report.apply_black_offset",
			   int(self.apply_black_offset_ctrl.GetValue()))
		self.mr_update_main_controls()

	def mr_black_output_offset_ctrl_handler(self, event):
		if event.GetId() == self.mr_black_output_offset_intctrl.GetId():
			self.mr_black_output_offset_ctrl.SetValue(
				self.mr_black_output_offset_intctrl.GetValue())
		else:
			self.mr_black_output_offset_intctrl.SetValue(
				self.mr_black_output_offset_ctrl.GetValue())
		v = self.mr_black_output_offset_ctrl.GetValue() / 100.0
		if v != getcfg("measurement_report.trc_output_offset"):
			setcfg("measurement_report.trc_output_offset", v)
			self.mr_update_trc_control()
			self.mr_show_trc_controls()

	def mr_trc_gamma_ctrl_handler(self, event):
		try:
			v = float(self.mr_trc_gamma_ctrl.GetValue().replace(",", "."))
			if (v < config.valid_ranges["measurement_report.trc_gamma"][0] or
				v > config.valid_ranges["measurement_report.trc_gamma"][1]):
				raise ValueError()
		except ValueError:
			wx.Bell()
			self.mr_trc_gamma_ctrl.SetValue(str(getcfg("measurement_report.trc_gamma")))
		else:
			if str(v) != self.mr_trc_gamma_ctrl.GetValue():
				self.mr_trc_gamma_ctrl.SetValue(str(v))
			if v != getcfg("measurement_report.trc_gamma"):
				setcfg("measurement_report.trc_gamma", v)
				self.mr_update_trc_control()
				self.mr_show_trc_controls()
		event.Skip()

	def mr_trc_ctrl_handler(self, event):
		self.Freeze()
		if self.mr_trc_ctrl.GetSelection() == 1:
			# BT.1886
			setcfg("measurement_report.trc_gamma", 2.4)
			setcfg("measurement_report.trc_gamma_type", "B")
			setcfg("measurement_report.trc_output_offset", 0.0)
			self.mr_update_trc_controls()
		elif self.mr_trc_ctrl.GetSelection() == 0:
			# Pure power gamma 2.2
			setcfg("measurement_report.trc_gamma", 2.2)
			setcfg("measurement_report.trc_gamma_type", "b")
			setcfg("measurement_report.trc_output_offset", 1.0)
			self.mr_update_trc_controls()
		self.mr_show_trc_controls()
		self.Thaw()

	def mr_trc_gamma_type_ctrl_handler(self, event):
		v = self.trc_gamma_types_ab[self.mr_trc_gamma_type_ctrl.GetSelection()]
		if v != getcfg("measurement_report.trc_gamma_type"):
			setcfg("measurement_report.trc_gamma_type", v)
			self.mr_update_trc_control()
			self.mr_show_trc_controls()
	
	def chart_btn_handler(self, event):
		if self.Parent:
			parent = self.Parent
		else:
			parent = self
		chart = getcfg("measurement_report.chart")
		if not hasattr(parent, "tcframe"):
			parent.tcframe = TestchartEditor(parent, path=chart,
											 cfg="measurement_report.chart",
											 parent_set_chart_methodname="mr_set_testchart")
		elif (not hasattr(parent.tcframe, "ti1") or
			  chart != parent.tcframe.ti1.filename):
			parent.tcframe.tc_load_cfg_from_ti1(None, chart,
												"measurement_report.chart",
												"mr_set_testchart")
		setcfg("tc.show", 1)
		parent.tcframe.Show()
		parent.tcframe.Raise()
	
	def chart_ctrl_handler(self, event):
		chart = self.chart_ctrl.GetPath()
		values = []
		try:
			cgats = CGATS.CGATS(chart)
		except (IOError, CGATS.CGATSInvalidError, 
				CGATS.CGATSInvalidOperationError, CGATS.CGATSKeyError, 
				CGATS.CGATSTypeError, CGATS.CGATSValueError), exception:
			show_result_dialog(exception, self)
		else:
			data_format = cgats.queryv1("DATA_FORMAT")
			accurate = cgats.queryv1("ACCURATE_EXPECTED_VALUES") == "true"
			if data_format:
				basename, ext = os.path.splitext(chart)
				for column in data_format.itervalues():
					column_prefix = column.split("_")[0]
					if (column_prefix in ("CMYK", "LAB", "RGB", "XYZ") and
						column_prefix not in values and
						(((ext.lower() == ".cie" or accurate) and
						  column_prefix in ("LAB", "XYZ")) or
						 (ext.lower() == ".ti1" and
						  column_prefix in ("CMYK", "RGB")) or
						 (ext.lower() not in (".cie", ".ti1")))):
						values.append(column_prefix)
				if values:
					self.panel.Freeze()
					self.fields_ctrl.SetItems(values)
					self.fields_ctrl.GetContainingSizer().Layout()
					self.panel.Thaw()
					fields = getcfg("measurement_report.chart.fields")
					if ext.lower() == ".ti1":
						index = 0
					elif "RGB" in values and not ext.lower() == ".cie":
						index = values.index("RGB")
					elif "CMYK" in values:
						index = values.index("CMYK")
					elif "XYZ" in values:
						index = values.index("XYZ")
					elif "LAB" in values:
						index = values.index("LAB")
					else:
						index = 0
					self.fields_ctrl.SetSelection(index)
					setcfg("measurement_report.chart", chart)
					self.chart_patches_amount.Freeze()
					self.chart_patches_amount.SetLabel(
						str(cgats.queryv1("NUMBER_OF_SETS") or ""))
					self.update_estimated_measurement_time("chart")
					self.chart_patches_amount.GetContainingSizer().Layout()
					self.chart_patches_amount.Thaw()
					self.chart_white = cgats.get_white_cie()
					if event:
						v = int(not self.chart_white or not "RGB" in values)
						setcfg("measurement_report.whitepoint.simulate", v)
						setcfg("measurement_report.whitepoint.simulate.relative", v)
			if not values:
				if chart:
					show_result_dialog(lang.getstr("error.testchart.missing_fields",
												   (chart, "RGB/CMYK %s LAB/XYZ" %
														   lang.getstr("or"))), self)
				self.chart_ctrl.SetPath(getcfg("measurement_report.chart"))
			else:
				self.chart_btn.Enable("RGB" in values)
				if self.Parent:
					parent = self.Parent
				else:
					parent = self
				if (event and self.chart_btn.Enabled and
					hasattr(parent, "tcframe") and
					self.tcframe.IsShownOnScreen() and
					(not hasattr(parent.tcframe, "ti1") or
					 chart != parent.tcframe.ti1.filename)):
					parent.tcframe.tc_load_cfg_from_ti1(None, chart,
														"measurement_report.chart",
														"mr_set_testchart")
		self.fields_ctrl.Enable(self.fields_ctrl.GetCount() > 1)
		self.fields_ctrl_handler(event)

	def chart_drop_handler(self, path):
		if not self.worker.is_working():
			self.chart_ctrl.SetPath(path)
			self.chart_ctrl_handler(True)
	
	def devlink_profile_ctrl_handler(self, event):
		self.set_profile("devlink")

	def devlink_profile_drop_handler(self, path):
		if not self.worker.is_working():
			self.devlink_profile_ctrl.SetPath(path)
			self.set_profile("devlink")
	
	def enable_3dlut_handler(self, event):
		setcfg("3dlut.enable", int(self.enable_3dlut_cb.GetValue()))
		setcfg("measurement_report.use_devlink_profile", 0)
		self.mr_update_main_controls()
	
	def fields_ctrl_handler(self, event):
		setcfg("measurement_report.chart.fields",
			   self.fields_ctrl.GetStringSelection())
		if event:
			self.mr_update_main_controls()
	
	def output_profile_ctrl_handler(self, event):
		self.set_profile("output")
	
	def output_profile_current_ctrl_handler(self, event):
		profile_path = get_current_profile_path(True, True)
		if profile_path and os.path.isfile(profile_path):
			self.output_profile_ctrl.SetPath(profile_path)
			self.set_profile("output")

	def output_profile_drop_handler(self, path):
		if not self.worker.is_working():
			self.output_profile_ctrl.SetPath(path)
			self.set_profile("output")
	
	def set_profile(self, which, profile_path=None, silent=False):
		path = getattr(self, "%s_profile_ctrl" % which).GetPath()
		if which == "output":
			##if profile_path is None:
				##profile_path = get_current_profile_path(True, True)
			##self.output_profile_current_btn.Enable(self.output_profile_ctrl.IsShown() and
												   ##bool(profile_path) and
												   ##os.path.isfile(profile_path) and
												   ##profile_path != path)
			profile = config.get_current_profile(True)
			if profile:
				path = profile.fileName
			else:
				path = None
			setcfg("measurement_report.output_profile", path)
			# XYZbpout will be set to the blackpoint of the selected profile.
			# This is used to determine if black output offset controls should
			# be shown. Set a initial value slightly above zero so output
			# offset controls are shown if the selected profile doesn't exist.
			self.XYZbpout = [0.001, 0.001, 0.001]
		else:
			profile = None
			if which == "input":
				self.XYZbpin = [0, 0, 0]
		if path or profile:
			if path and not os.path.isfile(path):
				if not silent:
					show_result_dialog(Error(lang.getstr("file.missing", path)),
									   parent=self)
				return
			if not profile:
				try:
					profile = ICCP.ICCProfile(path)
				except (IOError, ICCP.ICCProfileInvalidError):
					if not silent:
						show_result_dialog(Error(lang.getstr("profile.invalid") +
												 "\n" + path),
										   parent=self)
				except IOError, exception:
					if not silent:
						show_result_dialog(exception, parent=self)
			if profile:
				if ((which == "simulation" and
					 (profile.profileClass not in ("mntr", "prtr") or 
					  profile.colorSpace not in ("CMYK", "RGB"))) or
					(which == "output" and (profile.profileClass != "mntr" or
											profile.colorSpace != "RGB")) or
					(which == "devlink" and profile.profileClass != "link")):
					show_result_dialog(NotImplementedError(lang.getstr("profile.unsupported", 
																	   (profile.profileClass, 
																		profile.colorSpace))),
									   parent=self)
				else:
					if (not getattr(self, which + "_profile", None) or
						getattr(self, which + "_profile").fileName !=
						profile.fileName):
						if which == "simulation":
							# Get profile blackpoint so we can check if it makes
							# sense to show TRC type and output offset controls
							try:
								odata = self.worker.xicclu(profile, (0, 0, 0),
														   pcs="x")
							except Exception, exception:
								show_result_dialog(exception, self)
								self.set_profile_ctrl_path(which)
								return
							else:
								if len(odata) != 1 or len(odata[0]) != 3:
									show_result_dialog("Blackpoint is invalid: %s"
													   % odata, self)
									self.set_profile_ctrl_path(which)
									return
								self.XYZbpin = odata[0]
						elif which == "output":
							# Get profile blackpoint so we can check if input
							# values would be clipped
							try:
								odata = self.worker.xicclu(profile, (0, 0, 0),
														   pcs="x")
							except Exception, exception:
								show_result_dialog(exception, self)
								self.set_profile_ctrl_path(which)
								return
							else:
								if len(odata) != 1 or len(odata[0]) != 3:
									show_result_dialog("Blackpoint is invalid: %s"
													   % odata, self)
									self.set_profile_ctrl_path(which)
									return
								self.XYZbpout = odata[0]
					setattr(self, "%s_profile" % which, profile)
					if not silent:
						setcfg("measurement_report.%s_profile" % which,
							   profile and profile.fileName)
						if which == "simulation":
							self.use_simulation_profile_ctrl_handler(None)
						elif hasattr(self, "XYZbpin"):
							self.mr_update_main_controls()
					return profile
			if path:
				self.set_profile_ctrl_path(which)
		else:
			setattr(self, "%s_profile" % which, None)
			if not silent:
				setcfg("measurement_report.%s_profile" % which, None)
				self.mr_update_main_controls()

	def set_profile_ctrl_path(self, which):
		getattr(self, "%s_profile_ctrl" %
					  which).SetPath(getcfg("measurement_report.%s_profile" % which))
	
	def mr_setup_language(self):
		# Shared with main window
		
		for which in ("chart", "simulation_profile", "devlink_profile",
					  "output_profile"):
			if which.endswith("_profile"):
				wildcard = lang.getstr("filetype.icc")  + "|*.icc;*.icm"
			else:
				wildcard = (lang.getstr("filetype.ti1_ti3_txt") + 
							"|*.cgats;*.cie;*.ti1;*.ti2;*.ti3;*.txt")
			msg = {"chart": "measurement_report_choose_chart_or_reference",
				   "devlink_profile": "devicelink_profile",
				   "output_profile": "measurement_report_choose_profile"}.get(which, which)
			kwargs = dict(toolTip=lang.getstr(msg).rstrip(":"),
						  dialogTitle=lang.getstr(msg), 
						  fileMask=wildcard)
			ctrl = getattr(self, "%s_ctrl" % which)
			for name, value in kwargs.iteritems():
				setattr(ctrl, name, value)

		items = []
		for item in ("Gamma 2.2", "trc.rec1886", "custom"):
			items.append(lang.getstr(item))
		self.mr_trc_ctrl.SetItems(items)
		
		self.trc_gamma_types_ab = {0: "b", 1: "B"}
		self.trc_gamma_types_ba = {"b": 0, "B": 1}
		self.mr_trc_gamma_type_ctrl.SetItems([lang.getstr("trc.type.relative"),
											  lang.getstr("trc.type.absolute")])

	def mr_show_trc_controls(self):
		shown = self.apply_trc_ctrl.IsShown()
		enable6 = (shown and
				   bool(getcfg("measurement_report.apply_trc")))
		show = shown and self.mr_trc_ctrl.GetSelection() == 2
		self.panel.Freeze()
		self.mr_trc_ctrl.Enable(enable6)
		self.mr_trc_ctrl.Show(shown)
		self.mr_trc_gamma_label.Enable(enable6)
		self.mr_trc_gamma_label.Show(show)
		self.mr_trc_gamma_ctrl.Enable(enable6)
		self.mr_trc_gamma_ctrl.Show(show)
		self.mr_trc_gamma_type_ctrl.Enable(enable6)
		self.mr_black_output_offset_label.Enable(enable6 and
											     self.XYZbpout > [0, 0, 0])
		self.mr_black_output_offset_label.Show(show and
											   self.XYZbpout > [0, 0, 0])
		self.mr_black_output_offset_ctrl.Enable(enable6 and
											    self.XYZbpout > [0, 0, 0])
		self.mr_black_output_offset_ctrl.Show(show and
											  self.XYZbpout > [0, 0, 0])
		self.mr_black_output_offset_intctrl.Enable(enable6 and
												   self.XYZbpout > [0, 0, 0])
		self.mr_black_output_offset_intctrl.Show(show and
												 self.XYZbpout > [0, 0, 0])
		self.mr_black_output_offset_intctrl_label.Enable(enable6 and
													     self.XYZbpout > [0, 0, 0])
		self.mr_black_output_offset_intctrl_label.Show(show and
													   self.XYZbpout > [0, 0, 0])
		self.mr_trc_gamma_type_ctrl.Show(show and
										 self.XYZbpout > [0, 0, 0])
		self.panel.Layout()
		self.panel.Thaw()
	
	def simulate_whitepoint_ctrl_handler(self, event):
		v = self.simulate_whitepoint_cb.GetValue()
		setcfg("measurement_report.whitepoint.simulate", int(v))
		self.mr_update_main_controls()
		
	
	def simulate_whitepoint_relative_ctrl_handler(self, event):
		setcfg("measurement_report.whitepoint.simulate.relative",
			   int(self.simulate_whitepoint_relative_cb.GetValue()))
	
	def simulation_profile_ctrl_handler(self, event):
		self.set_profile("simulation")

	def simulation_profile_drop_handler(self, path):
		if not self.worker.is_working():
			self.simulation_profile_ctrl.SetPath(path)
			self.set_profile("simulation")
	
	def mr_update_controls(self):
		""" Update controls with values from the configuration """
		self.panel.Freeze()
		self.simulation_profile_ctrl.SetPath(getcfg("measurement_report.simulation_profile"))
		self.set_profile("simulation", silent=True)
		self.mr_update_trc_controls()
		self.devlink_profile_ctrl.SetPath(getcfg("measurement_report.devlink_profile"))
		self.set_profile("devlink", silent=True)
		self.output_profile_ctrl.SetPath(getcfg("measurement_report.output_profile"))
		self.set_profile("output", silent=True)
		self.mr_set_testchart(getcfg("measurement_report.chart"))
		self.use_simulation_profile_ctrl_handler(None)
		self.panel.Thaw()

	def mr_update_trc_control(self):
		if (getcfg("measurement_report.trc_gamma_type") == "B" and
			getcfg("measurement_report.trc_output_offset") == 0 and
			getcfg("measurement_report.trc_gamma") == 2.4):
			self.mr_trc_ctrl.SetSelection(1)  # BT.1886
		elif (getcfg("measurement_report.trc_gamma_type") == "b" and
			getcfg("measurement_report.trc_output_offset") == 1 and
			getcfg("measurement_report.trc_gamma") == 2.2):
			self.mr_trc_ctrl.SetSelection(0)  # Pure power gamma 2.2
		else:
			self.mr_trc_ctrl.SetSelection(2)  # Custom

	def mr_update_trc_controls(self):
		self.mr_update_trc_control()
		self.mr_trc_gamma_ctrl.SetValue(str(getcfg("measurement_report.trc_gamma")))
		self.mr_trc_gamma_type_ctrl.SetSelection(self.trc_gamma_types_ba[getcfg("measurement_report.trc_gamma_type")])
		outoffset = int(getcfg("measurement_report.trc_output_offset") * 100)
		self.mr_black_output_offset_ctrl.SetValue(outoffset)
		self.mr_black_output_offset_intctrl.SetValue(outoffset)
	
	def mr_set_testchart(self, path):
		self.chart_ctrl.SetPath(path)
		self.chart_ctrl_handler(None)
	
	def mr_update_main_controls(self):
		##print "MR update main ctrls",
		self.panel.Freeze()
		chart_has_white = bool(getattr(self, "chart_white", None))
		color = getcfg("measurement_report.chart.fields")
		sim_profile_color = (getattr(self, "simulation_profile", None) and
							 self.simulation_profile.colorSpace)
		if getcfg("measurement_report.use_simulation_profile"):
			setcfg("measurement_report.use_simulation_profile",
				   int(sim_profile_color == color))
		self.simulation_profile_cb.Enable(sim_profile_color == color)
		self.simulation_profile_cb.Show(color in ("CMYK", "RGB"))
		enable1 = bool(getcfg("measurement_report.use_simulation_profile"))
		##print enable1,
		enable2 = (sim_profile_color == "RGB" and
				   bool(getcfg("measurement_report.use_simulation_profile_as_output")))
		self.simulation_profile_cb.SetValue(enable1)
		self.simulation_profile_ctrl.Show(color in ("CMYK", "RGB"))
		self.use_simulation_profile_as_output_cb.Show(enable1 and
														sim_profile_color == "RGB")
		self.use_simulation_profile_as_output_cb.SetValue(enable1 and enable2)
		self.enable_3dlut_cb.Enable(enable1 and enable2)
		self.enable_3dlut_cb.SetValue(enable1 and enable2 and
									  bool(getcfg("3dlut.enable")))
		self.enable_3dlut_cb.Show(enable1 and sim_profile_color == "RGB" and
								  config.get_display_name() in ("madVR",
																"Prisma"))
		enable5 = (sim_profile_color == "RGB" and
				   isinstance(self.simulation_profile.tags.get("rXYZ"),
							  ICCP.XYZType) and
				   isinstance(self.simulation_profile.tags.get("gXYZ"),
							  ICCP.XYZType) and
				   isinstance(self.simulation_profile.tags.get("bXYZ"),
							  ICCP.XYZType))
		##print enable5, self.XYZbpin, self.XYZbpout
		self.mr_trc_label.Show(enable1 and enable5)
		self.apply_none_ctrl.Show(enable1 and enable5)
		self.apply_none_ctrl.SetValue(
			(not getcfg("measurement_report.apply_black_offset") and
			 not getcfg("measurement_report.apply_trc")) or
			 not enable5)
		self.apply_black_offset_ctrl.Show(enable1 and enable5)
		self.apply_black_offset_ctrl.SetValue(enable5 and
			bool(getcfg("measurement_report.apply_black_offset")))
		self.apply_trc_ctrl.Show(enable1 and enable5)
		self.apply_trc_ctrl.SetValue(enable5 and
			bool(getcfg("measurement_report.apply_trc")))
		enable6 = (enable1 and enable5 and
				   bool(getcfg("measurement_report.apply_trc") or
						getcfg("measurement_report.apply_black_offset")))
		self.mr_show_trc_controls()
		show = (self.apply_none_ctrl.GetValue() and
				enable1 and enable5 and
				self.XYZbpout > self.XYZbpin)
		self.input_value_clipping_bmp.Show(show)
		self.input_value_clipping_label.Show(show)
		self.simulate_whitepoint_cb.Enable((enable1 and not enable2) or
										   (color in ("LAB", "XYZ") and
											chart_has_white))
		enable3 = bool(getcfg("measurement_report.whitepoint.simulate"))
		self.simulate_whitepoint_cb.SetValue(((enable1 and not enable2) or
											  color in ("LAB", "XYZ")) and
											 enable3)
		self.simulate_whitepoint_relative_cb.Enable(((enable1 and not enable2) or
													 color in ("LAB", "XYZ")) and
													enable3)
		self.simulate_whitepoint_relative_cb.SetValue(
			((enable1 and not enable2) or color in ("LAB", "XYZ")) and
			enable3 and
			bool(getcfg("measurement_report.whitepoint.simulate.relative")))
		self.devlink_profile_cb.Show(enable1 and enable2)
		enable4 = bool(getcfg("measurement_report.use_devlink_profile"))
		self.devlink_profile_cb.SetValue(enable1 and enable2 and enable4)
		self.devlink_profile_ctrl.Enable(enable1 and enable2 and enable4)
		self.devlink_profile_ctrl.Show(enable1 and enable2)
		self.output_profile_label.Enable((color in ("LAB", "RGB", "XYZ") or
										  enable1) and
										 (not enable1 or not enable2 or
										  self.apply_trc_ctrl.GetValue() or
										  self.apply_black_offset_ctrl.GetValue()))
		self.output_profile_ctrl.Enable((color in ("LAB", "RGB", "XYZ") or
										 enable1) and
										(not enable1 or not enable2 or
										 self.apply_trc_ctrl.GetValue() or
										 self.apply_black_offset_ctrl.GetValue()))
		output_profile = ((hasattr(self, "presets") and
						   getcfg("measurement_report.output_profile")
						   not in self.presets or not hasattr(self, "presets")) and
						  bool(getattr(self, "output_profile", None)))
		self.measurement_report_btn.Enable(((enable1 and enable2 and (not enable6 or
														   output_profile) and
								  (not enable4 or
								   (bool(getcfg("measurement_report.devlink_profile")) and
								    os.path.isfile(getcfg("measurement_report.devlink_profile"))))) or
								 (((not enable1 and
								    color in ("LAB", "RGB", "XYZ")) or
								   (enable1 and sim_profile_color == color and
								    not enable2)) and
								  output_profile)) and
								 bool(getcfg("measurement_report.chart")) and
								 os.path.isfile(getcfg("measurement_report.chart")))
		self.panel.Layout()
		self.panel.Thaw()
		if hasattr(self, "update_scrollbars"):
			self.update_scrollbars()
			self.calpanel.Layout()
		else:
			self.update_layout()

	def update_estimated_measurement_time(self, which, patches=None):
		""" Update the estimated measurement time shown """
		integration_time = self.worker.get_instrument_features().get("integration_time")
		if integration_time:
			if which == "chart" and not patches:
				patches = int(self.chart_patches_amount.Label)
			opatches = patches
			# Scale integration time based on display technology
			tech = getcfg("display.technology").lower()
			prop = [1, 1]
			if "plasma" in tech or "crt" in tech:
				prop[0] = 1.9
			elif "projector" in tech or "dlp" in tech:
				prop[0] = 2.2
				prop[1] = 2.2
			elif "oled" in tech:
				prop[0] = 2.2
			integration_time = [min(prop[i] * v, 20) for i, v in
								enumerate(integration_time)]
			# Get time per patch (tpp)
			tpp = [v for v in integration_time]
			if (("plasma" in tech or "crt" in tech or "projector" in tech or
				 "dlp" in tech) and self.worker.get_instrument_name() in
				("ColorMunki", "DTP92", "DTP94", "i1 Display", "i1 Display 1",
				 "i1 Display 2", "i1 DisplayPro, ColorMunki Display",
				 "i1 Monitor", "i1 Pro", "i1 Pro 2", "K-10", "specbos",
				 "Spyder2", "Spyder3", "Spyder4", "Spyder5")):
				# Not all instruments can measure refresh rate! Add .25 secs
				# for those who do if refresh mode is used.
				tpp = [v + .25 for v in tpp]
			if config.get_display_name() == "madVR":
				# madVR takes a tad longer
				tpp = [v + .45 for v in tpp]
			min_delay_s = .2
			if getcfg("measure.override_min_display_update_delay_ms"):
				# Add additional display update delay (zero at <= 200 ms)
				min_delay_ms = getcfg("measure.min_display_update_delay_ms")
				min_delay_s = max(min_delay_ms / 1000.0, min_delay_s)
			if getcfg("measure.override_display_settle_time_mult"):
				# We don't have access to display rise/fall time, so use this as
				# generic delay multiplier
				settle_mult = getcfg("measure.display_settle_time_mult")
			else:
				settle_mult = 1.0
			tpp = [v + min_delay_s + .145 * settle_mult for v in tpp]
			avg_delay = sum(tpp) / (8 / 3.0)
			seconds = avg_delay * patches
			oseconds = seconds
			if getcfg("drift_compensation.blacklevel"):
				# Assume black patch every 60 seconds
				seconds += math.ceil(oseconds / 60.0) * ((20 - tpp[0]) / 2.0 + tpp[0])
				# Assume black patch every n samples
				seconds += math.ceil(opatches / 40.0) * ((20 - tpp[0]) / 2.0 + tpp[0])
			if getcfg("drift_compensation.whitelevel"):
				# Assume white patch every 60 seconds
				seconds += math.ceil(oseconds / 60.0) * tpp[1]
				# Assume white patch every n samples
				seconds += math.ceil(opatches / 40.0) * tpp[1]
			timestamp = gmtime(seconds)
			hours = int(strftime("%H", timestamp))
			minutes = int(strftime("%M", timestamp))
			minutes += int(math.ceil(int(strftime("%S", timestamp)) / 60.0))
			if minutes > 59:
				minutes = 0
				hours += 1
		else:
			hours, minutes = "--", "--"
		getattr(self, which + "_meas_time").Label = lang.getstr("estimated_measurement_time",
																(hours, minutes))
		# Show visual warning by coloring the text if measurement is going to
		# take a long time. Display and instrument stability and repeatability
		# may be an issue over such long periods of time.
		if hours != "--" and hours > 7:
			# Warning color "red"
			color = "#FF3300"
		elif hours != "--" and hours > 3:
			# Warning color "orange"
			color = "#F07F00"
		else:
			# Default text color
			color = wx.SystemSettings.GetColour(wx.SYS_COLOUR_WINDOWTEXT)
		getattr(self, which + "_meas_time").ForegroundColour = color
	
	def use_devlink_profile_ctrl_handler(self, event):
		setcfg("3dlut.enable", 0)
		setcfg("measurement_report.use_devlink_profile",
			   int(self.devlink_profile_cb.GetValue()))
		self.mr_update_main_controls()
	
	def use_simulation_profile_ctrl_handler(self, event):
		if event:
			use_sim_profile = self.simulation_profile_cb.GetValue()
			setcfg("measurement_report.use_simulation_profile",
				   int(use_sim_profile))
		else:
			use_sim_profile = getcfg("measurement_report.use_simulation_profile")
		sim_profile = getattr(self, "simulation_profile", None)
		enable = False
		if sim_profile:
			v = int(sim_profile.profileClass == "prtr")
			setcfg("measurement_report.whitepoint.simulate", v)
			setcfg("measurement_report.whitepoint.simulate.relative", v)
			if ("rTRC" in sim_profile.tags and "gTRC" in sim_profile.tags and
				"bTRC" in sim_profile.tags and sim_profile.tags.rTRC ==
				sim_profile.tags.gTRC == sim_profile.tags.bTRC and
				isinstance(sim_profile.tags.rTRC, ICCP.CurveType)):
				tf = sim_profile.tags.rTRC.get_transfer_function()
				# Use BT.1886 gamma mapping for SMPTE 240M / Rec. 709 TRC
				setcfg("measurement_report.apply_trc",
					   int(tf[0][1] in (-240, -709) or
						   (tf[0][0].startswith("Gamma") and tf[1] >= .95)))
				# Use only BT.1886 black output offset
				setcfg("measurement_report.apply_black_offset",
					   int(tf[0][1] not in (-240, -709) and
						   (not tf[0][0].startswith("Gamma") or tf[1] < .95) and
						   self.XYZbpin != self.XYZbpout))
				# Set gamma to profile gamma if single gamma profile
				if tf[0][0].startswith("Gamma") and tf[1] >= .95:
					if not getcfg("measurement_report.trc_gamma.backup", False):
						# Backup current gamma
						setcfg("measurement_report.trc_gamma.backup",
							   getcfg("measurement_report.trc_gamma"))
					setcfg("measurement_report.trc_gamma", round(tf[0][1], 2))
				# Restore previous gamma if not single gamma profile
				elif getcfg("measurement_report.trc_gamma.backup", False):
					setcfg("measurement_report.trc_gamma",
						   getcfg("measurement_report.trc_gamma.backup"))
					setcfg("measurement_report.trc_gamma.backup", None)
				self.mr_update_trc_controls()
				enable = (tf[0][1] not in (-240, -709) and
						  self.XYZbpin != self.XYZbpout)
		self.apply_black_offset_ctrl.Enable(use_sim_profile and enable)
		self.mr_update_main_controls()

	def use_simulation_profile_as_output_handler(self, event):
		setcfg("measurement_report.use_simulation_profile_as_output",
			   int(self.use_simulation_profile_as_output_cb.GetValue()))
		self.mr_update_main_controls()


if __name__ == "__main__":
	config.initcfg()
	lang.init()
	lang.update_defaults()
	app = BaseApp(0)
	app.TopWindow = ReportFrame()
	app.TopWindow.Show()
	app.MainLoop()
