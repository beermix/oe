# -*- coding: utf-8 -*-

import math
import os
import re
import subprocess as sp
import sys
import tempfile

from argyll_cgats import cal_to_fake_profile, vcgt_to_cal
from colormath import interp
from config import (fs_enc, get_argyll_display_number, get_data_path,
					get_display_profile, get_display_rects, getcfg, geticon,
					get_verified_path, setcfg)
from log import safe_print
from meta import name as appname
from options import debug
from util_decimal import float2dec
from util_os import waccess
from util_str import safe_unicode
from worker import (Error, UnloggedError, UnloggedInfo, Worker, get_argyll_util,
					make_argyll_compatible_path, show_result_dialog)
from wxaddons import get_platform_window_decoration_size, wx
from wxMeasureFrame import MeasureFrame
from wxwindows import (BaseApp, BaseFrame, BitmapBackgroundPanelText,
					   CustomCheckBox, FileDrop, InfoDialog, TooltipWindow)
from wxfixes import GenBitmapButton as BitmapButton, wx_Panel
import colormath
import config
import wxenhancedplot as plot
import localization as lang
import ICCProfile as ICCP

BGCOLOUR = "#333333"
FGCOLOUR = "#999999"
GRIDCOLOUR = "#444444"

if sys.platform == "darwin":
	FONTSIZE_LARGE = 11
	FONTSIZE_SMALL = 10
else:
	FONTSIZE_LARGE = 9
	FONTSIZE_SMALL = 8


class CoordinateType(list):
	
	"""
	List of coordinates.
	
	[(Y, x)] where Y is in the range 0..100 and x in the range 0..255
	
	"""
	
	def __init__(self, profile=None):
		self.profile = profile
		self._transfer_function = {}
	
	def get_gamma(self, use_vmin_vmax=False, average=True, least_squares=False,
				  slice=(0.01, 0.99)):
		""" Return average or least squares gamma or a list of gamma values """
		if len(self):
			start = slice[0] * 100
			end = slice[1] * 100
			values = []
			for i, (y, x) in enumerate(self):
				n = colormath.XYZ2Lab(0, y, 0)[0]
				if n >= start and n <= end:
					values.append((x / 255.0 * 100, y))
		else:
			# Identity
			if average or least_squares:
				return 1.0
			return [1.0]
		vmin = 0
		vmax = 100.0
		if use_vmin_vmax:
			if len(self) > 2:
				vmin = self[0][0]
				vmax = self[-1][0]
		return colormath.get_gamma(values, 100.0, vmin, vmax, average, least_squares)
	
	def get_transfer_function(self, best=True, slice=(0.05, 0.95)):
		"""
		Return transfer function name, exponent and match percentage
		
		"""
		transfer_function = self._transfer_function.get((best, slice))
		if transfer_function:
			return transfer_function
		trc = ICCP.CurveType()
		match = {}
		vmin = self[0][0]
		vmax = self[-1][0]
		best_yx = (0, 255)
		for i, (y, x) in enumerate(self):
			if x - 127.5 > 0 and x < best_yx[1]:
				best_yx = (y, x)
		gamma = colormath.get_gamma([(best_yx[1] / 255.0 * 100.0, best_yx[0])], 100.0, vmin, vmax)
		for name, exp in (("Rec. 709", -709),
						  ("Rec. 1886", -1886),
						  ("SMPTE 240M", -240),
						  ("SMPTE 2084", -2084),
						  ("DICOM", -1023),
						  ("L*", -3.0),
						  ("sRGB", -2.4),
						  ("Gamma %.2f" % gamma, gamma)):
			if name in ("DICOM", "Rec. 1886", "SMPTE 2084"):
				if self.profile and isinstance(self.profile.tags.get("lumi"),
											   ICCP.XYZType):
					white_cdm2 = self.profile.tags.lumi.Y
				else:
					white_cdm2 = 100.0
				black_Y = vmin / 100.0
				black_cdm2 = black_Y * white_cdm2
				try:
					if name == "DICOM":
						trc.set_dicom_trc(black_cdm2, white_cdm2, size=len(self))
					elif name == "Rec. 1886":
						trc.set_bt1886_trc(black_Y, size=len(self))
					elif name == "SMPTE 2084":
						trc.set_smpte2084_trc(black_cdm2, white_cdm2, size=len(self))
				except ValueError:
					continue
			else:
				trc.set_trc(exp, len(self), vmin * 655.35, vmax * 655.35)
			match[(name, exp)] = 0.0
			count = 0
			start = slice[0] * 255
			end = slice[1] * 255
			for i, (n, x) in enumerate(self):
				##n = colormath.XYZ2Lab(0, n, 0)[0]
				if x >= start and x <= end:
					n = colormath.get_gamma([(x / 255.0 * 100, n)], 100.0, vmin, vmax, False)
					if n:
						n = n[0]
						##n2 = colormath.XYZ2Lab(0, trc[i][0], 0)[0]
						n2 = colormath.get_gamma([(i / (len(trc) - 1.0) * 65535, trc[i])], 65535, vmin * 655.35, vmax * 655.35, False)
						if n2 and n2[0]:
							n2 = n2[0]
							match[(name, exp)] += 1 - (max(n, n2) - min(n, n2)) / n2
							count += 1
			if count:
				match[(name, exp)] /= count
		if not best:
			self._transfer_function[(best, slice)] = match
			return match
		match, (name, exp) = sorted(zip(match.values(), match.keys()))[-1]
		self._transfer_function[(best, slice)] = (name, exp), match
		return (name, exp), match
	
	def set_trc(self, power=2.2, values=(), vmin=0, vmax=100):
		"""
		Set the response to a certain function.
		
		Positive power, or -2.4 = sRGB, -3.0 = L*, -240 = SMPTE 240M,
		-601 = Rec. 601, -709 = Rec. 709 (Rec. 601 and 709 transfer functions are
		identical)
		
		"""
		self[:] = [[y, x] for y, x in values]
		for i in xrange(len(self)):
			self[i][0] = vmin + colormath.specialpow(self[i][1] / 255.0, power) * (vmax - vmin)


class PolyBox(plot.PolyLine):

	def __init__(self, x, y, w, h, **attr):
		plot.PolyLine.__init__(self, [(x, y), (x + w, y), (x + w, y + h),
									  (x, y + h), (x, y)], **attr)


