PKG_NAME="re2"
PKG_VERSION="2019-08-01"
PKG_SITE="https://github.com/google/re2/releases"
PKG_URL="https://github.com/google/re2/archive/$PKG_VERSION.tar.gz"
PKG_TOOLCHAIN="manual"
#PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="-lto -gold -hardening"
#PKG_BUILD_FLAGS="+pic"

configure_package() {
  PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=1 -DCMAKE_VERBOSE_MAKEFILE=ON"
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
  export LDFLAGS="$LDFLAGS $RE2_LDFLAGS"
  export CXXFLAGS="$CXXFLAGS $RE2_CXXFLAGS"
}

makeinstall_target() {
   make prefix=/usr DESTDIR=$INSTALL install
   make prefix=/usr DESTDIR=$SYSROOT_PREFIX install
}