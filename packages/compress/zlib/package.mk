# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="zlib"
PKG_VERSION="1.2.11"
PKG_SHA256="4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066"
PKG_LICENSE="OSS"
PKG_SITE="http://www.zlib.net"
PKG_URL="http://zlib.net/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic:host +pic"

TARGET_CONFIGURE_OPTS="--prefix=/usr"
HOST_CONFIGURE_OPTS="--prefix=$TOOLCHAIN"

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3 -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math|"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3 -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math|"`
}

post_configure_target() {
 ## configure minizip
 (
  cd $PKG_BUILD/.$TARGET_NAME/contrib/minizip
  rm Makefile
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:../../"
  do_autoreconf
  ./configure --host=$TARGET_NAME --build=$HOST_NAME $TARGET_CONFIGURE_OPTS --enable-static=no
 )
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_build_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
}

post_make_target() {
 # make minizip
 make -C $PKG_BUILD/.$TARGET_NAME/contrib/minizip
}

post_makeinstall_target() {
 # Install minizip
 make -C $PKG_BUILD/.$TARGET_NAME/contrib/minizip DESTDIR=$SYSROOT_PREFIX install -j1
 cp -PL $PKG_BUILD/.$TARGET_NAME/contrib/minizip/.libs/libminizip.so* $INSTALL/usr/lib/
}
