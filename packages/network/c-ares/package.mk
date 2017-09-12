PKG_NAME="c-ares"
PKG_VERSION="1.13.0"
PKG_URL="https://c-ares.haxx.se/download/c-ares-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_USE_CMAKE="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-pic --with-random=/dev/urandom"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DCARES_SHARED=0 -DCARES_STATIC=1"
PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DCARES_SHARED=0 -DCARES_STATIC=1"

post_makeinstall_target() {
  rm -rf $INSTALL
}
