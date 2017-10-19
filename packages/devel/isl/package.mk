PKG_NAME="isl"
PKG_VERSION="0.18"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="gmp:host libtool:host intltool:host"
PKG_DEPENDS_TARGET="toolchain gmp"
PKG_SECTION="devel"

PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --with-gmp=$TOOLCHAIN"
