PKG_NAME="bzip2"
PKG_VERSION="3ac9ab1"
PKG_SHA256="b43e8df05b0f3c3684e0a6b9a27e3874b3495ed317e5e2cb69303e9a8f1c4725"
PKG_SITE="https://github.com/sspring/bzip2_cmake"
PKG_URL="https://github.com/sspring/bzip2_cmake/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain bzip2:host"
PKG_TOOLCHAIN="cmake-make"
#PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share
  ln -snf libbz2.so $INSTALL/usr/lib/libbz2.so.1.0
  ln -snf libbz2.so $INSTALL/usr/lib/libbz2.so.1.0.4
}