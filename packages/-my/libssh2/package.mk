PKG_NAME="libssh2"
PKG_VERSION="1.8.0"
PKG_ARCH="any"
PKG_URL="https://www.libssh2.org/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libz mbedtls"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared \
			   --enable-static \
			   --without-libz \
			   --with-mbedtls=$SYSROOT_PREFIX/usr \
			   --disable-silent-rules \
			   --disable-examples-build \
			   --disable-debug"
