PKG_NAME="libsodium"
PKG_VERSION="1.0.17"
PKG_SITE="https://github.com/jedisct1/libsodium/tree/stable"
PKG_URL="https://github.com/jedisct1/libsodium/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-minimal"