################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="kodi-language-addons"
PKG_VERSION="a8158f7"
PKG_SITE="https://github.com/xbmc/repo-resources"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="kodi language add-ons"
PKG_LONGDESC="kodi language add-ons"

PKG_AUTORECONF="no"
PKG_IS_ADDON="no"

make_target() {
  :
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/kodi/addons/
    for lng in $KODI_LANGUAGE_LIST; do
        cp -PR $ROOT/$PKG_BUILD/*.$lng $INSTALL/usr/share/kodi/addons/
    done
}
