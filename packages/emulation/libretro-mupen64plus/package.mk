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

PKG_NAME="libretro-mupen64plus"
PKG_VERSION="9b01671"
PKG_SHA256="70acf1793eb0410e5e5812aa7ee5265a780b1d0d7ba198a7eb78fe3bb9fd4a8f"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mupen64plus-libretro"
PKG_URL="https://github.com/libretro/mupen64plus-libretro/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="mupen64plus-libretro-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_SECTION="emulation"
PKG_SHORTDESC="game.libretro.mupen64plus: Mupen64Plus for Kodi"
PKG_LONGDESC="game.libretro.mupen64plus: Mupen64Plus for Kodi"

PKG_LIBNAME="mupen64plus_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"
PKG_LIBVAR="MUPEN64PLUS_LIB"

make_target() {
  case $PROJECT in
    RPi)
      case $DEVICE in
        RPi)
          make platform=rpi
          ;;
        RPi2)
          make platform=rpi2
          ;;
      esac
      ;;
    imx6)
      make platform=imx6
      ;;
    WeTek_Play|WeTek_Core|Odroid_C2|WeTek_Hub|WeTek_Play_2)
      if [ "$TARGET_ARCH" = "aarch64" ]; then
        make platform=aarch64
      else
        make platform=armv7-neon-gles-cortex-a9
      fi
      ;;
    Generic)
      make WITH_DYNAREC=x86_64
      ;;
  esac
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME
  cp $PKG_LIBPATH $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME
  echo "set($PKG_LIBVAR $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME)" > $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME/$PKG_NAME-config.cmake
}
