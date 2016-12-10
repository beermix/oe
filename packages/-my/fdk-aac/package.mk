PKG_NAME="fdk-aac"
PKG_VERSION="5fd7e65"
PKG_GIT_URL="https://github.com/mstorsjo/fdk-aac"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --disable-silent-rules"