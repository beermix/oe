PKG_NAME="shadowsocks-libev"
PKG_VERSION="git"
PKG_DEPENDS_TARGET="toolchain pcre libsodium libudns libev mbedtls"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

unpack() {
  git clone --recursive -v --depth 1 https://github.com/shadowsocks/shadowsocks-libev $PKG_BUILD
  cd $PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --disable-documentation"