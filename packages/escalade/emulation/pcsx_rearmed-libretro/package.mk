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

PKG_NAME="pcsx_rearmed-libretro"
PKG_VERSION="6f7b363"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/pcsx_rearmed"
PKG_URL="https://github.com/libretro/pcsx_rearmed/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="emulation"
PKG_SHORTDESC="ARM optimized PCSX fork"
PKG_LONGDESC="PCSX ReARMed is yet another PCSX fork based on the PCSX-Reloaded project, which itself contains code from PCSX, PCSX-df and PCSX-Revolution."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  tar -zxf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz -C $BUILD
  mv $BUILD/pcsx_rearmed* $BUILD/$PKG_NAME-$PKG_VERSION
}

configure_target() {
  :
}

make_target() {
  cd $ROOT/$PKG_BUILD
  if [[ "$TARGET_FPU" =~ "neon" ]]; then
    make -f Makefile.libretro HAVE_NEON=1 USE_DYNAREC=1 BUILTIN_GPU=neon
  else
    make -f Makefile.libretro USE_DYNAREC=1 BUILTIN_GPU=neon
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp pcsx_rearmed_libretro.so $INSTALL/usr/lib/libretro/
}
