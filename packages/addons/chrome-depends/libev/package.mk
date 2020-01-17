PKG_NAME="libev"
PKG_VERSION="4.31"
PKG_SHA256="ed855d2b52118e32c0c1a6a32bd18c97f9e6711ca511f5ee12de3b9eccc66e5a"
PKG_LICENSE="GPL"
PKG_SITE="http://software.schmorp.de/pkg/libev.html"
PKG_URL="http://dist.schmorp.de/libev/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
