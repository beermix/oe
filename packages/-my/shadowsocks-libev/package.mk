PKG_NAME="shadowsocks-libev"
PKG_VERSION="v2.5.6"
PKG_GIT_URL="https://github.com/shadowsocks/shadowsocks-libev"
PKG_GIT_BRANCH="master"
PKG_KEEP_CHECKOUT="yes"
#PKG_DEPENDS_TARGET="toolchain openssl pcre"
PKG_DEPENDS_TARGET="toolchain openssl ipset libevent pcre libsodium udns libev"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
   cd $ROOT/$PKG_BUILD
}

CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O2 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --disable-shared \
			   --enable-static \
			   --disable-ssp \
			   --disable-silent-rules \
			   --disable-documentation \
			   --enable-system-shared-lib \
			   --with-pcre=$SYSROOT_PREFIX/usr"