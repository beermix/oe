PKG_NAME="dnsmasq"
PKG_VERSION="2.77"
PKG_URL="http://thekelleys.org.uk/dnsmasq/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl libevent expat"
PKG_SECTION="my"



#PKG_MAKE_OPTS_TARGET="CC=$TARGET_CC AR=$TARGET_AR BUILD_CC=$HOST_CC -j1"

make_target() {
   make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS -pthread" -j1
}