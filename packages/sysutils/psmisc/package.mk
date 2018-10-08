PKG_NAME="psmisc"
PKG_VERSION="23.2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_PRIORITY="optional"
PKG_SECTION="tools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --enable-static \
                           --disable-shared \
                           --with-sysroot=$SYSROOT_PREFIX"
