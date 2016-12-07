PKG_NAME="libsodium"
PKG_VERSION="f42c366"
PKG_GIT_URL="https://github.com/jedisct1/libsodium"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --disable-ssp"