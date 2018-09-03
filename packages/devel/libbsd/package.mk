PKG_NAME="libbsd"
PKG_VERSION="0.9.1"
PKG_URL="https://libbsd.freedesktop.org/releases/libbsd-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="bison:host flex:host"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-pic --with-gnu-ld"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"

