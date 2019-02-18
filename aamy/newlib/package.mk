PKG_NAME="newlib"
PKG_VERSION="2.4.0.20160527"
PKG_URL="ftp://sourceware.org/pub/newlib/newlib-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain xz expat xz"

PKG_SECTION="x11/lib"




PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"
PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --with-gnu-ld"