################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
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

PKG_NAME="intel-vaapi-driver"
PKG_VERSION="f5e479f"
PKG_REV="1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/01org/intel-vaapi-driver"
#PKG_URL="https://github.com/01org/intel-vaapi-driver/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_GIT_URL="https://github.com/01org/intel-vaapi-driver"
PKG_DEPENDS_TARGET="toolchain libva libdrm"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="intel-vaapi-driver: Intel G45+ driver for VAAPI"
PKG_LONGDESC="intel-vaapi-driver: Intel G45+ driver for VAAPI"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

if [ "$DISPLAYSERVER" = "x11" ]; then
  DISPLAYSERVER_LIBVA="--enable-x11 --disable-wayland"
elif [ "$DISPLAYSERVER" = "wayland" ]; then
  DISPLAYSERVER_LIBVA="--disable-x11 --enable-wayland"
else
  DISPLAYSERVER_LIBVA="--disable-x11 --disable-wayland"
fi

PKG_CONFIGURE_OPTS_TARGET="--disable-silent-rules \
                           --enable-drm \
                           $DISPLAYSERVER_LIBVA"
