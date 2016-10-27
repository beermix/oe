PKG_NAME="libatomic_ops"
PKG_VERSION="3a497aa"
PKG_URL="https://github.com/ivmai/libatomic_ops/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			   --disable-shared \
			   --with-gnu-ld \
			   --enable-minimal=yes \
			   --disable-ssp"
		
