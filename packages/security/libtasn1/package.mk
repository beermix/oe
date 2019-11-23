PKG_NAME="libtasn1"
PKG_VERSION="4.15"
PKG_SHA256=""
PKG_URL="https://ftp.gnu.org/gnu/libtasn1/libtasn1-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static \
			      --disable-gtk-doc-html \
			      --disable-doc \
			      --disable-gcc-warnings \
			      --with-libgpg-error-prefix=$SYSROOT_PREFIX/usr"

