################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
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

PKG_NAME="libretro-beetle-psx"
PKG_VERSION="80a21f2"
PKG_SHA256="e889b55fc3b42821244819c4a93bf33419b89e08bb0d3d39b7fa5f537062c2cf"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-psx-libretro"
PKG_URL="https://github.com/libretro/beetle-psx-libretro/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="beetle-psx-libretro-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_SECTION="emulation"
PKG_SHORTDESC="Fork of Mednafen PSX"
PKG_LONGDESC="Fork of Mednafen PSX"

PKG_LIBNAME="mednafen_psx_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"
PKG_LIBVAR="BEETLE-PSX_LIB"

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME
  cp $PKG_LIBPATH $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME
  echo "set($PKG_LIBVAR $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME)" > $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME/$PKG_NAME-config.cmake
}
