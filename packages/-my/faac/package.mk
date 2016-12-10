PKG_NAME="faac"
PKG_VERSION="1.28"
PKG_URL="$SOURCEFORGE_SRC/faac/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --without-mp4v2"