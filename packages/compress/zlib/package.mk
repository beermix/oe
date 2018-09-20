# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="zlib"
PKG_VERSION="1.2.11"
PKG_SHA256="4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.zlib.net"
PKG_URL="http://zlib.net/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/sspring/zlib/archive/${PKG_VERSION}.tar.gz"
#PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="compress"
PKG_SHORTDESC="zlib: A general purpose (ZIP) data compression library"
PKG_LONGDESC="zlib is a general purpose data compression library. All the code is thread safe. The data format used by the zlib library is described by RFCs (Request for Comments) 1950 to 1952 in the files ftp://ds.internic.net/rfc/rfc1950.txt (zlib format), rfc1951.txt (deflate format) and rfc1952.txt (gzip format)."
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3|"`
}