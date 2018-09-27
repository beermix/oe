# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libarchive"
PKG_VERSION="3.3.3"
PKG_SHA256="ba7eb1781c9fbbae178c4c6bad1c6eb08edab9a1496c64833d1715d022b30e2e"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libarchive/libarchive/releases"
PKG_URL="https://www.libarchive.org/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain lzo:host lz4:host xz:host bzip2:host expat"
PKG_DEPENDS_TARGET="toolchain lzo lz4 bzip2"
PKG_SECTION="compress"
PKG_SHORTDESC="libarchive data compressor/decompressor"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DENABLE_SHARED=0 -DENABLE_STATIC=1 -DCMAKE_POSITION_INDEPENDENT_CODE=1 -DENABLE_EXPAT=0 -DENABLE_ICONV=0 -DENABLE_LIBXML2=0 -DENABLE_LZO=1 -DENABLE_TEST=0 -DENABLE_COVERAGE=0"

post_makeinstall_target() {
  rm -rf $INSTALL
}
