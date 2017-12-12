PKG_NAME="geoip-api-c"
PKG_VERSION="89e1b85"
PKG_GIT_URL="https://github.com/maxmind/geoip-api-c"
PKG_DEPENDS_TARGET="toolchain gawk"

PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_realloc_0_nonnull=yes \
                           ac_cv_func_malloc_0_nonnull=yes \
                           --enable-static --disable-shared"