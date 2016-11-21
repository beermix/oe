PKG_NAME="psmisc"
PKG_VERSION="22.21"
PKG_URL="http://downloads.sourceforge.net/psmisc/psmisc-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --enable-static \
                           --disable-shared \
                           --disable-silent-rules \
                           --disable-harden-flags"