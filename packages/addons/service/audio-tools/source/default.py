# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

import os
import subprocess
import xbmc
import xbmcaddon

ADDON = xbmcaddon.Addon()
ADDON_ID = ADDON.getAddonInfo('id')
ADDON_STRINGS = ADDON.getLocalizedString

_default = 'PULSE: Default'
_sink_name = 'at_sink'


def call(command):
    return subprocess.call(command.split())


def check_output(command):
    try:
        return subprocess.check_output(command.split())
    except subprocess.CalledProcessError:
        return ''


def getCards():
    cards = [f for f in os.listdir('/proc/asound')
             if os.path.islink(os.path.join('/proc/asound', f))]
    cards.sort()
    cards.append(_default)
    return cards


class Monitor(xbmc.Monitor):

    def __init__(self, *args, **kwargs):
        xbmc.Monitor.__init__(self)

        with open('/etc/release') as release:
            self.is_rpi = release.read().startswith('RPi')
        if self.is_rpi:
            at_rpi = 'true'
            if not os.path.isdir('/proc/asound'):
                call('dtparam audio=on')
        else:
            at_rpi = 'false'
        ADDON.setSetting('at_rpi', at_rpi)
        self.onSettingsChanged()

    def onSettingsChanged(self):
        modules = check_output('pactl list modules short')
        for module in modules.splitlines():
            if 'sink_name=at_sink' in module:
                index = module.split()[0]
                call('pactl unload-module {}'.format(index))

        at_card = ADDON.getSetting('at_card')
        cards = getCards()
        if not at_card in cards:
            at_card = cards[0]
            ADDON.setSetting('at_card', at_card)

        if self.is_rpi and at_card == 'ALSA':
            index = os.readlink('/proc/asound/ALSA').strip('card')
            call('amixer -c {} cset numid=3 {}'
                 .format(index, ADDON.getSetting('at_rpi_ppr')))

        if at_card == _default:
            return

        tsched = 'tsched=0' if ADDON.getSetting('at_tsched') == 'true' else ''
        call('pactl load-module module-alsa-sink device_id={} sink_name={} {}'
             .format(at_card, _sink_name, tsched))
        call('pactl set-default-sink {}'.format(_sink_name))


if __name__ == '__main__':
    Monitor().waitForAbort()
