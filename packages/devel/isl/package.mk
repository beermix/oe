# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="isl"
#PKG_VERSION="0.21"
#PKG_SHA256="777058852a3db9500954361e294881214f6ecd4b594c00da5eee974cd6a54960"
PKG_VERSION="0.16.1"
PKG_SHA256="412538bb65c799ac98e17e8cfcdacbb257a57362acfaaff254b0fcae970126d2"
PKG_SITE="http://isl.gforge.inria.fr/?C=M;O=D"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
#PKG_URL="https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.16.1.tar.bz2"
PKG_DEPENDS_HOST="libtool:host intltool:host gmp:host"

pre_configure_host() {
  unset CFLAGS
}

PKG_CONFIGURE_OPTS_HOST="--with-gmp-prefix=$TOOLCHAIN \
			    --disable-shared \
			    --enable-static \
			    --with-gnu-ld"
