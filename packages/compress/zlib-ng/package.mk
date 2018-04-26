PKG_NAME="zlib-ng"
PKG_VERSION="df1fd15"
PKG_URL="https://github.com/Dead2/zlib-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_DEPENDS_HOST=""
PKG_SECTION="compress"
PKG_TOOLCHAIN="configure"

TARGET_CONFIGURE_OPTS="--prefix=/usr"
HOST_CONFIGURE_OPTS="--prefix=$TOOLCHAIN"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_build_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
}

pre_configure_target() {
 export CFLAGS="$CFLAGS -O3 -fPIC"
 export CXXFLAGS="$CXXFLAGS -O3 -fPIC"
}