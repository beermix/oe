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

PKG_NAME="prboom-libretro"
PKG_VERSION="b326bff"
PKG_SITE="https://github.com/libretro/libretro-prboom"
PKG_GIT_URL="https://github.com/libretro/libretro-prboom"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="emulation"
PKG_SHORTDESC="libretro implementation of Doom"
PKG_LONGDESC="libretro implementation of Doom"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  tar -zxf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz -C $BUILD
  mv $BUILD/libretro-prboom* $BUILD/$PKG_NAME-$PKG_VERSION
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp prboom_libretro.so $INSTALL/usr/lib/libretro/prboom_libretro.so
}
