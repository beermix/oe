PKG_NAME="lzip"
PKG_VERSION="1.18"
PKG_URL="http://download.savannah.gnu.org/releases/lzip/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain lzo"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --prefix=/usr"
PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --prefix=/usr"

make_target() {
make CC=x86_64-libreelec-linux-gnu-g++ AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" -j1
}