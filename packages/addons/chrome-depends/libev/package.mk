PKG_NAME="libev"
PKG_VERSION="4.27"
PKG_SHA256="2d5526fc8da4f072dd5c73e18fbb1666f5ef8ed78b73bba12e195cfdd810344e"
PKG_LICENSE="GPL"
PKG_SITE="http://software.schmorp.de/pkg/libev.html"
PKG_URL="http://dist.schmorp.de/libev/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
