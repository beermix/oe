# -*- coding: utf-8 -*-

import os

import wx
import wx.xrc as xrc

from config import getbitmap


class BitmapButton(xrc.XmlResourceHandler):
	
	def __init__(self):
		xrc.XmlResourceHandler.__init__(self)
		# Standard styles
		self.AddWindowStyles()

	def CanHandle(self,node):
		return self.IsOfClass(node, 'wxBitmapButton')

	# Process XML parameters and create the object
	def DoCreateResource(self):
		name = os.path.splitext(self.GetText('bitmap'))[0]
		if name.startswith('../'):
			name = name[3:]
		bitmap = getbitmap(name)
		w = wx.BitmapButton(self.GetParentAsWindow(),
							self.GetID(),
							bitmap,
							pos=self.GetPosition(),
							size=self.GetSize(),
							style=self.GetStyle(),
							name=self.GetName())

		self.SetupWindow(w)
		return w


class StaticBitmap(xrc.XmlResourceHandler):
	
	def __init__(self):
		xrc.XmlResourceHandler.__init__(self)
		# Standard styles
		self.AddWindowStyles()

	def CanHandle(self,node):
		return self.IsOfClass(node, 'wxStaticBitmap')

	# Process XML parameters and create the object
	def DoCreateResource(self):
		name = os.path.splitext(self.GetText('bitmap'))[0]
		if name.startswith('../'):
			name = name[3:]
		bitmap = getbitmap(name)
		w = wx.StaticBitmap(self.GetParentAsWindow(),
							self.GetID(),
							bitmap,
							pos=self.GetPosition(),
							size=self.GetSize(),
							style=self.GetStyle(),
							name=self.GetName())

		self.SetupWindow(w)
		return w
