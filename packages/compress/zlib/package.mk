# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="1.2.11"
PKG_SHA256="4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066"
PKG_LICENSE="OSS"
PKG_SITE="http://www.zlib.net"
PKG_URL="http://zlib.net/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic:host +pic +hardening"
#PKG_BUILD_FLAGS="+hardening"

pre_configure_target() {
  export CFLAGS="$CFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto -fno-math-errno -fno-semantic-interposition -fno-trapping-math -fprofile-generate -fprofile-dir=pgo -fprofile-update=atomic"
  export CXXFLAGS="$CXXFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto -fno-math-errno -fno-semantic-interposition -fno-trapping-math -fprofile-generate -fprofile-dir=pgo -fprofile-update=atomic"
}

pre_configure_host() {
  export CC=$LOCAL_CC
  export CXX=$LOCAL_CXX
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_build_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
}

post_configure_target() {
 ## configure minizip
 (
  cd $PKG_BUILD/.$TARGET_NAME/contrib/minizip
  rm Makefile
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:../../"
  do_autoreconf
  ./configure --host=$TARGET_NAME --build=$HOST_NAME $TARGET_CONFIGURE_OPTS --disable-static
 )
}

post_make_target() {
 # make minizip
 make -C $PKG_BUILD/.$TARGET_NAME/contrib/minizip
}

post_makeinstall_target() {
 # Install minizip
 make -C $PKG_BUILD/.$TARGET_NAME/contrib/minizip DESTDIR=$SYSROOT_PREFIX install
 cp -PL $PKG_BUILD/.$TARGET_NAME/contrib/minizip/.libs/libminizip.so* $INSTALL/usr/lib/
}
