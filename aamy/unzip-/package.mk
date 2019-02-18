PKG_NAME="unzip"
PKG_VERSION="6.0"
PKG_URL="http://ftpmirror.gnu.org/tar/tar-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"


PKG_TOOLCHAIN="autotools"

CFLAGS="$CFLAGS -fPIC -DPIC"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"