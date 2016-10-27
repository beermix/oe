PKG_NAME="fdk-aac"
PKG_VERSION="15b128d"
PKG_URL="https://github.com/mstorsjo/fdk-aac/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --disable-silent-rules"