PKG_NAME="minicom"
PKG_VERSION="2.7.1"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain expat openssl libevent libsodium"
PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared"