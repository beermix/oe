PKG_NAME="libXv"
PKG_VERSION="1.0.11"
PKG_URL="https://www.x.org/archive/individual/lib/libXv-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros xproto"

PKG_SECTION="x11/lib"
PKG_SHORTDESC="libXau: X authorization file management libary"
PKG_LONGDESC="X authorization file management libary"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-malloc0returnsnull --disable-shared --enable-static --with-gnu-ld"