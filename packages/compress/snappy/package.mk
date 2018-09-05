PKG_NAME="snappy"
PKG_VERSION="ea660b5"
PKG_ARCH="any"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="https://github.com/google/snappy"
PKG_URL="https://github.com/google/snappy/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="compress"
PKG_SHORTDESC="fast real-time compression algorithm"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
 export CXXFLAGS="$CXXFLAGS -DNDEBUG"
}

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0"
