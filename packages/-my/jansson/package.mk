PKG_NAME="jansson"
PKG_VERSION="2.8"
PKG_URL="http://www.digip.org/jansson/releases/jansson-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="service/system"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"
