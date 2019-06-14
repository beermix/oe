PKG_NAME="libtasn1"
PKG_VERSION="4.13"
PKG_URL="https://ftp.gnu.org/gnu/libtasn1/libtasn1-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_SECTION="my"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static \
			      --disable-gtk-doc-html \
			      --disable-doc \
			      --disable-gcc-warnings \
			      --with-libgpg-error-prefix=$SYSROOT_PREFIX/usr"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC -DPIC"
}
