################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="estouchy"
PKG_VERSION="1.0"
PKG_REV="101"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain kodi"
PKG_PRIORITY="optional"
PKG_SECTION="skin"
PKG_SHORTDESC="Kodi skin Estouchy"
PKG_LONGDESC="Kodi skin Estouchy"
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Estouchy"
PKG_ADDON_TYPE="xbmc.gui.skin"

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID
    cp -a $(get_build_dir kodi)/.$TARGET_NAME/addons/skin.estouchy/* $ADDON_BUILD/$PKG_ADDON_ID
}
