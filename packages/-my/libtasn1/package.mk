PKG_NAME="libtasn1"
PKG_VERSION="4.12"
PKG_URL="http://ftpmirror.gnu.org/libtasn1/libtasn1-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain help2man:host" 
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --disable-gtk-doc-html --disable-gcc-warnings --with-gnu-ld"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
}
