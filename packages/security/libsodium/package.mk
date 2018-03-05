PKG_NAME="libsodium"
PKG_VERSION="b862bf0"
PKG_SITE="https://github.com/jedisct1/libsodium/tree/stable"
PKG_URL="https://github.com/jedisct1/libsodium/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-minimal --with-pic"