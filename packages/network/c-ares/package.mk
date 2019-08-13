PKG_NAME="c-ares"
PKG_VERSION="1.14.0"
PKG_SHA256="45d3c1fd29263ceec2afc8ff9cd06d5f8f889636eb4e80ce3cc7f0eaf7aadc6e"
PKG_URL="https://c-ares.haxx.se/download/c-ares-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"

PKG_CMAKE_OPTS_TARGET="-DCARES_SHARED=OFF -DCARES_STATIC=ON -DCARES_STATIC_PIC=ON"