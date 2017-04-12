PKG_NAME="libssh2"
PKG_VERSION="1.8.0"
PKG_URL="https://www.libssh2.org/download/libssh2-$PKG_VERSION.tar.gz"
#PKG_VERSION="323aa08"
#PKG_GIT_URL="https://github.com/libssh2/libssh2"
PKG_DEPENDS_TARGET="toolchain zlib openssl"

#PKG_IS_ADDON="no"
#PKG_USE_CMAKE="yes"
#PKG_AUTORECONF="no"
#
#PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
#			  -DBUILD_EXAMPLES=OFF \
#			  -DBUILD_SHARED_LIBS=OFF \
#			  -DBUILD_TESTING=OFF \
#			  -DCRYPTO_BACKEND=openssl \
#			  -DENABLE_GEX_NEW=OFF \
#			  -DENABLE_ZLIB_COMPRESSION=ON \
#			  -DENABLE_MAC_NONE=ON \
#			  -DENABLE_CRYPT_NONE=ON"
			  
			  
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-libz \
			      --disable-silent-rules \
			      --disable-examples-build \
			      --disable-debug"
