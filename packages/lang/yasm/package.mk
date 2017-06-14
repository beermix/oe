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

PKG_NAME="yasm"
#PKG_VERSION="1.3.0"
PKG_VERSION="6caf151"
PKG_GIT_URL="https://github.com/yasm/yasm"
#PKG_URL="http://www.tortall.net/projects/yasm/releases/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SECTION="toolchain/lang"
PKG_SHORTDESC="yasm: A complete rewrite of the NASM assembler"
PKG_LONGDESC="Yasm is a complete rewrite of the NASM assembler under the new BSD License (some portions are under other licenses, see COPYING for details). It is designed from the ground up to allow for multiple assembler syntaxes to be supported (eg, NASM, TASM, GAS, etc.) in addition to multiple output object formats and even multiple instruction sets. Another primary module of the overall design is an optimizer module."

PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--disable-debug \
                         --disable-warnerror \
                         --disable-profiling \
                         --disable-gcov \
                         --disable-python \
                         --disable-python-bindings \
                         --enable-nls \
                         --disable-rpath \
                         --without-dmalloc \
                         --with-gnu-ld \
                         --without-libiconv-prefix \
                         --without-libintl-prefix"
                         
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"
                         
PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DENABLE_NLS=OFF -DYASM_BUILD_TESTS=OFF"

PKG_CMAKE_OPTS_TARGET="$PKG_CMAKE_OPTS_HOST -DBUILD_SHARED_LIBS=OFF"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"
