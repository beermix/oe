PKG_NAME="libssh2"
PKG_VERSION="1.7.0"
PKG_ARCH="any"
PKG_URL="https://www.libssh2.org/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libz libgpg-error openssl"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --with-libz \
			   --with-gnu-ld \
			   --with-libgcrypt \
			   --with-openssl \
			   --disable-examples-build \
			   --disable-debug"