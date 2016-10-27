PKG_NAME="dnsmasq"
PKG_VERSION="2.76"
PKG_URL="http://thekelleys.org.uk/dnsmasq/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl libevent expat"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#PKG_MAKE_OPTS_TARGET="CC=$TARGET_CC AR=$TARGET_AR BUILD_CC=$HOST_CC -j1"

CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"

make_target() {
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" -j1
}