PKG_NAME="isl"
PKG_VERSION="0.16"
PKG_ARCH="any"
PKG_LICENSE="Custom"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="gmp:host libtool:host intltool:host"
PKG_DEPENDS_TARGET="toolchain gmp"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --without-clang --with-gnu-ld --with-gmp=$ROOT/$TOOLCHAIN"

pre_configure_host() {
  export CFLAGS="$CFLAGS -fPIC"
}
