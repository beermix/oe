PKG_NAME="libatomic_ops"
PKG_VERSION="d0b9e1a"
PKG_GIT_URL="https://github.com/ivmai/libatomic_ops"
PKG_DEPENDS_TARGET="toolchain openssl"

PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			   --disable-shared \
			   --with-gnu-ld"
		
