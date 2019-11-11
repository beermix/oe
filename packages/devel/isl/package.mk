# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="isl"
#PKG_VERSION="0.22"
#PKG_SHA256="6c8bc56c477affecba9c59e2c9f026967ac8bad01b51bdd07916db40a517b9fa"
PKG_VERSION="0.16.1"
PKG_SHA256="45292f30b3cb8b9c03009804024df72a79e9b5ab89e41c94752d6ea58a1e4b02"
PKG_SITE="http://isl.gforge.inria.fr/?C=M;O=D"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="libtool:host intltool:host gmp:host"

pre_configure_host() {
  unset CFLAGS
}

PKG_CONFIGURE_OPTS_HOST="--with-gmp-prefix=$TOOLCHAIN \
			    --disable-shared \
			    --enable-static \
			    --with-gnu-ld"
