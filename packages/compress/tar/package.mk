PKG_NAME="tar"
PKG_VERSION="1.31"
PKG_URL="http://mirrors.kernel.org/gnu/tar/tar-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"

PKG_CONFIGURE_OPTS_TARGET="--without-selinux \
			   --without-posix-acls \
			   --without-selinux \
			   --without-xattrs \
			   --disable-acl \
			   --disable-nls"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
