# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bzip2"
PKG_VERSION="1.0.6"
PKG_SHA256="a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd"
PKG_LICENSE="GPL"
PKG_SITE="http://www.bzip.org"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain"
PKG_BUILD_FLAGS="+pic +pic:host"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-fno-semantic-interposition -ffunction-sections -O3  -fPIC|"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-fno-semantic-interposition -ffunction-sections -O3  -fPIC|"`
}

pre_configure_host() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-fno-semantic-interposition -ffunction-sections -O3  -fPIC|"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-fno-semantic-interposition -ffunction-sections -O3  -fPIC|"`
}

PKG_CONFIGURE_OPTS_HOST="--disable-silent-rules"
