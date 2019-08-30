PKG_NAME="findutils"
PKG_VERSION="4.7.0"
PKG_SHA256="c5fefbdf9858f7e4feb86f036e1247a54c79fc2d8e4b7064d5aaa1f47dfa789a"
PKG_URL="https://ftp.gnu.org/pub/gnu/findutils/findutils-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"

PKG_CONFIGURE_OPTS_TARGET="gl_cv_func_stdin=yes \
			      ac_cv_func_working_mktime=yes \
			      gl_cv_func_wcwidth_works=yes \
			      --without-selinux \
			      --disable-debug"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
