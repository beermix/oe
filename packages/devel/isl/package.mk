PKG_NAME="isl"
PKG_VERSION="0.18"
PKG_ARCH="any"
PKG_LICENSE="Custom"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="gmp:host libtool:host intltool:host"
PKG_DEPENDS_TARGET="toolchain gmp"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --without-clang --with-gmp=$ROOT/$TOOLCHAIN"
			 
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"