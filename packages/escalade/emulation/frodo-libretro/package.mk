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

PKG_NAME="frodo-libretro"
#PKG_VERSION="4c15016"
PKG_VERSION="a4952d2"
PKG_SITE="https://github.com/r-type/frodo-libretro"
#PKG_GIT_URL="https://github.com/r-type/frodo-libretro"
PKG_GIT_URL="https://github.com/diablodiab/frodo-libretro"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="emulation"
PKG_SHORTDESC="Frodo C64 emulator libretro core"


PKG_AUTORECONF="no"

#post_unpack() {
#  mv $BUILD/libretro-fsuae* $BUILD/$PKG_NAME-$PKG_VERSION
#}

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  :
}
