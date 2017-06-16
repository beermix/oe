################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
#      Copyright (C) 2017 Shane Meagher (shanemeagher)
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

PKG_NAME="librespot"
PKG_VERSION="446d7a9"
PKG_REV="100"
PKG_ARCH="any"
PKG_LICENSE="prop."
PKG_SITE="https://github.com/plietar/$PKG_NAME/"
PKG_GIT_URL="https://github.com/awiouy/librespot-binaries"
PKG_DEPENDS_TARGET="toolchain pyalsaaudio"
PKG_SECTION="service"
PKG_SHORTDESC="Librespot: use Spotify Connect through LibreELEC"
PKG_LONGDESC="Librespot ($PKG_VERSION) plays Spotify through LibreELEC using the opensource librespot library using a Spotify app as a remote."
PKG_AUTORECONF="no"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Librespot"
PKG_ADDON_TYPE="xbmc.service"
PKG_MAINTAINER="Anton Voyl (awiouy)"

make_target() {
  if [ "PROJECT" = "RPi" ]; then
    exit
  fi
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID"
  cp -R "$PKG_BUILD/$TARGET_ARCH"/* \
        "$ADDON_BUILD/$PKG_ADDON_ID/"

  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/wizard"
  cp "$(get_build_dir pyalsaaudio)/.install_pkg/usr/lib/python2.7/site-packages/alsaaudio.so" \
     "$ADDON_BUILD/$PKG_ADDON_ID/wizard/"
}