class LUTCanvas(plot.PlotCanvas):

	def __init__(self, *args, **kwargs):
		plot.PlotCanvas.__init__(self, *args, **kwargs)
		self.Unbind(wx.EVT_SCROLL_THUMBTRACK)
		self.Unbind(wx.EVT_SCROLL_PAGEUP)
		self.Unbind(wx.EVT_SCROLL_PAGEDOWN)
		self.Unbind(wx.EVT_SCROLL_LINEUP)
		self.Unbind(wx.EVT_SCROLL_LINEDOWN)
		self.HandCursor = wx.StockCursor(wx.CURSOR_CROSS)
		self.GrabHandCursor = wx.StockCursor(wx.CURSOR_SIZING)
		self.SetBackgroundColour(BGCOLOUR)
		self.SetEnableAntiAliasing(True)
		self.SetEnableHiRes(True)
		self.SetEnableCenterLines(True)
		self.SetEnableDiagonals('Bottomleft-Topright')
		self.SetEnableDrag(True)
		self.SetEnableGrid(False)
		self.SetEnablePointLabel(True)
		self.SetEnableTitle(False)
		self.SetForegroundColour(FGCOLOUR)
		self.SetFontSizeAxis(FONTSIZE_SMALL)
		self.SetFontSizeLegend(FONTSIZE_SMALL)
		self.SetFontSizeTitle(FONTSIZE_LARGE)
		self.SetGridColour(GRIDCOLOUR)
		self.setLogScale((False,False))
		self.SetPointLabelFunc(self.DrawPointLabel)
		self.canvas.BackgroundColour = BGCOLOUR
		if sys.platform == "win32" and sys.getwindowsversion() >= (6, ):
			# Enable/disable double buffering on-the-fly to make pointlabel work
			self.canvas.Bind(wx.EVT_ENTER_WINDOW, self._disabledoublebuffer)
			self.canvas.Bind(wx.EVT_LEAVE_WINDOW, self._enabledoublebuffer)
		self.worker = Worker(self.TopLevelParent)
		self.errors = []
		self.resetzoom()

	def DrawLUT(self, vcgt=None, title=None, xLabel=None, yLabel=None, 
				r=True, g=True, b=True):
		if not title:
			title = ""
		if not xLabel:
			xLabel = ""
		if not yLabel:
			yLabel = ""
		
		detect_increments = False
		Plot = plot.PolyLine
		Plot._attributes["width"] = 1

		maxv = 65535
		linear_points = []
		
		axis_y = 255.0
		if xLabel in ("L*", "Y"):
			axis_x = 100.0
		else:
			axis_x = 255.0
		self.axis_x, self.axis_y = (0, axis_x), (0, axis_y)
		if not self.last_draw:
			self.center_x = axis_x / 2.0
			self.center_y = axis_y / 2.0
		self.proportional = False
		self.spec_x = self.spec_y = 5

		lines = [PolyBox(0, 0, axis_x, axis_y, colour=GRIDCOLOUR, width=1)]
		
		self.point_grid = [{}, {}, {}]

		if not vcgt:
			irange = range(0, 256)
		elif "data" in vcgt: # table
			data = list(vcgt['data'])
			while len(data) < 3:
				data.append(data[0])
			r_points = []
			g_points = []
			b_points = []
			if (not isinstance(vcgt, ICCP.VideoCardGammaTableType) and
				not isinstance(data[0], ICCP.CurveType)):
				# Coordinate list
				irange = range(0, len(data[0]))
				for i in xrange(len(data)):
					if i == 0 and r:
						for n, y in data[i]:
							if xLabel == "L*":
								n = colormath.XYZ2Lab(0, n / axis_x * 100, 0)[0] * (axis_x / 100.0)
							r_points.append([n, y])
							self.point_grid[i][n] = y
					elif i == 1 and g:
						for n, y in data[i]:
							if xLabel == "L*":
								n = colormath.XYZ2Lab(0, n / axis_x * 100, 0)[0] * (axis_x / 100.0)
							g_points.append([n, y])
							self.point_grid[i][n] = y
					elif i == 2 and b:
						for n, y in data[i]:
							if xLabel == "L*":
								n = colormath.XYZ2Lab(0, n / axis_x * 100, 0)[0] * (axis_x / 100.0)
							b_points.append([n, y])
							self.point_grid[i][n] = y
			else:
				irange = range(0, vcgt['entryCount'])
				maxv = math.pow(256, vcgt['entrySize']) - 1
				for i in irange:
					j = i * (axis_y / (vcgt['entryCount'] - 1))
					if not detect_increments:
						linear_points.append([j, j])
					if r:
						n = float(data[0][i]) / maxv * axis_x
						if not detect_increments or not r_points or \
						   i == vcgt['entryCount'] - 1 or n != i:
							if detect_increments and n != i and \
							   len(r_points) == 1 and i > 1 and \
							   r_points[-1][0] == r_points[-1][1]:
								r_points.append([i - 1, i - 1])
							if xLabel == "L*":
								n = colormath.XYZ2Lab(0, n / axis_x * 100, 0)[0] * (axis_x / 100.0)
							if xLabel in ("L*", "Y"):
								r_points.append([n, j])
								self.point_grid[0][n] = j
							else:
								r_points.append([j, n])
								self.point_grid[0][j] = n
					if g:
						n = float(data[1][i]) / maxv * axis_x
						if not detect_increments or not g_points or \
						   i == vcgt['entryCount'] - 1 or n != i:
							if detect_increments and n != i and \
							   len(g_points) == 1 and i > 1 and \
							   g_points[-1][0] == g_points[-1][1]:
								g_points.append([i - 1, i - 1])
							if xLabel == "L*":
								n = colormath.XYZ2Lab(0, n / axis_x * 100, 0)[0] * (axis_x / 100.0)
							if xLabel in ("L*", "Y"):
								g_points.append([n, j])
								self.point_grid[1][n] = j
							else:
								g_points.append([j, n])
								self.point_grid[1][j] = n
					if b:
						n = float(data[2][i]) / maxv * axis_x
						if not detect_increments or not b_points or \
						   i == vcgt['entryCount'] - 1 or n != i:
							if detect_increments and n != i and \
							   len(b_points) == 1 and i > 1 and \
							   b_points[-1][0] == b_points[-1][1]:
								b_points.append([i - 1, i - 1])
							if xLabel == "L*":
								n = colormath.XYZ2Lab(0, n / axis_x * 100, 0)[0] * (axis_x / 100.0)
							if xLabel in ("L*", "Y"):
								b_points.append([n, j])
								self.point_grid[2][n] = j
							else:
								b_points.append([j, n])
								self.point_grid[2][j] = n
		else: # formula
			irange = range(0, 256)
			step = 100.0 / axis_y
			r_points = []
			g_points = []
			b_points = []
			for i in irange:
				# float2dec(v) fixes miniscule deviations in the calculated gamma
				# n = float2dec(n, 8)
				if not detect_increments:
					linear_points.append([i, (i)])
				if r:
					vmin = float2dec(vcgt["redMin"] * axis_x)
					v = float2dec(math.pow(step * i / 100.0, vcgt["redGamma"]))
					vmax = float2dec(vcgt["redMax"] * axis_x)
					n = vmin + v * (vmax - vmin)
					if xLabel == "L*":
						n = colormath.XYZ2Lab(0, float(n) / axis_x * 100, 0)[0] * (axis_x / 100.0)
					if xLabel in ("L*", "Y"):
						r_points.append([n, i])
						self.point_grid[0][n] = i
					else:
						r_points.append([i, n])
						self.point_grid[0][i] = n
				if g:
					vmin = float2dec(vcgt["greenMin"] * axis_x)
					v = float2dec(math.pow(step * i / 100.0, vcgt["greenGamma"]))
					vmax = float2dec(vcgt["greenMax"] * axis_x)
					n = vmin + v * (vmax - vmin)
					if xLabel == "L*":
						n = colormath.XYZ2Lab(0, float(n) / axis_x * 100, 0)[0] * (axis_x / 100.0)
					if xLabel in ("L*", "Y"):
						g_points.append([n, i])
						self.point_grid[1][n] = i
					else:
						g_points.append([i, n])
						self.point_grid[1][i] = n
				if b:
					vmin = float2dec(vcgt["blueMin"] * axis_x)
					v = float2dec(math.pow(step * i / 100.0, vcgt["blueGamma"]))
					vmax = float2dec(vcgt["blueMax"] * axis_x)
					n = vmin + v * (vmax - vmin)
					if xLabel == "L*":
						n = colormath.XYZ2Lab(0, float(n) / axis_x * 100, 0)[0] * (axis_x / 100.0)
					if xLabel in ("L*", "Y"):
						b_points.append([n, i])
						self.point_grid[2][n] = i
					else:
						b_points.append([i, n])
						self.point_grid[2][i] = n

		#for n in sorted(self.point_grid[0].keys()):
			#print n, self.point_grid[0].get(n), self.point_grid[1].get(n), self.point_grid[2].get(n)

		self.entryCount = irange[-1] + 1
		
		linear = [[0, 0], [irange[-1], irange[-1]]]
		
		if not vcgt:
			if detect_increments:
				r_points = g_points = b_points = linear
			else:
				r_points = g_points = b_points = linear_points
		
		# Note: We need to make sure each point is a float because it
		# might be a decimal.Decimal, which can't be divided by floats!
		self.r_unique = len(set(round(float(y) / axis_y * irange[-1])
								for x, y in r_points))
		self.g_unique = len(set(round(float(y) / axis_y * irange[-1])
								for x, y in g_points))
		self.b_unique = len(set(round(float(y) / axis_y * irange[-1])
								for x, y in b_points))

		legend = []
		colour = None
		if r and g and b and r_points == g_points == b_points:
			colour = 'white'
			points = r_points
			legend.append('R')
			legend.append('G')
			legend.append('B')
		elif r and g and r_points == g_points:
			colour = 'yellow'
			points = r_points
			legend.append('R')
			legend.append('G')
		elif r and b and r_points == b_points:
			colour = 'magenta'
			points = b_points
			legend.append('R')
			legend.append('B')
		elif g and b and g_points == b_points:
			colour = 'cyan'
			points = b_points
			legend.append('G')
			legend.append('B')
		else:
			if r:
				legend.append('R')
			if g:
				legend.append('G')
			if b:
				legend.append('B')
		linear_points = [(i, int(round(v / axis_y * maxv))) for i, v in
						 linear_points]
		if colour and points:
			# Note: We need to make sure each point is a float because it
			# might be a decimal.Decimal, which can't be divided by floats!
			points_quantized = [(i, int(round(float(v) / axis_y * maxv))) for i, v in
								points]
			suffix = ((', ' + lang.getstr('linear').capitalize()) if 
						points_quantized == (linear if detect_increments 
											 else linear_points) else '')
			lines.append(Plot(points, legend='='.join(legend) + suffix, 
							  colour=colour))
		if colour != 'white':
			if r and colour not in ('yellow', 'magenta'):
				# Note: We need to make sure each point is a float because it
				# might be a decimal.Decimal, which can't be divided by floats!
				points_quantized = [(i, int(round(float(v) / axis_y * maxv)))
									for i, v in r_points]
				suffix = ((', ' + lang.getstr('linear').capitalize()) if 
							points_quantized == (linear if detect_increments 
												 else linear_points) else '')
				lines.append(Plot(r_points, legend='R' + suffix, colour='red'))
			if g and colour not in ('yellow', 'cyan'):
				# Note: We need to make sure each point is a float because
				# it might be a decimal.Decimal, which can't be divided by floats!
				points_quantized = [(i, int(round(float(v) / axis_y * maxv)))
									for i, v in g_points]
				suffix = ((', ' + lang.getstr('linear').capitalize()) if 
							points_quantized == (linear if detect_increments 
												 else linear_points) else '')
				lines.append(Plot(g_points, legend='G' + suffix, colour='green'))
			if b and colour not in ('cyan', 'magenta'):
				# Note: We need to make sure each point is a float because
				# it might be a decimal.Decimal, which can't be divided by floats!
				points_quantized = [(i, int(round(float(v) / axis_y * maxv)))
									for i, v in b_points]
				suffix = ((', ' + lang.getstr('linear').capitalize()) if 
							points_quantized == (linear if detect_increments 
												 else linear_points) else '')
				lines.append(Plot(b_points, legend='B' + suffix, colour='#0080FF'))

		self._DrawCanvas(plot.PlotGraphics(lines, title,
										   " ".join([xLabel,
													 lang.getstr("in")]), 
										   " ".join([yLabel,
													 lang.getstr("out")])))

	def DrawPointLabel(self, dc, mDataDict):
		"""
		Draw point labels.
		
		dc - DC that will be passed
		mDataDict - Dictionary of data that you want to use for the pointLabel
		
		"""
		if not self.last_draw:
			return
		graphics, xAxis, yAxis= self.last_draw
		# sizes axis to axis type, create lower left and upper right corners of plot
		if xAxis is None or yAxis is None:
			# One or both axis not specified in Draw
			p1, p2 = graphics.boundingBox()     # min, max points of graphics
			if xAxis is None:
				xAxis = self._axisInterval(self._xSpec, p1[0], p2[0]) # in user units
			if yAxis is None:
				yAxis = self._axisInterval(self._ySpec, p1[1], p2[1])
			# Adjust bounding box for axis spec
			p1[0],p1[1] = xAxis[0], yAxis[0]     # lower left corner user scale (xmin,ymin)
			p2[0],p2[1] = xAxis[1], yAxis[1]     # upper right corner user scale (xmax,ymax)
		else:
			# Both axis specified in Draw
			p1= plot._Numeric.array([xAxis[0], yAxis[0]])    # lower left corner user scale (xmin,ymin)
			p2= plot._Numeric.array([xAxis[1], yAxis[1]])     # upper right corner user scale (xmax,ymax)
		ptx,pty,rectWidth,rectHeight= self._point2ClientCoord(p1, p2)
		# allow graph to overlap axis lines by adding units to width and height
		dc.SetClippingRegion(ptx,pty,rectWidth+2,rectHeight+2)

		dc.SetPen(wx.Pen(wx.WHITE, 1, wx.DOT))
		dc.SetBrush(wx.Brush( wx.WHITE, wx.SOLID ) )
		
		sx, sy = mDataDict["scaledXY"]  # Scaled x, y of closest point
		dc.DrawLine(0, sy, ptx+rectWidth+2, sy)
		dc.DrawLine(sx, 0, sx, pty+rectHeight+2)

	def GetClosestPoints(self, pntXY, pointScaled= True):
		"""Returns list with
			[curveNumber, legend, index of closest point, pointXY, scaledXY, distance]
			list for each curve.
			Returns [] if no curves are being plotted.
			
			x, y in user coords
			if pointScaled == True based on screen coords
			if pointScaled == False based on user coords
		"""
		if self.last_draw is None:
			#no graph available
			return []
		graphics, xAxis, yAxis= self.last_draw
		l = []
		for curveNum,obj in enumerate(graphics):
			#check there are points in the curve
			if len(obj.points) == 0 or isinstance(obj, PolyBox):
				continue  #go to next obj
			#[curveNumber, legend, index of closest point, pointXY, scaledXY, distance]
			cn = [curveNum]+ [obj.getLegend()]+ obj.getClosestPoint( pntXY, pointScaled)
			l.append(cn)
		return l

	def _disabledoublebuffer(self, event):
		window = self
		while window:
			if not isinstance(window,  wx.TopLevelWindow):
				window.SetDoubleBuffered(False)
			window = window.Parent
		event.Skip()

	def _enabledoublebuffer(self, event):
		window = self
		while window:
			if not isinstance(window,  wx.TopLevelWindow):
				window.SetDoubleBuffered(True)
			window = window.Parent
		event.Skip()

	def OnMouseDoubleClick(self, event):
		if self.last_draw:
			boundingbox = self.last_draw[0].boundingBox()
		else:
			boundingbox = None
		self.resetzoom(boundingbox=boundingbox)
		if self.last_draw:
			self.center()

	def OnMouseLeftDown(self,event):
		self.erase_pointlabel()
		self._zoomCorner1[0], self._zoomCorner1[1]= self._getXY(event)
		self._screenCoordinates = plot._Numeric.array(event.GetPosition())
		if self._dragEnabled:
			self.SetCursor(self.GrabHandCursor)
			self.canvas.CaptureMouse()

	def OnMouseLeftUp(self, event):
		if self._dragEnabled:
			self.SetCursor(self.HandCursor)
			if self.canvas.HasCapture():
				self.canvas.ReleaseMouse()
				self._set_center()
		if hasattr(self.TopLevelParent, "OnMotion"):
			self.TopLevelParent.OnMotion(event)
	
	def _DrawCanvas(self, graphics):
		""" Draw proportionally correct, center and zoom """
		w = float(self.GetSize()[0] or 1)
		h = float(self.GetSize()[1] or 1)
		if w > 45:
			w -= 45
		if h > 20:
			h -= 20
		ratio = [w / h,
				 h / w]
		axis_x, axis_y = self.axis_x, self.axis_y
		spec_x = self.spec_x
		spec_y = self.spec_y
		if self._zoomfactor < 1:
			while spec_x * self._zoomfactor < self.spec_x / 2.0:
				spec_x *= 2
			while spec_y * self._zoomfactor < self.spec_y / 2.0:
				spec_y *= 2
		else:
			while spec_x * self._zoomfactor > self.spec_x * 2:
				spec_x /= 2
			while spec_y * self._zoomfactor > self.spec_y * 2:
				spec_y /= 2
		if self.proportional:
			if ratio[0] > ratio[1]:
				self.SetXSpec(spec_x * self._zoomfactor * ratio[0])
			else:
				self.SetXSpec(spec_x * self._zoomfactor)
			if ratio[0] > 1:
				axis_x=tuple([v * ratio[0] for v in axis_x])
			if ratio[1] > ratio[0]:
				self.SetYSpec(spec_y * self._zoomfactor * ratio[1])
			else:
				self.SetYSpec(spec_y * self._zoomfactor)
			if ratio[1] > 1:
				axis_y=tuple([v * ratio[1] for v in axis_y])
		else:
			self.SetXSpec(spec_x * self._zoomfactor)
			self.SetYSpec(spec_y * self._zoomfactor)
		x, y = self.center_x, self.center_y
		w = (axis_x[1] - axis_x[0]) * self._zoomfactor
		h = (axis_y[1] - axis_y[0]) * self._zoomfactor
		axis_x = (x - w / 2, x + w / 2)
		axis_y = (y - h / 2, y + h / 2)
		self.Draw(graphics, axis_x, axis_y)
	
	def _set_center(self):
		""" Set center position from current X and Y axis """
		if not self.last_draw:
			return
		axis_x = self.GetXCurrentRange()
		axis_y = self.GetYCurrentRange()
		if axis_x[0] < 0:
			if axis_x[1] < 0:
				x = axis_x[0] + (abs(axis_x[0]) - abs(axis_x[1])) / 2.0
			else:
				x = axis_x[0] + (abs(axis_x[1]) + abs(axis_x[0])) / 2.0
		else:
			x = axis_x[0] + (abs(axis_x[1]) - abs(axis_x[0])) / 2.0
		if axis_y[0] < 0:
			if axis_y[1] < 0:
				y = axis_y[0] + (abs(axis_y[0]) - abs(axis_y[1])) / 2.0
			else:
				y = axis_y[0] + (abs(axis_y[1]) + abs(axis_y[0])) / 2.0
		else:
			y = axis_y[0] + (abs(axis_y[1]) - abs(axis_y[0])) / 2.0
		self.center_x, self.center_y = x, y
	
	def center(self, boundingbox=None):
		""" Center the current graphic """
		if boundingbox:
			# Min, max points of graphics
			p1, p2 = boundingbox
			# In user units
			min_x, max_x = self._axisInterval(self._xSpec, p1[0], p2[0])
			min_y, max_y = self._axisInterval(self._ySpec, p1[1], p2[1])
		else:
			min_x, max_x = self.GetXMaxRange()
			min_y, max_y = self.GetYMaxRange()
		self.center_x = 0 + sum((min_x, max_x)) / 2.0
		self.center_y = 0 + sum((min_y, max_y)) / 2.0
		if not boundingbox:
			self.erase_pointlabel()
			self._DrawCanvas(self.last_draw[0])
	
	def erase_pointlabel(self):
		if self.GetEnablePointLabel() and self.last_PointLabel:
			# Erase point label
			self._drawPointLabel(self.last_PointLabel)
			self.last_PointLabel = None

	def resetzoom(self, boundingbox=None):
		self.center_x = 0
		self.center_y = 0
		self._zoomfactor = 1.0
		if boundingbox:
			# Min, max points of graphics
			p1, p2 = boundingbox
			# In user units
			min_x, max_x = self._axisInterval(self._xSpec, p1[0], p2[0])
			min_y, max_y = self._axisInterval(self._ySpec, p1[1], p2[1])
			max_abs_x = abs(min_x) + max_x
			max_abs_y = abs(min_y) + max_y
			max_abs_axis_x = (abs(self.axis_x[0]) + self.axis_x[1])
			max_abs_axis_y = (abs(self.axis_y[0]) + self.axis_y[1])
			w = float(self.GetSize()[0] or 1)
			h = float(self.GetSize()[1] or 1)
			if w > 45:
				w -= 45
			if h > 20:
				h -= 20
			ratio = [w / h,
					 h / w]
			if ratio[0] > 1:
				max_abs_axis_x *= ratio[0]
			if ratio[1] > 1:
				max_abs_axis_y *= ratio[1]
			if max_abs_x / max_abs_y > max_abs_axis_x / max_abs_axis_y:
				self._zoomfactor = max_abs_x / max_abs_axis_x
			else:
				self._zoomfactor = max_abs_y / max_abs_axis_y
	
	def zoom(self, direction=1):
		_zoomfactor = .025 * direction
		if (self._zoomfactor + _zoomfactor > 0 and
			self._zoomfactor + _zoomfactor <= 5):
			self._zoomfactor += _zoomfactor
			self._set_center()
			self.erase_pointlabel()
			self._DrawCanvas(self.last_draw[0])


