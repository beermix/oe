################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="beetle-psx-libretro"
PKG_VERSION="2f3057c"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-psx-libretro"
PKG_URL="https://github.com/libretro/beetle-psx-libretro/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="emulation"
PKG_SHORTDESC="Standalone port of Mednafen PSX to libretro."
PKG_LONGDESC="Standalone port of Mednafen PSX to libretro."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  mkdir out
  make HAVE_OPENGL=0
  mv mednafen_psx_libretro.so out/
  make clean
  make HAVE_OPENGL=1
  mv mednafen_psx_hw_libretro.so out/
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp out/* $INSTALL/usr/lib/libretro/
}
