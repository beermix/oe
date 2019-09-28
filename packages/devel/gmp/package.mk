# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gmp"
PKG_VERSION="6.1.2"
PKG_SHA256="87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
PKG_LICENSE="LGPLv3+"
PKG_SITE="http://gmplib.org/"
PKG_URL="https://gmplib.org/download/gmp/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host m4:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers."
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CONFIGURE_OPTS_HOST="--enable-cxx --enable-fat --enable-static --disable-shared"

PKG_CONFIGURE_OPTS_TARGET="--enable-cxx --enable-static --disable-shared"

pre_configure_host() {
  export CPPFLAGS="$CPPFLAGS -fexceptions"
}