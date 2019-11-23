PKG_NAME="libtasn1"
PKG_VERSION="4.15.0"
PKG_SHA256="dd77509fe8f5304deafbca654dc7f0ea57f5841f41ba530cff9a5bf71382739e"
PKG_URL="https://ftp.gnu.org/gnu/libtasn1/libtasn1-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static \
			      --disable-gtk-doc-html \
			      --disable-doc \
			      --with-libgpg-error-prefix=$SYSROOT_PREFIX/usr"

