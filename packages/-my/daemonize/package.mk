PKG_NAME="daemonize"
PKG_VERSION="18869a7"
PKG_GIT_URL="https://github.com/bmc/daemonize"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_setpgrp_void=no --enable-static --disable-shared --with-gnu-ld"