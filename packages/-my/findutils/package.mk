PKG_NAME="findutils"
PKG_VERSION="4.6.0"
PKG_URL="http://ftpmirror.gnu.org/findutils/findutils-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="sysutils"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="gl_cv_func_stdin=yes \
			      ac_cv_func_working_mktime=yes \
			      gl_cv_func_wcwidth_works=yes \
			      --without-selinux \
			      --disable-debug"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
