PKG_NAME="libtasn1"
PKG_VERSION="4.9"
PKG_URL="http://ftpmirror.gnu.org/libtasn1/libtasn1-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static \
			      --disable-gtk-doc-html \
			      --disable-doc \
			      --disable-gcc-warnings \
			      --with-libgpg-error-prefix=$SYSROOT_PREFIX/usr"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
}