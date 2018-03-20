KG_NAME="libidn2"
PKG_VERSION="2.0.4"
PKG_URL="https://ftp.gnu.org/gnu/libidn/libidn2-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-pic"

