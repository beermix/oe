PKG_NAME="shadowsocks-libev"
PKG_VERSION="3.1.1"
PKG_URL="https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$PKG_VERSION/shadowsocks-libev-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain pcre libsodium libev mbedtls c-ares"
PKG_SECTION="my"
PKG_USE_CMAKE="no"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --with-pcre=$SYSROOT_PREFIX/usr \
			      --disable-documentation \
			      --with-pic \
			      --with-gnu-ld"