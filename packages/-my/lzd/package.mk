PKG_NAME="lzd"
PKG_VERSION="0.9"
PKG_URL="http://download.savannah.gnu.org/releases/lzip/lzd/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain lzo tar"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


MAKEFLAGS="-j1"

make_target() {
make CC="$CC" AR="$AR r" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS"
}