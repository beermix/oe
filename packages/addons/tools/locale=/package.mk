################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017 Team LibreELEC
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

PKG_NAME="locale"
PKG_REV="100"
PKG_ARCH="any"
PKG_DEPENDS_TARGET="toolchain glibc"
PKG_SECTION="virtual"
PKG_SHORTDESC="Locales: compile and set a custom locale definition"
PKG_LONGDESC="Locales ($PKG_REV) provides a script compile and set a custom locale definition"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Locale"
PKG_ADDON_TYPE="xbmc.python.script"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/i18n"
  cp -PR "$(get_build_dir glibc)/localedata/charmaps" \
         "$(get_build_dir glibc)/localedata/locales" \
         "$ADDON_BUILD/$PKG_ADDON_ID/i18n"
}
