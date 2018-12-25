# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="gmp"
PKG_VERSION="6.1.2"
PKG_SHA256="87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
PKG_ARCH="any"
PKG_LICENSE="LGPLv3+"
PKG_SITE="http://gmplib.org/"
PKG_URL="https://gmplib.org/download/gmp/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CONFIGURE_OPTS_HOST="--enable-cxx --enable-static --disable-shared"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

pre_configure_host() {
  export CPPFLAGS="$CPPFLAGS -fexceptions"
}
