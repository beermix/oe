# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="mpfr"
PKG_VERSION="4.0.1"
PKG_SHA256="67874a60826303ee2fb6affc6dc0ddd3e749e9bfcb4c8655e3953d0458a6e16e"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.mpfr.org/"
PKG_URL="http://www.mpfr.org/mpfr-current/mpfr-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain gmp"
PKG_DEPENDS_HOST="ccache:host gmp:host"
PKG_LONGDESC="A C library for multiple-precision floating-point computations with exact rounding."
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME \
                         --enable-static --disable-shared \
                         --prefix=$TOOLCHAIN \
                         --with-gmp-lib=$TOOLCHAIN/lib \
                         --with-gmp-include=$TOOLCHAIN/include"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --enable-thread-safe"
