PKG_NAME="isl"
PKG_VERSION="0.17.1"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="gmp:host libtool:host intltool:host"
PKG_DEPENDS_TARGET=""
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--enable-static \
			 --disable-shared \
			 --with-gmp=$ROOT/$TOOLCHAIN \
			 --without-clang \
			 --disable-silent-rules \
			 --with-gcc-arch=corei7"