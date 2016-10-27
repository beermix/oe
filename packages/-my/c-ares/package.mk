PKG_NAME="c-ares"
PKG_VERSION="1.11.0"
PKG_URL="http://c-ares.haxx.se/download/c-ares-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl libgpg-error"
PKG_DEPENDS_HOST="toolchain zlib openssl libgpg-error"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --with-random=/dev/urandom \
			   --disable-debug \
			   --disable-shared \
			   --enable-static \
			   --with-gnu-ld"