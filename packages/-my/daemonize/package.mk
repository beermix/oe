PKG_NAME="daemonize"
PKG_VERSION="master"
PKG_URL="https://github.com/bmc/daemonize/archive/master.zip"
PKG_DEPENDS_TARGET="toolchain"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_setpgrp_void=no --enable-static --disable-shared --with-gnu-ld"