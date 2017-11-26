PKG_NAME="pk"
PKG_VERSION="master"
PKG_URL="https://github.com/pancakeio/pk/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"

PKG_SECTION="security"


make_target() {
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS -DDEBUG=0"
}