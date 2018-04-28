PKG_NAME="isl"
PKG_VERSION="0.19"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="libtool:host intltool:host gmp:host"
PKG_SECTION="devel"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--with-gmp-prefix=$TOOLCHAIN --disable-silent-rules"
