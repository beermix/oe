PKG_NAME="libbsd"
PKG_VERSION="0.8.3"
PKG_URL="https://dl.dropboxusercontent.com/s/g6k55pdps8bcb7a/libbsd-0.8.3.tar.xz"
PKG_DEPENDS_HOST="bison:host flex:host"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-pic --with-gnu-ld"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --with-pic --with-gnu-ld"

