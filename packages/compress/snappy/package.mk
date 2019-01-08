PKG_NAME="snappy"
PKG_VERSION="ea660b5"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="https://github.com/google/snappy"
PKG_URL="https://github.com/google/snappy/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
#PKG_BUILD_FLAGS="+pic"
#PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
 export CXXFLAGS="$CXXFLAGS -DNDEBUG"
}

configure_package() {
  PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=1 -DCMAKE_BUILD_TYPE=Release"
}

post_makeinstall_target() {
 cp -r $PKG_DIR/src/snappy.pc  $SYSROOT_PREFIX/usr/lib/pkgconfig/
}