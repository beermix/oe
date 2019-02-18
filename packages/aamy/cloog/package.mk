PKG_NAME="cloog"
PKG_VERSION="0.18.4"
PKG_URL="http://www.bastoul.net/cloog/pages/download/cloog-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="isl:host"
PKG_SECTION="devel"



PKG_CONFIGURE_OPTS_HOST="--with-polylib=no --with-isl=$TOOLCHAIN"

