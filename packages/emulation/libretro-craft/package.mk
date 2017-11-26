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

PKG_NAME="libretro-craft"
PKG_VERSION="2c6c6cf"
PKG_SHA256="9e5c7aa41e1db2fab54f202e5925db47faf0bf376853ce517d176f96803d9701"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/Craft"
PKG_URL="https://github.com/libretro/Craft/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="Craft-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_SECTION="emulation"
PKG_SHORTDESC="A simple Minecraft clone written in C using modern OpenGL (shaders)"
PKG_LONGDESC="A simple Minecraft clone written in C using modern OpenGL (shaders)"

PKG_LIBNAME="craft_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"
PKG_LIBVAR="CRAFT_LIB"

pre_configure_target() {
  # fails to build in subdirs
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

make_target() {
  case $PROJECT in
    RPi)
      case $DEVICE in
        RPi)
          make -f Makefile.libretro platform=rpi
          ;;
        RPi2)
          make -f Makefile.libretro platform=rpi2
          ;;
      esac
      ;;
    imx6)
      make -f Makefile.libretro platform=imx6
      ;;
    WeTek_Play|WeTek_Core|Odroid_C2|WeTek_Hub|WeTek_Play_2)
      if [ "$TARGET_ARCH" = "aarch64" ]; then
        make -f Makefile.libretro platform=aarch64
      else
        make -f Makefile.libretro platform=armv7-neon-gles-cortex-a9
      fi
      ;;
    Generic)
      make -f Makefile.libretro
      ;;
  esac
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME
  cp $PKG_LIBPATH $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME
  echo "set($PKG_LIBVAR $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME)" > $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME/$PKG_NAME-config.cmake
}
