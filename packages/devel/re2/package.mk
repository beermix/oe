PKG_NAME="re2"
PKG_VERSION="d2b6395"
PKG_GIT_URL="https://github.com/google/re2"
PKG_DEPENDS_HOST=""
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0 -DBUILD_TESTING=0"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
}