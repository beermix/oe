PKG_NAME="isl"
PKG_VERSION="0.18"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="gmp:host libtool:host intltool:host"
PKG_DEPENDS_TARGET="toolchain gmp"
PKG_SECTION="devel"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--enable-static \
			    --disable-shared \
			    --with-int=gmp \
			    --with-gmp=system \
			    --with-gmp-prefix=$TOOLCHAIN \
			    --with-gcc-arch=$TARGET_ARCH \
			    --with-clang=no \
			    --with-pic"
