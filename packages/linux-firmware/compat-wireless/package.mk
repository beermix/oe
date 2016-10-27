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

PKG_NAME="compat-wireless"
PKG_VERSION="2016-06-20"
PKG_URL="http://mirror2.openwrt.org/sources/compat-wireless-2016-06-20.tar.bz2"
PKG_DEPENDS_TARGET="toolchain intel-ucode:host"
PKG_SECTION="linux-firmware"
PKG_SHORTDESC="intel-ucode: Intel CPU microcodes"
PKG_LONGDESC="intel-ucode: Intel CPU microcodes"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#unpack() {
#  mkdir -p $ROOT/$PKG_BUILD
#  tar xf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tgz -C $ROOT/$PKG_BUILD
#}

make_target() {
make CC="$CC" AR="$AR r" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS -DDEBUG=0"
}