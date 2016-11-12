PKG_NAME="tar"
PKG_VERSION="1.29"
PKG_URL="http://mirrors.kernel.org/gnu/tar/tar-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain pcre acl"
PKG_PRIORITY="optional"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="gl_cv_func_mbrtowc_incomplete_state=no gl_cv_func_wcrtomb_retval=no"