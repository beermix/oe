PKG_NAME="shadowsocks-libev"
PKG_VERSION="v3.0.1"
PKG_GIT_URL="https://github.com/shadowsocks/shadowsocks-libev"
PKG_DEPENDS_TARGET="toolchain pcre libsodium udns libev mbedtls"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --disable-documentation"