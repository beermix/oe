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

PKG_NAME="libretro-beetle-pcfx"
PKG_VERSION="bb6adee"
PKG_SHA256="4c04bc8d27249aac03d16f685fe6cfc852481a562197dfbc943643b2e60a4f1b"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-pcfx-libretro"
PKG_URL="https://github.com/libretro/beetle-pcfx-libretro/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="beetle-pcfx-libretro-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_SECTION="emulation"
PKG_SHORTDESC="Standalone port of Mednafen PCFX to libretro"
PKG_LONGDESC="Standalone port of Mednafen PCFX to libretro"

PKG_LIBNAME="mednafen_pcfx_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"
PKG_LIBVAR="BEETLE-PCFX_LIB"

make_target() {
  case $PROJECT in
    RPi)
      case $DEVICE in
        RPi)
          make platform=armv6-hardfloat
          ;;
        RPi2)
          make platform=armv7-neon-hardfloat
          ;;
      esac
      ;;
    imx6)
      make platform=armv7-cortexa9-neon-hardfloat
      ;;
    WeTek_Play|WeTek_Core|Odroid_C2|WeTek_Hub|WeTek_Play_2)
      if [ "$TARGET_ARCH" = "aarch64" ]; then
        make platform=aarch64
      else
        make platform=armv7-cortexa9-neon-hardfloat
      fi
      ;;
    Generic)
      make
      ;;
  esac
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME
  cp $PKG_LIBPATH $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME
  echo "set($PKG_LIBVAR $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME)" > $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME/$PKG_NAME-config.cmake
}
