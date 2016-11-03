PKG_NAME="libssh2"
PKG_VERSION="1.8.0"
PKG_ARCH="any"
PKG_URL="https://www.libssh2.org/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libz libgpg-error openssl"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_EXAMPLES=OFF \
		       -DBUILD_SHARED_LIBS=OFF \
		       -DBUILD_TESTING=OFF \
		       -DCRYPTO_BACKEND=OpenSSL \
		       -DENABLE_GEX_NEW=OFF \
		       -DENABLE_zlib_COMPRESSION=ON"