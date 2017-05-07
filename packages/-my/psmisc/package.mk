PKG_NAME="psmisc"
PKG_VERSION="22.21"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_URL="http://downloads.sourceforge.net/psmisc/psmisc-$PKG_VERSION.tar.gz"
#PKG_SOURCE_DIR="psmisc-master-c1415251578b380ecdfcabaaadd16a86814a4695"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --enable-static \
                           --disable-shared \
                           --disable-silent-rules"