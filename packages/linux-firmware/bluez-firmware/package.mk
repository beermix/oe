################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
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

PKG_NAME="bluez-firmware"
PKG_VERSION="1.2"
PKG_REV="1"
PKG_ARCH="x86_64"
PKG_LICENSE="other"
PKG_SITE="https://downloadcenter.intel.com/search?keyword=linux+microcode"
PKG_URL="http://bluez.sf.net/download/bluez-firmware-1.2.tar.gz"
PKG_DEPENDS_TARGET="toolchain"	
PKG_SECTION="linux-firmware"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

MAKEFLAGS="-j1"

make_target() {
make CC="$CC" \
     AR="$AR r" \
     LD="$LD" \
     XCFLAGS="$CFLAGS" \
     RANLIB="$RANLIB" \
     XLDFLAGS="$LDFLAGS" \
     MAKEDEPPROG="$CC" \
     CFLAGS="$CFLAGS"
}

