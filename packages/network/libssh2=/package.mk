PKG_NAME="libssh2"
PKG_VERSION="dd74f24"
PKG_URL="https://github.com/libssh2/libssh2/archive/$PKG_VERSION.tar.gz"
#PKG_SITE="https://www.libssh2.org/download/?C=M;O=D"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_TOOLCHAIN="cmake-make"
#PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-libz \
			      --disable-examples-build \
			      --disable-debug \
			      --with-gnu-ld"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DBUILD_EXAMPLES=0 \
			  -DBUILD_SHARED_LIBS=0 \
			  -DBUILD_TESTING=0 \
			  -DENABLE_ZLIB_COMPRESSION=1"