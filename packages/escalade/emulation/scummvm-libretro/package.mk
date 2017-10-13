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

PKG_NAME="scummvm-libretro"
PKG_VERSION="fbbe839"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/scummvm"
PKG_URL="https://github.com/libretro/scummvm/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="scummvm-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain flac libmad munt"
PKG_SECTION="emulation"
PKG_SHORTDESC="ScummVM with libretro backend."
PKG_LONGDESC="ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  strip_lto
  cd ..
  rm -rf .$TARGET_NAME
}

configure_target() {
  :
}

make_target() {
  export GIT_VERSION=$PKG_VERSION
  export CXXFLAGS="$CXXFLAGS -DHAVE_POSIX_MEMALIGN=1"
  export LDFLAGS="$LDFLAGS -lmt32emu"
  make -C backends/platform/libretro/build HAVE_MT32EMU=1
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp backends/platform/libretro/build/*.so $INSTALL/usr/lib/libretro/
}
