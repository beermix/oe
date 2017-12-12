PKG_NAME="libsodium"
PKG_VERSION="1.0.15"
PKG_SITE="https://github.com/jedisct1/libsodium/tree/stable"
PKG_URL="https://github.com/jedisct1/libsodium/releases/download/$PKG_VERSION/libsodium-$PKG_VERSION.tar.gz"
PKG_GIT_BRANCH="stable"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-minimal --with-pic"