# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

import subprocess
import xbmc
import xbmcaddon


class Snapclient():

    def __init__(self):
        self.id = xbmcaddon.Addon().getAddonInfo('id')
        self.is_started = True

    def restart(self):
        subprocess.call(['systemctl', 'restart', self.id])

    def start(self):
        if not self.is_started:
            self.is_started = True
            subprocess.call(['systemctl', 'start', self.id])

    def stop(self):
        if self.is_started:
            self.is_started = False
            subprocess.call(['systemctl', 'stop', self.id])


class Player(xbmc.Player):

    def __init__(self):
        super(Player, self).__init__(self)
        self.snapclient = Snapclient()
        self.onSettingChanged()

    def onAVChange(self):
        self.onKodiStart()

    def onAVStarted(self):
        self.onKodiStart()

    def onKodiStart(self):
        if self.kodi:
            self.snapclient.stop()

    def onKodiStop(self):
        self.snapclient.start()

    def onPlayBackEnded(self):
        self.onKodiStop()

    def onPlayBackError(self):
        self.onKodiStop()

    def onPlayBackStopped(self):
        self.onKodiStop()

    def onSettingChanged(self):
        self.kodi = xbmcaddon.Addon().getSetting('sc_k') == 'true'
        if self.kodi and self.isPlaying():
            self.snapclient.stop()
        else:
            self.snapclient.restart()


class Monitor(xbmc.Monitor):

    def __init__(self, *args, **kwargs):
        xbmc.Monitor.__init__(self)
        self.player = Player()

    def onSettingsChanged(self):
        self.player.onSettingChanged()


if __name__ == '__main__':
    Monitor().waitForAbort()
