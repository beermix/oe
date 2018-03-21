################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
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

PKG_NAME="libarchive"
PKG_VERSION="3.3.2"
PKG_SHA256="ed2dbd6954792b2c054ccf8ec4b330a54b85904a80cef477a1c74643ddafa0ce"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libarchive/libarchive/releases"
PKG_URL="https://www.libarchive.org/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain lzo:host lz4:host xz:host bzip2:host expat"
PKG_DEPENDS_TARGET="toolchain lzo lz4 xz bzip2"
PKG_SECTION="compress"
PKG_SHORTDESC="libarchive data compressor/decompressor"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DENABLE_SHARED=0 -DENABLE_STATIC=1 -DCMAKE_POSITION_INDEPENDENT_CODE=1 -DENABLE_EXPAT=1 -DENABLE_ICONV=0 -DENABLE_LIBXML2=1 -DENABLE_LZO=1 -DENABLE_TEST=0 -DENABLE_COVERAGE=0"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL
}
