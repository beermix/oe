PKG_NAME="daemonize"
PKG_VERSION="18869a7"
PKG_URL="https://github.com/bmc/daemonize/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_setpgrp_void=no --disable-shared"