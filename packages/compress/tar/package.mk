PKG_NAME="tar"
PKG_VERSION="1.29"
PKG_URL="http://mirrors.kernel.org/gnu/tar/tar-$PKG_VERSION.tar.xz"
#PKG_DEPENDS_TARGET="toolchain pcre acl attr"
PKG_DEPENDS_TARGET="toolchain pcre"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--with-xattrs --without-selinux"
