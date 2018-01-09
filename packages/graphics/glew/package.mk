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

PKG_NAME="glew"
PKG_VERSION="2.0.0"
PKG_SHA256="c572c30a4e64689c342ba1624130ac98936d7af90c3103f9ce12b8a0c5736764"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://glew.sourceforge.net/"
PKG_URL="https://github.com/nigels-com/glew/releases/download/glew-2.0.0/glew-2.0.0.tgz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="graphics"
PKG_SHORTDESC="glew: The OpenGL Extension Wrangler Library"
PKG_LONGDESC="The OpenGL Extension Wrangler Library (GLEW) is a cross-platform C/C++ extension loading library. GLEW provides efficient run-time mechanisms for determining which OpenGL extensions are supported on the target platform. OpenGL core and extension functionality is exposed in a single header file."

make_target() {
  make CC="$CC" LD="$CC" AR="$AR" \
       POPT="$CFLAGS" LDFLAGS.EXTRA="$LDFLAGS" \
       GLEW_DEST="/usr" LIBDIR="/usr/lib" lib/libGLEW.a glew.pc
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -PR lib/libGLEW.a $SYSROOT_PREFIX/usr/lib

  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp -PR glew.pc $SYSROOT_PREFIX/usr/lib/pkgconfig

  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -PR include/GL $SYSROOT_PREFIX/usr/include
}
