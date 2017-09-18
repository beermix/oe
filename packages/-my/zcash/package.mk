PKG_NAME="zcash"
PKG_VERSION="v1.0.11"
PKG_GIT_URL="https://github.com/zcash/zcash"
PKG_DEPENDS_TARGET="toolchain glib libevent boost"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-wallet --disable-man --disable-debug --disable-mining"
