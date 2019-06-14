PKG_NAME="libstatgrab"
PKG_VERSION="12c86c4"
URL="https://github.com/tdb/libstatgrab"
PKG_URL="https://github.com/tdb/libstatgrab/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           --enable-static \
                           --disable-shared \
                           --disable-saidar \
                           --disable-examples \
                           --disable-manpages \
                           --disable-setuid-binaries \
                           --disable-man-build \
                           --disable-tests"
