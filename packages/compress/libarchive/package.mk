# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libarchive"
PKG_VERSION="3.4.2"
PKG_SHA256="b60d58d12632ecf1e8fad7316dc82c6b9738a35625746b47ecdcaf4aed176176"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libarchive/libarchive/releases"
PKG_URL="https://www.libarchive.org/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="A multi-format archive and compression library."

PKG_CMAKE_OPTS_TARGET="-DENABLE_SHARED=0 -DENABLE_STATIC=1 -DCMAKE_POSITION_INDEPENDENT_CODE=1 -DENABLE_EXPAT=0 -DENABLE_ICONV=0 -DENABLE_LIBXML2=0 -DENABLE_LZO=1 -DENABLE_TEST=0 -DENABLE_COVERAGE=0"

post_makeinstall_target() {
  rm -rf $INSTALL

  # delete the shared library as we only want static
  rm $SYSROOT_PREFIX/usr/lib/libarchive.so*
}
