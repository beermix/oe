PKG_NAME="netperf"
PKG_VERSION="2.7.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"

pre_configure_target() {
  export CFLAGS="$CFLAGS -std=gnu89"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_setpgrp_void=yes --enable-demo"