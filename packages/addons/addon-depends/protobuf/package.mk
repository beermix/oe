# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="protobuf"
PKG_VERSION="3.6.1"
PKG_SHA256="b3732e471a9bb7950f090fd0457ebd2536a9ba0891b7f3785919c654fe2a2529"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://developers.google.com/protocol-buffers/"
PKG_URL="https://github.com/google/$PKG_NAME/releases/download/v$PKG_VERSION/$PKG_NAME-cpp-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib protobuf:host"
PKG_SECTION="devel"
PKG_SHORTDESC="protobuf: Protocol Buffers - Google's data interchange format"
PKG_LONGDESC="protobuf: Protocol Buffers - Google's data interchange format"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CMAKE_SCRIPT="$PKG_BUILD/cmake/CMakeLists.txt"

PKG_CMAKE_OPTS_HOST="-DCMAKE_NO_SYSTEM_FROM_IMPORTED=1 \
                     -DBUILD_SHARED_LIBS=0 \
                     -Dprotobuf_BUILD_TESTS=0 \
                     -Dprotobuf_BUILD_EXAMPLES=0 \
                     -Dprotobuf_WITH_ZLIB=1"

PKG_CMAKE_OPTS_TARGET="$PKG_CMAKE_OPTS_HOST"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin

  # HACK: we have protoc in $TOOLCHAIN/bin but it seems
  # the one from sysroot prefix is picked when building hyperion. remove it!
  rm -f $SYSROOT_PREFIX/usr/bin/protoc
}
