PKG_NAME="fdk-aac"
PKG_VERSION="5eb6f0d"
PKG_GIT_URL="https://github.com/mstorsjo/fdk-aac"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared"