PKG_NAME="libssh2"
PKG_VERSION="1.9.0"
PKG_SITE="https://github.com/libssh2/libssh2"
PKG_URL="https://github.com/libssh2/libssh2/releases/download/libssh2-$PKG_VERSION/libssh2-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_TOOLCHAIN="cmake-make"
#PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-libz \
			      --disable-examples-build \
			      --disable-debug \
			      --with-gnu-ld"

PKG_CMAKE_OPTS_TARGET="-DBUILD_EXAMPLES=0 \
			  -DBUILD_SHARED_LIBS=0 \
			  -DENABLE_ZLIB_COMPRESSION=1"
