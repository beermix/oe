PKG_NAME="shadowsocks-libev"
PKG_VERSION="3.0.1"
PKG_URL="https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$PKG_VERSION/shadowsocks-libev-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain pcre libsodium udns libev mbedtls"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --disable-documentation"