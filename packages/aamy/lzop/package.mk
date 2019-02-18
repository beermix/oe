PKG_NAME="lzip"
PKG_VERSION="1.03"
PKG_URL="http://www.lzop.org/download/lzop-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain lzo"
PKG_SECTION="network"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --prefix=/usr"
PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --prefix=/usr"
