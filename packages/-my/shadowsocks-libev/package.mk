PKG_NAME="shadowsocks-libev"
PKG_VERSION="v2.5.6"
PKG_GIT_URL="https://github.com/shadowsocks/shadowsocks-libev"
PKG_DEPENDS_TARGET="toolchain openssl libevent pcre libsodium udns libev mbedtls"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --with-crypto-library=mbedtls \
			      --enable-silent-rules \
			      --disable-documentation \
			      --enable-system-shared-lib \
			      --with-pcre=$SYSROOT_PREFIX/usr"