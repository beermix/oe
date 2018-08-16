# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

import os
import sys
import time
import xbmcaddon
import subprocess
from xml.dom.minidom import parse

sys.path.append('/usr/share/kodi/addons/service.libreelec.settings')

import oe

__addon__ = xbmcaddon.Addon();
__path__  = os.path.join(__addon__.getAddonInfo('path'), 'bin') + '/'

pauseXBMC = __addon__.getSetting("PAUSE_XBMC")

def pauseXbmc():
  if pauseXBMC == "true":
    xbmc.executebuiltin("PlayerControl(Stop)")
    xbmc.audioSuspend()
    xbmc.enableNavSounds(False)

def resumeXbmc():
  if pauseXBMC == "true":
    xbmc.audioResume()
    xbmc.enableNavSounds(True)

def startChromium(args):
  oe.execute('chmod +x ' + __path__ + 'chromium')
  oe.execute('chmod +x ' + __path__ + 'chromium.bin')
  oe.execute('chmod 4755 ' + __path__ + 'chrome-sandbox')

  try:
    window_mode = {
      'maximized': '--start-maximized',
      'kiosk': '--kiosk',
      'none': '',
    }

    raster_mode = {
      'default': '',
      'off': '--disable-accelerated-2d-canvas --disable-gpu-compositing',
      'force': '--enable-gpu-rasterization --enable-accelerated-2d-canvas --ignore-gpu-blacklist',
    }

    new_env = os.environ.copy()
    vaapi_mode = __addon__.getSetting('VAAPI_MODE')
    gpu_accel_mode = ''
    if vaapi_mode == 'intel':
      new_env['LIBVA_DRIVERS_PATH'] = '/usr/lib/va'
      new_env['LIBVA_DRIVER_NAME'] = 'i965'
    elif vaapi_mode == 'amd':
      new_env['LIBVA_DRIVERS_PATH'] = os.path.join(__addon__.getAddonInfo('path'), 'lib')
      new_env['LIBVA_DRIVER_NAME'] = 'vdpau'
    elif vaapi_mode == 'nvidia':
      new_env['LIBVA_DRIVERS_PATH'] = os.path.join(__addon__.getAddonInfo('path'), 'lib')
      new_env['LIBVA_DRIVER_NAME'] = 'vdpau'
      gpu_accel_mode = '--allow-no-sandbox-job --disable-gpu-sandbox'
    else:
      new_env['LIBGL_ALWAYS_SOFTWARE'] = '1'

    flash_plugin = ''
    if os.path.exists(__path__ + 'PepperFlash/libpepflashplayer.so'):
      flash_plugin = '--ppapi-flash-path=' + __path__ + 'PepperFlash/libpepflashplayer.so'

    if __addon__.getSetting('USE_CUST_AUDIODEVICE') == 'true':
      alsa_device = __addon__.getSetting('CUST_AUDIODEVICE_STR')
    else:
      alsa_device = getAudioDevice()
    alsa_param = ''
    if not alsa_device == None and not alsa_device == '':
      alsa_param = '--alsa-output-device=' + alsa_device

    chrome_params = window_mode.get(__addon__.getSetting('WINDOW_MODE')) + ' ' + \
                    raster_mode.get(__addon__.getSetting('RASTER_MODE')) + ' ' + \
                    flash_plugin + ' ' + \
                    gpu_accel_mode + ' ' + \
                    alsa_param + ' ' + \
                    args + ' ' + \
                    __addon__.getSetting('HOMEPAGE')
    subprocess.call(__path__ + 'chromium ' + chrome_params, shell=True, env=new_env)
  except Exception, e:
    oe.dbg_log('chromium', unicode(e))

def isRuning(pname):
  tmp = os.popen("ps -Af").read()
  pcount = tmp.count(pname)
  if pcount > 0:
    return True
  return False

def getAudioDevice():
  try:
    dom = parse("/storage/.kodi/userdata/guisettings.xml")
    audiooutput=dom.getElementsByTagName('audiooutput')
    for node in audiooutput:
      dev = node.getElementsByTagName('audiodevice')[0].childNodes[0].nodeValue
    if dev.startswith("ALSA:"):
      dev = dev.split("ALSA:")[1]
      if dev == "@":
        return None
      if dev.startswith("@:"):
        dev = dev.split("@:")[1]
    else:
      # not ALSA
      return None
  except:
    return None
  if dev.startswith("CARD="):
    dev = "plughw:" + dev
  return dev

if (not __addon__.getSetting("firstrun")):
  __addon__.setSetting("firstrun", "1")
  __addon__.openSettings()

try:
  args = ' '.join(sys.argv[1:])
except:
  args = ""

if args == 'widevine':
  install_widevine()
elif args == 'flash':
  install_flash()
else:
  if not isRuning('chromium.bin'):
    pauseXbmc()
    startChromium(args)
    while isRuning('chromium.bin'):
      time.sleep(1)
    resumeXbmc()
