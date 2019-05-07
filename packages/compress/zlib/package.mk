# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="1.2.11.1_jtkv6.3"
PKG_SHA256="897980569aa46d20a4ed9fd63e2e7ce9465e0dd4742a135603db397f168f7f01"
PKG_LICENSE="OSS"
PKG_SITE="http://www.zlib.net"
PKG_URL="https://github.com/jtkukunas/zlib/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain zlib:host"
PKG_LONGDESC="A general purpose (ZIP) data compression library."
PKG_TOOLCHAIN="configure"
#PKG_BUILD_FLAGS="+pic:host +pic +hardening"

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
  ./configure --prefix=/usr --libdir=/usr/lib --static --shared
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./configure --prefix=$TOOLCHAIN --libdir=$TOOLCHAIN/lib --static --shared
}

#post_configure_target() {
 ## configure minizip
# (
#  cd $PKG_BUILD/.$TARGET_NAME/contrib/minizip
#  rm Makefile
#  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:../../"
#  do_autoreconf
  #./configure --host=$TARGET_NAME --build=$HOST_NAME $TARGET_CONFIGURE_OPTS --disable-static
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
