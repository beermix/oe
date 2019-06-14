PKG_NAME="c-ares"
PKG_VERSION="1.14.0"
PKG_URL="https://c-ares.haxx.se/download/c-ares-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-pic"