PKG_NAME="re2"
PKG_VERSION="2018-10-01"
PKG_SITE="https://github.com/google/re2/releases"
PKG_URL="https://github.com/google/re2/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
#PKG_BUILD_FLAGS="+pic +hardening"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=1 -DCMAKE_BUILD_TYPE=Release"