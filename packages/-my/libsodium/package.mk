PKG_NAME="libsodium"
PKG_VERSION="ee9d89c"
PKG_GIT_URL="https://github.com/jedisct1/libsodium"
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
		
