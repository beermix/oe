PKG_NAME="isl"
PKG_VERSION="0.16.1"
#PKG_VERSION="0.20"
PKG_URL="http://isl.gforge.inria.fr/isl-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="libtool:host intltool:host gmp:host"
PKG_SECTION="devel"

pre_configure_host() {
  unset CFLAGS
}

PKG_CONFIGURE_OPTS_HOST="--with-gmp-prefix=$TOOLCHAIN --disable-silent-rules --disable-shared"
