PKG_NAME="shadowsocks-libev"
PKG_VERSION="aca5f5d"
PKG_GIT_URL="https://github.com/shadowsocks/shadowsocks-libev"
#PKG_DEPENDS_TARGET="toolchain openssl pcre"
PKG_DEPENDS_TARGET="toolchain openssl libevent pcre libsodium udns libev"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --disable-shared \
			   --enable-static \
			   --disable-ssp \
			   --enable-silent-rules \
			   --disable-documentation \
			   --enable-system-shared-lib \
			   --with-pcre=$SYSROOT_PREFIX/usr"