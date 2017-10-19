PKG_NAME="lzip"
PKG_VERSION="1.18"
PKG_URL="http://download.savannah.gnu.org/releases/lzip/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain lzo"
PKG_SECTION="network"

PKG_AUTORECONF="no"

make_target() {
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS -DDEBUG=0"
}