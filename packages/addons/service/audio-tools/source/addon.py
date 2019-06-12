# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

import default
import xbmcgui

cards = default.getCards()
index = xbmcgui.Dialog().select(default.ADDON_STRINGS(30001), cards)
if index != -1:
    default.ADDON.setSetting('at_card', cards[index])
