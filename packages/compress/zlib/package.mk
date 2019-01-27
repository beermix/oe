# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="a346a9f"
PKG_SHA256=""
PKG_SITE="http://www.zlib.net"
PKG_URL="http://zlib.net/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/Dead2/zlib-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic:host +pic"

post_unpack() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME

  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
  export CXXFLAGS="$CXXFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
}

pre_configure_host() {
  export CC=$LOCAL_CC
  export CXX=$LOCAL_CXX
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  ./configure --prefix=/usr --zlib-compat --libdir=/usr/lib
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./configure --prefix=$TOOLCHAIN --zlib-compat --libdir=$TOOLCHAIN/lib
}

#post_configure_target() {
 ## configure minizip
# (
#  cd $PKG_BUILD/.$TARGET_NAME/contrib/minizip
#  rm Makefile
#  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:../../"
#  do_autoreconf
#  ./configure --host=$TARGET_NAME --build=$HOST_NAME $TARGET_CONFIGURE_OPTS --disable-static
# )
#}

#post_make_target() {
 # make minizip
# make -C $PKG_BUILD/.$TARGET_NAME/contrib/minizip
#}

#post_makeinstall_target() {
 # Install minizip
# make -C $PKG_BUILD/.$TARGET_NAME/contrib/minizip DESTDIR=$SYSROOT_PREFIX install
# cp -PL $PKG_BUILD/.$TARGET_NAME/contrib/minizip/.libs/libminizip.so* $INSTALL/usr/lib/
#}
