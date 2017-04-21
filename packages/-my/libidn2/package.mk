KG_NAME="libidn2"
PKG_VERSION="2.0.0"
PKG_URL="ftp://alpha.gnu.org/gnu/libidn/libidn2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --disable-java"