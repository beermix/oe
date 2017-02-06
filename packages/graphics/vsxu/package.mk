################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="vsxu"
PKG_VERSION="98bf097"
#PKG_VERSION="eb18cff"
#PKG_GIT_BRANCH="0.6.0"
PKG_GIT_URL="https://github.com/vovoid/vsxu"
PKG_DEPENDS_TARGET="toolchain $OPENGL libX11 glew glfw zlib libpng libjpeg-turbo freetype"
PKG_SECTION="multimedia"
PKG_SHORTDESC="vsxu:"
PKG_LONGDESC="vsxu:"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

export LDFLAGS="$LDFLAGS -lX11"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 \
                       -DVSXU_STATIC=1 \
                       -DCMAKE_POSITION_INDEPENDENT_CODE=1 \
                       -DCMAKE_CXX_FLAGS=-I$SYSROOT_PREFIX/usr/include/freetype2"

post_makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib/vsxu
  cp -PR $INSTALL/usr/lib/* $SYSROOT_PREFIX/usr/lib

  mkdir -p $SYSROOT_PREFIX/usr/include/
  cp -RP $INSTALL/usr/include/* $SYSROOT_PREFIX/usr/include

  mkdir -p $SYSROOT_PREFIX/usr/share/
    cp -RP $INSTALL/usr/share/vsxu $SYSROOT_PREFIX/usr/share
}
