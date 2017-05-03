PKG_NAME="shadowsocks-libev"
PKG_VERSION="3f0d39a"
PKG_GIT_URL="https://github.com/shadowsocks/shadowsocks-libev"
PKG_DEPENDS_TARGET="toolchain pcre libsodium libudns libev mbedtls"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --disable-documentation"