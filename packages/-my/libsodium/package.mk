PKG_NAME="libsodium"
PKG_VERSION="af97ac7"
PKG_SITE="https://github.com/jedisct1/libsodium/tree/stable"
PKG_GIT_URL="https://github.com/jedisct1/libsodium"
PKG_GIT_BRANCH="stable"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-minimal --with-pic"