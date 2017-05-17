PKG_NAME="re2"
PKG_VERSION="2017-05-01"
PKG_GIT_URL="https://github.com/google/re2"
PKG_DEPENDS_HOST=""
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 -DBUILD_TESTING=0"

PKG_CMAKE_OPTS_HOST="-DBUILD_SHARED_LIBS=0 -DBUILD_TESTING=0"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  export CC="$CC"
  export CXX="$CXX"
  export AR="$AR"
  export NM="$NM"
  export LDFLAGS="$LDFLAGS -lpcre -lpthread -lstdc++"
  export CFLAGS="$CFLAGS"
  export CPPFLAGS="$CPPFLAGS"
  export CXXFLAGS="$CXXFLAGS"
}