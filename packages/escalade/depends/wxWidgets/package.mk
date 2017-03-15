################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
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

PKG_NAME="wxWidgets"
PKG_VERSION="3.1.0"
PKG_ARCH="any"
PKG_LICENSE="wxWindows Licence"
PKG_SITE="http://www.wxwidgets.org/"
PKG_URL="https://github.com/wxWidgets/wxWidgets/releases/download/v$PKG_VERSION/wxWidgets-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain gtk+ libSM"
PKG_SECTION="depends"
PKG_SHORTDESC="A cross-platform GUI and tools library for GTK, MS Windows, and MacOS."
PKG_LONGDESC="A cross-platform GUI and tools library for GTK, MS Windows, and MacOS."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-precomp-headers"

post_makeinstall_target() {
  ln -sf $SYSROOT_PREFIX/usr/lib/wx/config/x86_64-openelec-linux-gnu-gtk2-unicode-3.1 $SYSROOT_PREFIX/usr/bin/wx-config
  $SED "s:^prefix=.*:prefix=$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/wx-config
  rm -rf $INSTALL/usr/bin
}
