PKG_NAME="shadowsocks-libev"
PKG_VERSION="v2.5.6"
PKG_GIT_URL="https://github.com/shadowsocks/shadowsocks-libev"
PKG_DEPENDS_TARGET="toolchain openssl libevent pcre libsodium udns libev"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --enable-silent-rules \
			      --disable-documentation \
			      --enable-system-shared-lib \
			      --with-pcre=$SYSROOT_PREFIX/usr"