PKG_NAME="alac"
PKG_VERSION="a18c8a6"
PKG_URL="https://github.com/alicebob/alac/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --disable-silent-rules"