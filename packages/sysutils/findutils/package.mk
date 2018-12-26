PKG_NAME="findutils"
PKG_SHA256="ded4c9f73731cd48fec3b6bdaccce896473b6d8e337e9612e16cf1431bb1169d"
PKG_VERSION="4.6.0"
PKG_URL="http://ftpmirror.gnu.org/findutils/findutils-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_CONFIGURE_OPTS_TARGET="gl_cv_func_stdin=yes \
			      ac_cv_func_working_mktime=yes \
			      gl_cv_func_wcwidth_works=yes \
			      --without-selinux \
			      --disable-debug"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
