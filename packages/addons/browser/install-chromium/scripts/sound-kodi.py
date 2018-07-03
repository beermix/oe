################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################
# -*- coding: utf-8 -*-

import os
import sys
import xbmcaddon

def pauseXbmc():
  xbmc.executebuiltin("PlayerControl(Stop)")
  xbmc.audioSuspend()
  xbmc.enableNavSounds(False)

def resumeXbmc():
    xbmc.audioResume()
    xbmc.enableNavSounds(True)

arg = sys.argv[1]
if arg == 'pause':
  pauseXbmc()
else:
  resumeXbmc()
