PKG_NAME="libssh2"
PKG_VERSION="1.8.0"
PKG_URL="https://www.libssh2.org/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SITE="https://www.libssh2.org/download/?C=M;O=D"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-libz \
			      --enable-silent-rules \
			      --disable-examples-build \
			      --disable-debug \
			      --with-gnu-ld"
