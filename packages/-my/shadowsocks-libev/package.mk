PKG_NAME="shadowsocks-libev"
PKG_VERSION="3.0.2"
PKG_URL="https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$PKG_VERSION/shadowsocks-libev-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain pcre libsodium libudns libev mbedtls"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --with-gnu-ld \
			      --disable-documentation"