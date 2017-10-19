PKG_NAME="libssh2"
PKG_VERSION="1.8.0"
PKG_URL="https://www.libssh2.org/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SITE="https://www.libssh2.org/download/?C=M;O=D"
PKG_DEPENDS_TARGET="toolchain zlib openssl"

PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-libz \
			      --disable-silent-rules \
			      --disable-examples-build \
			      --disable-debug \
			      --with-pic \
			      --with-gnu-ld"
