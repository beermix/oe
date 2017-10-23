PKG_NAME="libunwind"
PKG_VERSION="1.2.1"
PKG_URL="http://download.savannah.gnu.org/releases/libunwind/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"
