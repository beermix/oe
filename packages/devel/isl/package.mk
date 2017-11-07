PKG_NAME="isl"
PKG_VERSION="0.18"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="libtool:host intltool:host gmp:host"
PKG_SECTION="devel"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --with-gmp-prefix=$TOOLCHAIN"
