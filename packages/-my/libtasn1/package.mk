PKG_NAME="libtasn1"
PKG_VERSION="4.9"
PKG_URL="http://ftpmirror.gnu.org/libtasn1/libtasn1-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain" 

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
