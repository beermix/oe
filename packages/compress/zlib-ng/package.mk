PKG_NAME="zlib-ng"
PKG_VERSION="e07a52d"
PKG_URL="https://github.com/Dead2/zlib-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_DEPENDS_HOST=""
PKG_SECTION="compress"
PKG_AUTORECONF="no"
PKG_USE_CMAKE="no"
PKG_USE_NINJA="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"
PKG_CMAKE_OPTS_HOST="-DWITH_NATIVE_INSTRUCTIONS=ON -DZLIB_COMPAT=ON -DWITH_GZFILEOP=ON"

pre_configure_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -r -i $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME/
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./configure --prefix=/
}

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -r -i $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  ./configure --prefix=/usr --zlib-compat --64
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./configure --prefix=/usr --libdir=$TOOLCHAIN/lib --zlib-compat --64
}
