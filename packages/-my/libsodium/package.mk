PKG_NAME="libsodium"
PKG_VERSION="1.0.11"
PKG_GIT_URL="https://github.com/jedisct1/libsodium"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --disable-ssp --enable-minimal=yes -with-gnu-ld"