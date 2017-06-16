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

PKG_NAME="b43-firmware"
PKG_VERSION="6.30.163.46"
PKG_ARCH="any"
PKG_LICENSE="unknown"
PKG_SITE="https://wireless.wiki.kernel.org/en/users/Drivers/b43"
PKG_URL="http://www.lwfinger.com/$PKG_NAME/broadcom-wl-$PKG_VERSION.tar.bz2"
PKG_SOURCE_DIR="broadcom-wl-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain b43-fwcutter:host"
PKG_SECTION="firmware"
PKG_SHORTDESC="Firmware for Broadcom B43 wireless networking chips"
PKG_LONGDESC="Firmware for Broadcom B43 wireless networking chips"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  mkdir -p $ROOT/$PKG_BUILD
    tar -xf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.bz2 -C $ROOT/$PKG_BUILD
}

make_target() {
  : # nothing todo
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/firmware
    $ROOT/$TOOLCHAIN/bin/b43-fwcutter -w $INSTALL/usr/lib/firmware/ broadcom-wl-$PKG_VERSION.wl_apsta.o
}
