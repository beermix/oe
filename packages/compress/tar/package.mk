PKG_NAME="tar"
PKG_VERSION="1.32"
PKG_SHA256="d0d3ae07f103323be809bc3eac0dcc386d52c5262499fe05511ac4788af1fdd8"
PKG_URL="http://mirrors.kernel.org/gnu/tar/tar-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"

PKG_CONFIGURE_OPTS_TARGET="--without-selinux \
			      --without-posix-acls \
			      --without-xattrs \
			      --disable-acl"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
