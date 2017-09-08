PKG_NAME="libtasn1"
PKG_VERSION="4.9"
PKG_URL="http://ftpmirror.gnu.org/libtasn1/libtasn1-$PKG_VERSION.tar.gz"
#PKG_DEPENDS_TARGET="toolchain help2man:host"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --disable-nls --disable-gtk-doc-html"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
}
