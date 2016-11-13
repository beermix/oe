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

PKG_NAME="gpsp"
PKG_VERSION="4d860ae"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/gpsp"
PKG_URL="https://github.com/libretro/gpsp/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="libretro"
PKG_SHORTDESC="gpSP for libretro."
PKG_LONGDESC="gameplaySP is a Gameboy Advance emulator for Playstation Portable"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  if [ "$ARCH" == "arm" ]; then
    make CC=$CC platform=armv
  else
    make CC=$CC
  fi  
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp gpsp_libretro.so $INSTALL/usr/lib/libretro/
}
