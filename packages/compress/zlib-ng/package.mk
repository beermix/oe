# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="zlib-ng"
PKG_VERSION="796ad10"
PKG_URL="https://github.com/Dead2/zlib-ng/archive/${PKG_VERSION}.tar.gz"
#PKG_VERSION="665de7d"
#PKG_URL="https://github.com/mtl1979/zlib-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic:host +pic +hardening"

TARGET_CONFIGURE_OPTS="--prefix=/usr --zlib-compat --with-gzfileops --without-new-strategies"
HOST_CONFIGURE_OPTS="--prefix=$TOOLCHAIN --zlib-compat --with-gzfileops --without-new-strategies"

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3 -Wall|"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3 -Wall|"`
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_build_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
}
