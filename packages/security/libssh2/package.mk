PKG_NAME="libssh2"
PKG_VERSION="1.8.0"
PKG_SITE="https://www.libssh2.org/download/?C=M;O=D"
PKG_URL="https://www.libssh2.org/download/libssh2-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-libz \
			      --disable-silent-rules \
			      --disable-examples-build \
			      --disable-debug \
			      --with-gnu-ld"
