KG_NAME="libidn2"
PKG_VERSION="2.0.4"
PKG_URL="https://ftp.gnu.org/gnu/libidn/libidn2-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-java --disable-shared --with-pic"