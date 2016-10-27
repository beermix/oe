PKG_NAME="geoip-api-c"
PKG_VERSION="6e18deb"
PKG_URL="https://github.com/maxmind/geoip-api-c/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gawk"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_realloc_0_nonnull=yes \
                           ac_cv_func_malloc_0_nonnull=yes \
                           --enable-static --disable-shared"