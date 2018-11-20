PKG_NAME="re2"
PKG_VERSION="2018-10-01"
PKG_SITE="https://github.com/google/re2/releases"
PKG_URL="https://github.com/google/re2/archive/$PKG_VERSION.tar.gz"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+piv"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=1 -DBUILD_TESTING=0 -DRE2_BUILD_TESTING=0 -DCMAKE_BUILD_TYPE=Release"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
  export RE2_LDFLAGS="$RE2_LDFLAGS $LDFLAGS"
}

makeinstall_target() {
   make prefix=/usr DESTDIR=$INSTALL install
   make prefix=/usr DESTDIR=$SYSROOT_PREFIX install
}