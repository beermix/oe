PKG_NAME="jansson"
PKG_VERSION="2.9"
PKG_URL="http://www.digip.org/jansson/releases/jansson-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"
