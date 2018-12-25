PKG_NAME="libssh2"
PKG_VERSION="31aea1e"
PKG_URL="https://github.com/libssh2/libssh2/archive/$PKG_VERSION.tar.gz"
#PKG_SITE="https://www.libssh2.org/download/?C=M;O=D"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-libz \
			      --disable-examples-build \
			      --disable-debug \
			      --with-gnu-ld"
