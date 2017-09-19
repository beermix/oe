PKG_NAME="libssh2"
PKG_VERSION="libssh2-1.8.0"
PKG_SITE="https://www.libssh2.org/download/?C=M;O=D"
#PKG_URL="https://www.libssh2.org/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_GIT_URL="https://github.com/libssh2/libssh2"
PKG_DEPENDS_TARGET="toolchain zlib openssl mbedtls"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}

PKG_CMAKE_OPTS_TARGET="-DBUILD_EXAMPLES=OFF \
			  -DBUILD_SHARED_LIBS=OFF \
			  -DBUILD_TESTING=OFF \
			  -DENABLE_GEX_NEW=OFF \
			  -DCRYPTO_BACKEND="mbedTLS" \
			  -DENABLE_ZLIB_COMPRESSION=ON \
			  -DENABLE_MAC_NONE=ON \
			  -DENABLE_CRYPT_NONE=ON -DCMAKE_BUILD_TYPE=Release"