class LUTFrame(BaseFrame):

	def __init__(self, *args, **kwargs):
	
		if len(args) < 3 and not "title" in kwargs:
			kwargs["title"] = lang.getstr("calibration.lut_viewer.title")
		if not "name" in kwargs:
			kwargs["name"] = "lut_viewer"
		
		BaseFrame.__init__(self, *args, **kwargs)
		
		self.SetIcons(config.get_icon_bundle([256, 48, 32, 16],
											 appname + "-curve-viewer"))
		
		self.profile = None
		self.xLabel = lang.getstr("in")
		self.yLabel = lang.getstr("out")
		
		self.sizer = wx.BoxSizer(wx.VERTICAL)
		self.SetSizer(self.sizer)

		panel = wx_Panel(self)
		panel.SetBackgroundColour(BGCOLOUR)
		self.sizer.Add(panel, flag=wx.EXPAND)
		panel.SetSizer(wx.FlexGridSizer(0, 5, 0, 8))
		panel.Sizer.AddGrowableCol(0)
		panel.Sizer.AddGrowableCol(4)

		panel.Sizer.Add((1,1))
		panel.Sizer.Add((1,12))
		panel.Sizer.Add((1,12))
		panel.Sizer.Add((1,12))
		panel.Sizer.Add((1,1))

		panel.Sizer.Add((1,1))

		self.plot_mode_select = wx.Choice(panel, -1, size=(-1, -1), choices=[])
		panel.Sizer.Add(self.plot_mode_select, flag=wx.ALIGN_CENTER_VERTICAL)
		self.Bind(wx.EVT_CHOICE, self.plot_mode_select_handler,
				  id=self.plot_mode_select.GetId())
		
		self.tooltip_btn = BitmapButton(panel, -1,
										geticon(16, "dialog-information"),
										style=wx.NO_BORDER)
		self.tooltip_btn.SetBackgroundColour(BGCOLOUR)
		self.tooltip_btn.Bind(wx.EVT_BUTTON, self.tooltip_handler)
		self.tooltip_btn.SetToolTipString(lang.getstr("gamut_plot.tooltip"))
		panel.Sizer.Add(self.tooltip_btn, flag=wx.ALIGN_CENTER_VERTICAL)

		self.save_plot_btn = BitmapButton(panel, -1,
										  geticon(16, "camera-photo"),
										  style=wx.NO_BORDER)
		self.save_plot_btn.SetBackgroundColour(BGCOLOUR)
		panel.Sizer.Add(self.save_plot_btn, flag=wx.ALIGN_CENTER_VERTICAL)
		self.save_plot_btn.Bind(wx.EVT_BUTTON, self.SaveFile)
		self.save_plot_btn.SetToolTipString(lang.getstr("save_as") + " " +
											"(*.bmp, *.xbm, *.xpm, *.jpg, *.png)")
		self.save_plot_btn.Disable()

		panel.Sizer.Add((1,1))

		panel.Sizer.Add((1,1))
		panel.Sizer.Add((1,4))
		panel.Sizer.Add((1,4))
		panel.Sizer.Add((1,4))
		panel.Sizer.Add((1,1))
		
		self.client = LUTCanvas(self)
		self.sizer.Add(self.client, 1, wx.EXPAND)
		
		self.box_panel = wx_Panel(self)
		self.box_panel.SetBackgroundColour(BGCOLOUR)
		self.sizer.Add(self.box_panel, flag=wx.EXPAND)
		
		self.status = BitmapBackgroundPanelText(self, name="statuspanel")
		self.status.SetMaxFontSize(11)
		self.status.label_y = 8
		self.status.textshadow = False
		self.status.SetBackgroundColour(BGCOLOUR)
		self.status.SetForegroundColour(FGCOLOUR)
		h = self.status.GetTextExtent("Ig")[1]
		self.status.SetMinSize((0, h * 2 + 18))
		self.sizer.Add(self.status, flag=wx.EXPAND)
		
		self.box_sizer = wx.FlexGridSizer(0, 3, 4, 4)
		self.box_sizer.AddGrowableCol(0)
		self.box_sizer.AddGrowableCol(2)
		self.box_panel.SetSizer(self.box_sizer)

		self.box_sizer.Add((0, 0))

		hsizer = wx.BoxSizer(wx.HORIZONTAL)
				  
		self.box_sizer.Add(hsizer,
						   flag=wx.ALIGN_CENTER | wx.BOTTOM | wx.TOP, border=4)

		self.rendering_intent_select = wx.Choice(self.box_panel, -1,
												 choices=[lang.getstr("gamap.intents.a"),
														  lang.getstr("gamap.intents.r"),
														  lang.getstr("gamap.intents.p"),
														  lang.getstr("gamap.intents.s")])
		hsizer.Add((10, self.rendering_intent_select.Size[1]))
		hsizer.Add(self.rendering_intent_select, flag=wx.ALIGN_CENTER_VERTICAL)
		self.rendering_intent_select.Bind(wx.EVT_CHOICE,
										  self.rendering_intent_select_handler)
		self.rendering_intent_select.SetSelection(1)
		
		self.direction_select = wx.Choice(self.box_panel, -1,
										  choices=[lang.getstr("direction.backward"),
												   lang.getstr("direction.forward.inverted")])
		hsizer.Add(self.direction_select, flag=wx.ALIGN_CENTER_VERTICAL | wx.LEFT,
				   border=10)
		self.direction_select.Bind(wx.EVT_CHOICE, self.direction_select_handler)
		self.direction_select.SetSelection(0)

		self.show_actual_lut_cb = CustomCheckBox(self.box_panel, -1,
											  lang.getstr("calibration.show_actual_lut"))
		self.show_actual_lut_cb.SetForegroundColour(FGCOLOUR)
		self.show_actual_lut_cb.SetMaxFontSize(11)
		hsizer.Add(self.show_actual_lut_cb, flag=wx.ALIGN_CENTER |
												 wx.ALIGN_CENTER_VERTICAL)
		self.show_actual_lut_cb.Bind(wx.EVT_CHECKBOX,
									 self.show_actual_lut_handler)

		self.box_sizer.Add((0, 0))
		
		self.box_sizer.Add((0, 0))
		
		self.cbox_sizer = wx.BoxSizer(wx.HORIZONTAL)
		self.box_sizer.Add(self.cbox_sizer, 
						   flag=wx.ALIGN_CENTER | wx.ALIGN_CENTER_VERTICAL |
								wx.TOP, border=4)
		
		self.box_sizer.Add((0, 0))
		
		self.cbox_sizer.Add((10, 0))

		self.reload_vcgt_btn = BitmapButton(self.box_panel, -1,
											geticon(16, "stock_refresh"),
											style=wx.NO_BORDER)
		self.reload_vcgt_btn.SetBackgroundColour(BGCOLOUR)
		self.cbox_sizer.Add(self.reload_vcgt_btn, flag=wx.ALIGN_CENTER_VERTICAL |
													   wx.RIGHT, border=8)
		self.reload_vcgt_btn.Bind(wx.EVT_BUTTON, self.reload_vcgt_handler)
		self.reload_vcgt_btn.SetToolTipString(
			lang.getstr("calibration.load_from_display_profile"))
		self.reload_vcgt_btn.Disable()
		
		self.apply_bpc_btn = BitmapButton(self.box_panel, -1,
										  geticon(16, "black_point"),
										  style=wx.NO_BORDER)
		self.apply_bpc_btn.SetBackgroundColour(BGCOLOUR)
		self.cbox_sizer.Add(self.apply_bpc_btn, flag=wx.ALIGN_CENTER_VERTICAL |
													 wx.RIGHT, border=8)
		self.apply_bpc_btn.Bind(wx.EVT_BUTTON, self.apply_bpc_handler)
		self.apply_bpc_btn.SetToolTipString(lang.getstr("black_point_compensation"))
		self.apply_bpc_btn.Disable()

		self.install_vcgt_btn = BitmapButton(self.box_panel, -1,
											 geticon(16, "install"),
											 style=wx.NO_BORDER)
		self.install_vcgt_btn.SetBackgroundColour(BGCOLOUR)
		self.cbox_sizer.Add(self.install_vcgt_btn,
							flag=wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, border=8)
		self.install_vcgt_btn.Bind(wx.EVT_BUTTON, self.install_vcgt_handler)
		self.install_vcgt_btn.SetToolTipString(lang.getstr("apply_cal"))
		self.install_vcgt_btn.Disable()

		self.save_vcgt_btn = BitmapButton(self.box_panel, -1,
										  geticon(16, "media-floppy"),
										  style=wx.NO_BORDER)
		self.save_vcgt_btn.SetBackgroundColour(BGCOLOUR)
		self.cbox_sizer.Add(self.save_vcgt_btn, flag=wx.ALIGN_CENTER_VERTICAL |
													 wx.RIGHT, border=20)
		self.save_vcgt_btn.Bind(wx.EVT_BUTTON, self.SaveFile)
		self.save_vcgt_btn.SetToolTipString(lang.getstr("save_as") + " " +
											"(*.cal)")
		self.save_vcgt_btn.Disable()
		
		self.show_as_L = CustomCheckBox(self.box_panel, -1, u"L* \u2192")
		self.show_as_L.SetForegroundColour(FGCOLOUR)
		self.show_as_L.SetMaxFontSize(11)
		self.show_as_L.SetValue(True)
		self.cbox_sizer.Add(self.show_as_L, flag=wx.ALIGN_CENTER_VERTICAL |
												 wx.RIGHT,
							border=4)
		self.show_as_L.Bind(wx.EVT_CHECKBOX, self.DrawLUT)
		
		self.toggle_red = CustomCheckBox(self.box_panel, -1, "R")
		self.toggle_red.SetForegroundColour(FGCOLOUR)
		self.toggle_red.SetMaxFontSize(11)
		self.toggle_red.SetValue(True)
		self.cbox_sizer.Add(self.toggle_red, flag=wx.ALIGN_CENTER_VERTICAL)
		self.toggle_red.Bind(wx.EVT_CHECKBOX, self.DrawLUT)
		
		self.cbox_sizer.Add((4, 0))
		
		self.toggle_green = CustomCheckBox(self.box_panel, -1, "G")
		self.toggle_green.SetForegroundColour(FGCOLOUR)
		self.toggle_green.SetMaxFontSize(11)
		self.toggle_green.SetValue(True)
		self.cbox_sizer.Add(self.toggle_green, flag=wx.ALIGN_CENTER_VERTICAL)
		self.toggle_green.Bind(wx.EVT_CHECKBOX, self.DrawLUT)
		
		self.cbox_sizer.Add((4, 0))
		
		self.toggle_blue = CustomCheckBox(self.box_panel, -1, "B")
		self.toggle_blue.SetForegroundColour(FGCOLOUR)
		self.toggle_blue.SetMaxFontSize(11)
		self.toggle_blue.SetValue(True)
		self.cbox_sizer.Add(self.toggle_blue, flag=wx.ALIGN_CENTER_VERTICAL)
		self.toggle_blue.Bind(wx.EVT_CHECKBOX, self.DrawLUT)
		
		self.toggle_clut = CustomCheckBox(self.box_panel, -1, "LUT")
		self.toggle_clut.SetForegroundColour(FGCOLOUR)
		self.toggle_clut.SetMaxFontSize(11)
		self.cbox_sizer.Add(self.toggle_clut, flag=wx.ALIGN_CENTER_VERTICAL |
												   wx.LEFT, border=16)
		self.toggle_clut.Bind(wx.EVT_CHECKBOX, self.toggle_clut_handler)

		self.client.canvas.Bind(wx.EVT_MOTION, self.OnMotion)
		
		self.droptarget = FileDrop(self)
		self.droptarget.drophandlers = {
			".cal": self.drop_handler,
			".icc": self.drop_handler,
			".icm": self.drop_handler
		}
		self.client.SetDropTarget(self.droptarget)
		
		border, titlebar = get_platform_window_decoration_size()
		self.MinSize = (config.defaults["size.lut_viewer.w"] + border * 2,
						config.defaults["size.lut_viewer.h"] + titlebar + border)
		self.SetSaneGeometry(
			getcfg("position.lut_viewer.x"), 
			getcfg("position.lut_viewer.y"), 
			getcfg("size.lut_viewer.w") + border * 2, 
			getcfg("size.lut_viewer.h") + titlebar + border)
		
		self.Bind(wx.EVT_MOVE, self.OnMove)
		self.Bind(wx.EVT_SIZE, self.OnSize)

		children = self.GetAllChildren()

		self.Bind(wx.EVT_KEY_DOWN, self.key_handler)
		for child in children:
			if isinstance(child, wx.Choice):
				child.SetMaxFontSize(11)
			child.Bind(wx.EVT_KEY_DOWN, self.key_handler)
			child.Bind(wx.EVT_MOUSEWHEEL, self.OnWheel)
			if (sys.platform == "win32" and sys.getwindowsversion() >= (6, ) and
				isinstance(child, wx.Panel)):
				# No need to enable double buffering under Linux and Mac OS X.
				# Under Windows, enabling double buffering on the panel seems
				# to work best to reduce flicker.
				child.SetDoubleBuffered(True)
		
		self.display_no = -1
		self.display_rects = get_display_rects()
	
	def apply_bpc_handler(self, event):
		cal = vcgt_to_cal(self.profile)
		cal.filename = self.profile.fileName or ""
		cal.apply_bpc(weight=True)
		self.LoadProfile(cal_to_fake_profile(cal))

	def drop_handler(self, path):
		"""
		Drag'n'drop handler for .cal/.icc/.icm files.
		
		"""
		filename, ext = os.path.splitext(path)
		if ext.lower() not in (".icc", ".icm"):
			profile = cal_to_fake_profile(path)
			if not profile:
				InfoDialog(self, msg=lang.getstr("error.file.open", path), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				profile = None
		else:
			try:
				profile = ICCP.ICCProfile(path)
			except (IOError, ICCP.ICCProfileInvalidError), exception:
				InfoDialog(self, msg=lang.getstr("profile.invalid") + 
									 "\n" + path, 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
				profile = None
		self.show_actual_lut_cb.SetValue(False)
		self.current_cal = profile
		self.LoadProfile(profile)
	
	get_display = MeasureFrame.__dict__["get_display"]
	
	def handle_errors(self):
		if self.client.errors:
			show_result_dialog(Error("\n\n".join(set(safe_unicode(error)
													 for error in
													 self.client.errors))),
							   self)
			self.client.errors = []
	
	def install_vcgt_handler(self, event):
		cwd = self.worker.create_tempdir()
		if isinstance(cwd, Exception):
			show_result_dialog(cwd, self)
		else:
			cal = os.path.join(cwd, re.sub(r"[\\/:*?\"<>|]+",
										   "",
										   make_argyll_compatible_path(
											   self.profile.getDescription() or 
											   "Video LUT")))
			vcgt_to_cal(self.profile).write(cal)
			cmd, args = self.worker.prepare_dispwin(cal)
			if isinstance(cmd, Exception):
				show_result_dialog(cmd, self)
			elif cmd:
				result = self.worker.exec_cmd(cmd, args, capture_output=True, 
											  skip_scripts=True)
				if isinstance(result, Exception):
					show_result_dialog(result, self)
				elif not result:
					show_result_dialog(Error("".join(self.worker.errors)),
									   self)
			# Important:
			# Make sure to only delete the temporary cal file we created
			try:
				os.remove(cal)
			except Exception, exception:
				safe_print(u"Warning - temporary file "
						   u"'%s' could not be removed: %s" % 
						   tuple(safe_unicode(s) for s in 
								 (cal, exception)))

	def key_handler(self, event):
		# AltDown
		# CmdDown
		# ControlDown
		# GetKeyCode
		# GetModifiers
		# GetPosition
		# GetRawKeyCode
		# GetRawKeyFlags
		# GetUniChar
		# GetUnicodeKey
		# GetX
		# GetY
		# HasModifiers
		# KeyCode
		# MetaDown
		# Modifiers
		# Position
		# RawKeyCode
		# RawKeyFlags
		# ShiftDown
		# UnicodeKey
		# X
		# Y
		key = event.GetKeyCode()
		if (event.ControlDown() or event.CmdDown()): # CTRL (Linux/Mac/Windows) / CMD (Mac)
			if key == 83 and self.profile: # S
				self.SaveFile()
				return
			else:
				event.Skip()
		elif key in (43, wx.WXK_NUMPAD_ADD):
			# + key zoom in
			self.client.zoom(-1)
		elif key in (45, wx.WXK_NUMPAD_SUBTRACT):
			# - key zoom out
			self.client.zoom(1)
		else:
			event.Skip()
	
	def direction_select_handler(self, event):
		self.toggle_clut_handler(event)

	def rendering_intent_select_handler(self, event):
		self.toggle_clut_handler(event)
	
	def toggle_clut_handler(self, event):
		try:
			self.lookup_tone_response_curves()
		except Exception, exception:
			show_result_dialog(exception, self)
		else:
			self.trc = None
			self.DrawLUT()
			self.handle_errors()

	def tooltip_handler(self, event):
		if not hasattr(self, "tooltip_window"):
			self.tooltip_window = TooltipWindow(self,
												msg=event.EventObject.ToolTip.Tip,
												title=event.EventObject.TopLevelParent.Title,
												bitmap=geticon(32, "dialog-information"))
		else:
			self.tooltip_window.Show()
			self.tooltip_window.Raise()

	def show_actual_lut_handler(self, event):
		setcfg("lut_viewer.show_actual_lut", 
			   int(self.show_actual_lut_cb.GetValue()))
		if hasattr(self, "current_cal"):
			profile = self.current_cal
		else:
			profile = None
		self.load_lut(profile=profile)
	
	def load_lut(self, profile=None):
		self.current_cal = profile
		if (getcfg("lut_viewer.show_actual_lut") and
			(self.worker.argyll_version[0:3] > [1, 1, 0] or
			 (self.worker.argyll_version[0:3] == [1, 1, 0] and
			  not "Beta" in self.worker.argyll_version_string)) and
			not config.is_untethered_display()):
			tmp = self.worker.create_tempdir()
			if isinstance(tmp, Exception):
				show_result_dialog(tmp, self)
				return
			outfilename = os.path.join(tmp, 
									   re.sub(r"[\\/:*?\"<>|]+",
											  "",
											  make_argyll_compatible_path(
												config.get_display_name(
													include_geometry=True) or 
												"Video LUT")))
			result = self.worker.save_current_video_lut(self.worker.get_display(),
														outfilename,
														silent=not __name__ == "__main__")
			if not isinstance(result, Exception) and result:
				profile = cal_to_fake_profile(outfilename)
			else:
				if isinstance(result, Exception):
					safe_print(result)
			# Important: lut_viewer_load_lut is called after measurements,
			# so make sure to only delete the temporary cal file we created
			try:
				os.remove(outfilename)
			except Exception, exception:
				safe_print(u"Warning - temporary file "
						   u"'%s' could not be removed: %s" % 
						   tuple(safe_unicode(s) for s in 
								 (outfilename, exception)))
		if profile and (profile.is_loaded or not profile.fileName or 
						os.path.isfile(profile.fileName)):
			if not self.profile or \
			   self.profile.fileName != profile.fileName or \
			   not self.profile.isSame(profile):
				self.LoadProfile(profile)
		else:
			self.LoadProfile(None)
	
	def lookup_tone_response_curves(self, intent="r"):
		""" Lookup Y -> RGB tone values through TRC tags or LUT """
		
		mult = 2
		size = 256 * mult  # Final number of coordinates

		if hasattr(self, "rendering_intent_select"):
			intent = {0: "a",
					  1: "r",
					  2: "p",
					  3: "s"}.get(self.rendering_intent_select.GetSelection())

		use_trc_tags = (intent == "r" and (not ("B2A0" in self.profile.tags or
												"A2B0" in self.profile.tags) or
										   not self.toggle_clut.GetValue()) and
						isinstance(self.rTRC, ICCP.CurveType) and
						isinstance(self.gTRC, ICCP.CurveType) and
						isinstance(self.bTRC, ICCP.CurveType) and
						len(self.rTRC) ==
						len(self.gTRC) ==
						len(self.bTRC))
		has_same_trc = self.rTRC == self.gTRC == self.bTRC

		profile = self.profile

		if profile.version >= 4:
			self.client.errors.append(Error("\n".join([lang.getstr("profile.iccv4.unsupported"),
													   profile.getDescription()])))
			return

		if (profile.colorSpace not in ("RGB", "GRAY") or
			profile.connectionColorSpace not in ("Lab", "XYZ")):
			if profile.colorSpace not in ("RGB", "GRAY"):
				unsupported_colorspace = profile.colorSpace
			else:
				unsupported_colorspace = profile.connectionColorSpace
			self.client.errors.append(Error(lang.getstr("profile.unsupported",
														(profile.profileClass,
														 unsupported_colorspace))))
			return
		
		if profile.colorSpace == "GRAY":
			direction = "b"
		elif "B2A0" in profile.tags:
			direction = {0: "b",
						 1: "if",
						 2: "f",
						 3: "ib"}.get(self.direction_select.GetSelection())
		else:
			direction = "if"
		
		# Prepare input Lab values
		XYZ_triplets = []
		Lab_triplets = []
		RGB_triplets = []
		for i in xrange(0, size):
			if direction in ("b", "if"):
				##if intent == "a":
					### Experimental - basically this makes the resulting
					### response match relative colorimetric
					##X, Y, Z = colormath.Lab2XYZ(i * (100.0 / (size - 1)), 0, 0)
					##L, a, b = colormath.XYZ2Lab(*[v * 100 for v in
												  ##colormath.adapt(X, Y, Z,
																  ##whitepoint_destination=profile.tags.wtpt.values())])
				##else:
				a = b = 0
				Lab_triplets.append([i * (100.0 / (size - 1)), a, b])
			else:
				RGB_triplets.append([i * (1.0 / (size - 1))] * 3)
		if profile.colorSpace == "GRAY":
			use_icclu = True
			pcs = "x"
			for Lab in Lab_triplets:
				XYZ_triplets.append(colormath.Lab2XYZ(*Lab))
		else:
			use_icclu = False
			pcs = "l"
		if direction in ("b", "if"):
			if pcs == "l":
				idata = Lab_triplets
			else:
				idata = XYZ_triplets
		else:
			idata = RGB_triplets
		
		order = {True: "n",
				 False: "r"}.get(("B2A0" in self.profile.tags or
								  "A2B0" in self.profile.tags) and
								 self.toggle_clut.GetValue())

		# Lookup values through 'input' profile using xicclu
		try:
			odata = self.worker.xicclu(profile, idata, intent,
									   direction, order, pcs,
									   use_icclu=use_icclu)
		except Exception, exception:
			self.client.errors.append(Error(safe_unicode(exception)))
		
		if self.client.errors:
			return

		if direction in ("b", "if"):
			RGB_triplets = odata
		else:
			Lab_triplets = odata

		self.rTRC = CoordinateType(self.profile)
		self.gTRC = CoordinateType(self.profile)
		self.bTRC = CoordinateType(self.profile)
		for j, RGB in enumerate(RGB_triplets):
			for i, v in enumerate(RGB):
				v = min(v, 1.0)
				if (not v and j < len(RGB_triplets) - 1 and
					not min(RGB_triplets[j + 1][i], 1.0)):
					continue
				v *= 255
				X, Y, Z = colormath.Lab2XYZ(*Lab_triplets[j], **{"scale": 100})
				if direction in ("b", "if"):
					X = Z = Y
				elif intent == "a":
					wp = profile.tags.wtpt.ir.values()
					X, Y, Z = colormath.adapt(X, Y, Z, wp, (1, 1, 1))
				if i == 0:
					self.rTRC.append([X, v])
				elif i == 1:
					self.gTRC.append([Y, v])
				elif i == 2:
					self.bTRC.append([Z, v])
		if use_trc_tags:
			if has_same_trc:
				self.bTRC = self.gTRC = self.rTRC
			return
		# Generate interpolated TRCs for transfer function detection
		for sig in ("rTRC", "gTRC", "bTRC"):
			x, xp, y, yp = [], [], [], []
			# First, get actual values
			for i, (Y, v) in enumerate(getattr(self, sig)):
				##if not i or Y >= trc[sig][i - 1]:
				xp.append(v)
				yp.append(Y)
			# Second, interpolate to given size and use the same y axis 
			# for all channels
			for i in xrange(size):
				x.append(i / (size - 1.0) * 255)
				y.append(colormath.Lab2XYZ(i / (size - 1.0) * 100, 0, 0)[1] * 100)
			xi = interp(y, yp, xp)
			yi = interp(x, xi, y)
			setattr(self, "tf_" + sig, CoordinateType(self.profile))
			for Y, v in zip(yi, x):
				if Y <= yp[0]:
					Y = yp[0]
				getattr(self, "tf_" + sig).append([Y, v])

	def move_handler(self, event):
		if not self.IsShownOnScreen():
			return
		display_no, geometry, client_area = self.get_display()
		if display_no != self.display_no:
			self.display_no = display_no
			# Translate from wx display index to Argyll display index
			n = get_argyll_display_number(geometry)
			if n is not None:
				# Save Argyll display index to configuration
				setcfg("display.number", n + 1)
				# Load profile
				self.load_lut(get_display_profile(n))
		event.Skip()
	
	def plot_mode_select_handler(self, event):
		self.client.resetzoom()
		self.DrawLUT()
		wx.CallAfter(self.client.center)

	def get_commands(self):
		return self.get_common_commands() + ["curve-viewer [filename]",
											 "load <filename>"]

	def process_data(self, data):
		if (data[0] == "curve-viewer" and
			len(data) < 3) or (data[0] == "load" and len(data) == 2):
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
			return "ok"
		return "invalid"
	
	def reload_vcgt_handler(self, event):
		cmd, args = self.worker.prepare_dispwin(True)
		if isinstance(cmd, Exception):
			show_result_dialog(cmd, self)
		elif cmd:
			result = self.worker.exec_cmd(cmd, args, capture_output=True, 
										  skip_scripts=True)
			if isinstance(result, Exception):
				show_result_dialog(result, self)
			elif not result:
				show_result_dialog(UnloggedError("".join(self.worker.errors)),
								   self)
			else:
				self.load_lut(get_display_profile())

	def LoadProfile(self, profile):
		if profile and not isinstance(profile, ICCP.ICCProfile):
			try:
				profile = ICCP.ICCProfile(profile)
			except (IOError, ICCP.ICCProfileInvalidError), exception:
				show_result_dialog(Error(lang.getstr("profile.invalid") + 
										 "\n" + profile), self)
				profile = None
		if not profile:
			profile = ICCP.ICCProfile()
			profile._data = "\0" * 128
			profile._tags.desc = ICCP.TextDescriptionType("", "desc")
			profile.size = len(profile.data)
			profile.is_loaded = True
		if profile.getDescription():
			title = u" \u2014 ".join([lang.getstr("calibration.lut_viewer.title"),
									  profile.getDescription()])
		else:
			title = lang.getstr("calibration.lut_viewer.title")
		self.SetTitle(title)
		self.profile = profile
		self.rTRC = self.tf_rTRC = profile.tags.get("rTRC",
													profile.tags.get("kTRC"))
		self.gTRC = self.tf_gTRC = profile.tags.get("gTRC",
													profile.tags.get("kTRC"))
		self.bTRC = self.tf_bTRC = profile.tags.get("bTRC",
													profile.tags.get("kTRC"))
		self.trc = None
		curves = []
		curves.append(lang.getstr('vcgt'))
		self.client.errors = []
		self.toggle_clut.SetValue("B2A0" in profile.tags or
								  "A2B0" in profile.tags)
		if ((self.rTRC and self.gTRC and self.bTRC) or
			(self.toggle_clut.GetValue() and
			 profile.colorSpace in ("RGB", "GRAY"))):
			try:
				self.lookup_tone_response_curves()
			except Exception, exception:
				wx.CallAfter(show_result_dialog, exception, self)
			else:
				curves.append(lang.getstr('[rgb]TRC'))
		selection = self.plot_mode_select.GetSelection()
		center = False
		if curves and (selection < 0 or selection > len(curves) - 1):
			selection = 0
			center = True
		self.plot_mode_select.SetItems(curves)
		self.plot_mode_select.Enable(len(curves) > 1)
		self.plot_mode_select.SetSelection(selection)
		self.cbox_sizer.Layout()
		self.box_sizer.Layout()
		self.DrawLUT()
		if center:
			wx.CallAfter(self.client.center)
		wx.CallAfter(self.handle_errors)

	def add_tone_values(self, legend):
		if not self.profile:
			return
		colorants = legend[0]
		if (self.plot_mode_select.GetSelection() == 0 and
			'vcgt' in self.profile.tags):
			if 'R' in colorants or 'G' in colorants or 'B' in colorants:
				legend.append(lang.getstr("tone_values"))
				if '=' in colorants:
					unique = []
					if 'R' in colorants:
						unique.append(self.client.r_unique)
					if 'G' in colorants:
						unique.append(self.client.g_unique)
					if 'B' in colorants:
						unique.append(self.client.b_unique)
					unique = min(unique)
					legend[-1] += " %.1f%% (%i/%i)" % (unique / 
													   (self.client.entryCount / 
														100.0), unique, 
													   self.client.entryCount)
				else:
					if 'R' in colorants:
						legend[-1] += " %.1f%% (%i/%i)" % (self.client.r_unique / 
														   (self.client.entryCount / 
															100.0), 
														   self.client.r_unique, 
														   self.client.entryCount)
					if 'G' in colorants:
						legend[-1] += " %.1f%% (%i/%i)" % (self.client.g_unique / 
														   (self.client.entryCount / 
															100.0), 
														   self.client.g_unique, 
														   self.client.entryCount)
					if 'B' in colorants:
						legend[-1] += " %.1f%% (%i/%i)" % (self.client.b_unique / 
														   (self.client.entryCount / 
															100.0), 
														   self.client.b_unique, 
														   self.client.entryCount)
				unique = []
				unique.append(self.client.r_unique)
				unique.append(self.client.g_unique)
				unique.append(self.client.b_unique)
				if not 0 in unique and not "R=G=B" in colorants:
					unique = min(unique)
					legend[-1] += ", %s %.1f%% (%i/%i)" % (lang.getstr("grayscale"), 
														   unique / 
														   (self.client.entryCount / 
															100.0), unique, 
														   self.client.entryCount)
		elif (self.plot_mode_select.GetSelection() == 1 and
			  isinstance(self.tf_rTRC, (ICCP.CurveType, CoordinateType)) and
			  len(self.tf_rTRC) > 1 and
			  isinstance(self.tf_gTRC, (ICCP.CurveType, CoordinateType)) and
			  len(self.tf_gTRC) > 1 and
			  isinstance(self.tf_bTRC, (ICCP.CurveType, CoordinateType)) and
			  len(self.tf_bTRC) > 1):
			transfer_function = None
			if (not getattr(self, "trc", None) and
				len(self.tf_rTRC) == len(self.tf_gTRC) == len(self.tf_bTRC)):
				if isinstance(self.tf_rTRC, ICCP.CurveType):
					self.trc = ICCP.CurveType(profile=self.profile)
					for i in xrange(len(self.tf_rTRC)):
						self.trc.append((self.tf_rTRC[i] +
										 self.tf_gTRC[i] +
										 self.tf_bTRC[i]) / 3.0)
				else:
					self.trc = CoordinateType(self.profile)
					for i in xrange(len(self.tf_rTRC)):
						self.trc.append([(self.tf_rTRC[i][0] +
										  self.tf_gTRC[i][0] +
										  self.tf_bTRC[i][0]) / 3.0,
										 (self.tf_rTRC[i][1] +
										  self.tf_gTRC[i][1] +
										  self.tf_bTRC[i][1]) / 3.0])
			if getattr(self, "trc", None):
				transfer_function = self.trc.get_transfer_function(slice=(0.00, 1.00))
			#if "R" in colorants and "G" in colorants and "B" in colorants:
				#if self.profile.tags.rTRC == self.profile.tags.gTRC == self.profile.tags.bTRC:
					#transfer_function = self.profile.tags.rTRC.get_transfer_function()
			#elif ("R" in colorants and
				  #(not "G" in colorants or
				   #self.profile.tags.rTRC == self.profile.tags.gTRC) and
				  #(not "B" in colorants or
				   #self.profile.tags.rTRC == self.profile.tags.bTRC)):
				#transfer_function = self.profile.tags.rTRC.get_transfer_function()
			#elif ("G" in colorants and
				  #(not "R" in colorants or
				   #self.profile.tags.gTRC == self.profile.tags.rTRC) and
				  #(not "B" in colorants or
				   #self.profile.tags.gTRC == self.profile.tags.bTRC)):
				#transfer_function = self.profile.tags.gTRC.get_transfer_function()
			#elif ("B" in colorants and
				  #(not "G" in colorants or
				   #self.profile.tags.bTRC == self.profile.tags.gTRC) and
				  #(not "R" in colorants or
				   #self.profile.tags.bTRC == self.profile.tags.rTRC)):
				#transfer_function = self.profile.tags.bTRC.get_transfer_function()
			if transfer_function and transfer_function[1] >= .95:
				if self.tf_rTRC == self.tf_gTRC == self.tf_bTRC:
					label = lang.getstr("rgb.trc")
				else:
					label = lang.getstr("rgb.trc.averaged")
				if round(transfer_function[1], 2) == 1.0:
					value = u"%s" % (transfer_function[0][0])
				else:
					value = u"≈ %s (Δ %.2f%%)" % (transfer_function[0][0],
												  100 - transfer_function[1] * 100)
				legend.append(" ".join([label, value]))

	def DrawLUT(self, event=None):
		self.SetStatusText('')
		self.Freeze()
		curves = None
		if self.profile:
			if self.plot_mode_select.GetSelection() == 0:
				if 'vcgt' in self.profile.tags:
					curves = self.profile.tags['vcgt']
				else:
					curves = None
			elif (self.plot_mode_select.GetSelection() == 1 and
				  isinstance(self.rTRC, (ICCP.CurveType, CoordinateType)) and
				  isinstance(self.gTRC, (ICCP.CurveType, CoordinateType)) and
				  isinstance(self.bTRC, (ICCP.CurveType, CoordinateType))):
				if (len(self.rTRC) == 1 and
					len(self.gTRC) == 1 and
					len(self.bTRC) == 1):
					# gamma
					curves = {
						'redMin': 0.0,
						'redGamma': self.rTRC[0],
						'redMax': 1.0,
						'greenMin': 0.0,
						'greenGamma': self.gTRC[0],
						'greenMax': 1.0,
						'blueMin': 0.0,
						'blueGamma': self.bTRC[0],
						'blueMax': 1.0
					}
				else:
					# curves
					curves = {
						'data': [self.rTRC,
								 self.gTRC,
								 self.bTRC],
						'entryCount': len(self.rTRC),
						'entrySize': 2
					}
		yLabel = []
		if self.toggle_red.GetValue():
			yLabel.append("R")
		if self.toggle_green.GetValue():
			yLabel.append("G")
		if self.toggle_blue.GetValue():
			yLabel.append("B")
		if self.plot_mode_select.GetSelection() == 0:
			self.xLabel = "".join(yLabel)
		else:
			if self.show_as_L.GetValue():
				self.xLabel = "L*"
			else:
				self.xLabel = "Y"
		self.yLabel = "".join(yLabel)
				
		self.toggle_red.Enable(bool(curves))
		self.toggle_green.Enable(bool(curves))
		self.toggle_blue.Enable(bool(curves))
		self.show_as_L.Enable(bool(curves))
		self.show_as_L.Show(self.plot_mode_select.GetSelection() != 0)
		self.toggle_clut.Show(self.plot_mode_select.GetSelection() == 1 and
							  ("B2A0" in self.profile.tags or
							   "A2B0" in self.profile.tags))
		self.toggle_clut.Enable(self.plot_mode_select.GetSelection() == 1 and
								isinstance(self.profile.tags.get("rTRC"),
										   ICCP.CurveType) and
								isinstance(self.profile.tags.get("gTRC"),
										   ICCP.CurveType) and
								isinstance(self.profile.tags.get("bTRC"),
										   ICCP.CurveType))
		self.save_plot_btn.Enable(bool(curves))
		if hasattr(self, "reload_vcgt_btn"):
			self.reload_vcgt_btn.Enable(not(self.plot_mode_select.GetSelection()) and
										bool(self.profile))
			self.reload_vcgt_btn.Show(not(self.plot_mode_select.GetSelection()))
		if hasattr(self, "apply_bpc_btn"):
			enable_bpc = (not(self.plot_mode_select.GetSelection()) and
						  bool(self.profile) and
						  isinstance(self.profile.tags.get("vcgt"),
									 ICCP.VideoCardGammaType))
			if enable_bpc:
				values = self.profile.tags.vcgt.getNormalizedValues()
			self.apply_bpc_btn.Enable(enable_bpc and values[0] != (0, 0, 0))
			self.apply_bpc_btn.Show(not(self.plot_mode_select.GetSelection()))
		if hasattr(self, "install_vcgt_btn"):
			self.install_vcgt_btn.Enable(not(self.plot_mode_select.GetSelection()) and
										 bool(self.profile) and
										 isinstance(self.profile.tags.get("vcgt"),
													ICCP.VideoCardGammaType))
			self.install_vcgt_btn.Show(not(self.plot_mode_select.GetSelection()))
		if hasattr(self, "save_vcgt_btn"):
			self.save_vcgt_btn.Enable(not(self.plot_mode_select.GetSelection()) and
									  bool(self.profile) and
									  isinstance(self.profile.tags.get("vcgt"),
												 ICCP.VideoCardGammaType))
			self.save_vcgt_btn.Show(not(self.plot_mode_select.GetSelection()))
		if hasattr(self, "show_actual_lut_cb"):
			self.show_actual_lut_cb.Show(self.plot_mode_select.GetSelection() == 0)
		if hasattr(self, "rendering_intent_select"):
			self.rendering_intent_select.Show(self.plot_mode_select.GetSelection() == 1)
		if hasattr(self, "direction_select"):
			self.direction_select.Show(self.toggle_clut.IsShown() and
									   self.toggle_clut.GetValue() and
									   "B2A0" in self.profile.tags and
									   "A2B0" in self.profile.tags)
		self.show_as_L.GetContainingSizer().Layout()
		if hasattr(self, "cbox_sizer"):
			self.cbox_sizer.Layout()
		if hasattr(self, "box_sizer"):
			self.box_sizer.Layout()
		if self.client.last_PointLabel != None:
			self.client._drawPointLabel(self.client.last_PointLabel) #erase old
			self.client.last_PointLabel = None
		wx.CallAfter(self.client.DrawLUT, curves,
					 xLabel=self.xLabel,
					 yLabel=self.yLabel,
					 r=self.toggle_red.GetValue() if 
					   hasattr(self, "toggle_red") else False, 
					 g=self.toggle_green.GetValue() if 
					   hasattr(self, "toggle_green") else False, 
					 b=self.toggle_blue.GetValue() if 
					   hasattr(self, "toggle_blue") else False)
		self.Thaw()

	def OnClose(self, event):
		self.listening = False
		if self.worker.tempdir and os.path.isdir(self.worker.tempdir):
			self.worker.wrapup(False)
		config.writecfg(module="curve-viewer", options=("display.number", ))
		event.Skip()

	def OnMotion(self, event):
		if isinstance(event, wx.MouseEvent):
			if not event.LeftIsDown():
				self.UpdatePointLabel(self.client._getXY(event))
			else:
				self.client.erase_pointlabel()
			event.Skip() # Go to next handler

	def OnMove(self, event=None):
		if self.IsShownOnScreen() and not \
		   self.IsMaximized() and not self.IsIconized():
			x, y = self.GetScreenPosition()
			setcfg("position.lut_viewer.x", x)
			setcfg("position.lut_viewer.y", y)
		if event:
			event.Skip()
	
	def OnSize(self, event=None):
		if self.IsShownOnScreen() and not \
		   self.IsMaximized() and not self.IsIconized():
			w, h = self.GetSize()
			border, titlebar = get_platform_window_decoration_size()
			setcfg("size.lut_viewer.w", w - border * 2)
			setcfg("size.lut_viewer.h", h - titlebar - border)
		if event:
			event.Skip()
			if sys.platform == "win32":
				# Needed under Windows when using double buffering
				self.Refresh()
	
	def OnWheel(self, event):
		xy = wx.GetMousePosition()
		if self.client.last_draw:
			if event.WheelRotation < 0:
				direction = 1.0
			else:
				direction = -1.0
			self.client.zoom(direction)

	def SaveFile(self, event=None):
		"""Saves the file to the type specified in the extension. If no file
		name is specified a dialog box is provided.  Returns True if sucessful,
		otherwise False.
		
		.bmp  Save a Windows bitmap file.
		.xbm  Save an X bitmap file.
		.xpm  Save an XPM bitmap file.
		.png  Save a Portable Network Graphics file.
		.jpg  Save a Joint Photographic Experts Group file.
		"""
		fileName = " ".join([self.plot_mode_select.GetStringSelection(),
							 os.path.basename(os.path.splitext(self.profile.fileName or
															   lang.getstr("unnamed"))[0])])
		if (event and hasattr(self, "save_vcgt_btn") and
			event.GetId() == self.save_vcgt_btn.GetId()):
			extensions = {"cal": 1}
			defType = "cal"
		else:
			extensions = {
				"bmp": wx.BITMAP_TYPE_BMP,       # Save a Windows bitmap file.
				"xbm": wx.BITMAP_TYPE_XBM,       # Save an X bitmap file.
				"xpm": wx.BITMAP_TYPE_XPM,       # Save an XPM bitmap file.
				"jpg": wx.BITMAP_TYPE_JPEG,      # Save a JPG file.
				"png": wx.BITMAP_TYPE_PNG,       # Save a PNG file.
				}
			defType = "png"

		fileName += "." + defType

		fType = None
		dlg1 = None
		while fType not in extensions:

			if dlg1:                   # FileDialog exists: Check for extension
				InfoDialog(self,
						   msg=lang.getstr("error.file_type_unsupported"), 
						   ok=lang.getstr("ok"), 
						   bitmap=geticon(32, "dialog-error"))
			else:                      # FileDialog doesn't exist: just check one
				dlg1 = wx.FileDialog(
					self, 
					lang.getstr("save_as"),
					get_verified_path("last_filedialog_path")[0], fileName,
					"|".join(["%s (*.%s)|*.%s" % (ext.upper(), ext, ext)
							  for ext in sorted(extensions.keys())]),
					wx.SAVE|wx.OVERWRITE_PROMPT
					)
				dlg1.SetFilterIndex(sorted(extensions.keys()).index(defType))

			if dlg1.ShowModal() == wx.ID_OK:
				fileName = dlg1.GetPath()
				if not waccess(fileName, os.W_OK):
					show_result_dialog(Error(lang.getstr("error.access_denied.write",
														 fileName)), self)
					return
				fType = fileName[-3:].lower()
				setcfg("last_filedialog_path", fileName)
			else:                      # exit without saving
				dlg1.Destroy()
				return False

		if dlg1:
			dlg1.Destroy()

		# Save Bitmap
		if (event and hasattr(self, "save_vcgt_btn") and
			event.GetId() == self.save_vcgt_btn.GetId()):
			res = vcgt_to_cal(self.profile)
			res.write(fileName)
		else:
			res= self.client._Buffer.SaveFile(fileName, extensions.get(fType, ".png"))
		return res

	def SetStatusText(self, text):
		self.status.Label = text
		self.status.Refresh()
	
	def UpdatePointLabel(self, xy):
		if self.client.GetEnablePointLabel():
			# Show closest point (when enbled)
			# Make up dict with info for the point label
			dlst = self.client.GetClosestPoint(xy, pointScaled=True)
			if dlst != [] and hasattr(self.client, "point_grid"):
				curveNum, legend, pIndex, pointXY, scaledXY, distance = dlst
				legend = legend.split(", ")
				R, G, B = (self.client.point_grid[0].get(pointXY[0],
							0 if self.toggle_red.GetValue() else None),
						   self.client.point_grid[1].get(pointXY[0],
							0 if self.toggle_green.GetValue() else None),
						   self.client.point_grid[2].get(pointXY[0],
							0 if self.toggle_blue.GetValue() else None))
				if (self.plot_mode_select.GetSelection() == 0 or
					R == G == B or ((R == G or G == B or R == B) and
									None in (R, G ,B))):
					rgb = ""
				else:
					rgb = legend[0] + " "
				if self.plot_mode_select.GetSelection() == 1:
					joiner = u" \u2192 "
					if self.show_as_L.GetValue():
						format = "L* %.4f", "%s %.2f"
					else:
						format = "Y %.4f", "%s %.2f"
					axis_y = 100.0
					if R == G == B or ((R == G or G == B or R == B) and
									   None in (R, G ,B)):
						#if R is None:
						RGB = " ".join(["=".join(["%s" % v for v, s in
												  filter(lambda v: v[1] is not None,
														 (("R", R), ("G", G), ("B", B)))]),
										"%.2f" % pointXY[1]])
						#else:
							#RGB = "R=G=B %.2f" % R
					else:
						RGB = " ".join([format[1] % (v, s) for v, s in
										filter(lambda v: v[1] is not None,
											   (("R", R), ("G", G), ("B", B)))])
					legend[0] = joiner.join([format[0] % pointXY[0], RGB])
					pointXY = pointXY[1], pointXY[0]
				else:
					joiner = u" \u2192 "
					format = "%.2f", "%.2f"
					axis_y = 255.0
					legend[0] += " " + joiner.join([format[i] % point
													for i, point in
													enumerate(pointXY)])
				if (len(legend) == 1 and pointXY[0] > 0 and
					pointXY[0] < 255 and pointXY[1] > 0):
					y = pointXY[1]
					if (self.plot_mode_select.GetSelection() == 1 and
						self.show_as_L.GetValue()):
						y = colormath.Lab2XYZ(y, 0, 0)[1] * 100
					legend.append(rgb + "Gamma %.2f" % (math.log(y / axis_y) / math.log(pointXY[0] / 255.0)))
				self.add_tone_values(legend)
				legend = [", ".join(legend[:-1])] + [legend[-1]]
				self.SetStatusText("\n".join(legend))
				# Make up dictionary to pass to DrawPointLabel
				mDataDict= {"curveNum": curveNum, "legend": legend, 
							"pIndex": pIndex, "pointXY": pointXY, 
							"scaledXY": scaledXY}
				# Pass dict to update the point label
				self.client.UpdatePointLabel(mDataDict)
	
	def update_controls(self):
		self.show_actual_lut_cb.Enable((self.worker.argyll_version[0:3] > [1, 1, 0] or
										(self.worker.argyll_version[0:3] == [1, 1, 0] and
										 not "Beta" in self.worker.argyll_version_string)) and
									   not config.is_untethered_display())
		self.show_actual_lut_cb.SetValue(bool(getcfg("lut_viewer.show_actual_lut")) and
										 not config.is_untethered_display())
	
	@property
	def worker(self):
		return self.client.worker

	def display_changed(self, event):
		self.worker.enumerate_displays_and_ports(check_lut_access=False,
												 enumerate_ports=False,
												 include_network_devices=False)


def main():
	config.initcfg("curve-viewer")
	# Backup display config
	cfg_display = getcfg("display.number")
	lang.init()
	lang.update_defaults()
	app = BaseApp(0)
	app.TopWindow = LUTFrame(None, -1)
	app.TopWindow.Bind(wx.EVT_CLOSE, app.TopWindow.OnClose, app.TopWindow)
	if sys.platform == "darwin":
		app.TopWindow.init_menubar()
	wx.CallLater(1, _main, app)
	app.MainLoop()

def _main(app):
	app.TopWindow.listen()
	app.TopWindow.display_changed(None)
	app.TopWindow.Bind(wx.EVT_DISPLAY_CHANGED, app.TopWindow.display_changed)
	app.TopWindow.display_no, geometry, client_area = app.TopWindow.get_display()
	app.TopWindow.Bind(wx.EVT_MOVE, app.TopWindow.move_handler, app.TopWindow)
	display_no = get_argyll_display_number(geometry)
	setcfg("display.number", display_no + 1)
	app.TopWindow.update_controls()
	for arg in sys.argv[1:]:
		if os.path.isfile(arg):
			app.TopWindow.drop_handler(safe_unicode(arg))
			break
	else:
		app.TopWindow.load_lut(get_display_profile(display_no))
	app.TopWindow.Show()

if __name__ == '__main__':
	main()
