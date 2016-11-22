PKG_NAME="libedit"
PKG_VERSION="20160903-3.1"
PKG_URL="http://thrysoee.dk/editline/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --enable-widec"