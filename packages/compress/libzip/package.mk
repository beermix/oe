PKG_NAME="libzip"
PKG_VERSION="1.5.2"
PKG_SHA256="b3de4d4bd49a01e0cab3507fc163f88e1651695b6b9cb25ad174dbe319d4a3b4"
PKG_SITE="http://www.nih.at/libzip/"
PKG_URL="http://www.nih.at/libzip/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_LONGDESC="libzip"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DBUILD_SHARED_LIBS=0 \
			  -DENABLE_COMMONCRYPTO=1 \
			  -DENABLE_GNUTLS=0 \
			  -DENABLE_OPENSSL=1"
			  
PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release \
			  -DBUILD_SHARED_LIBS=0 \
			  -DENABLE_COMMONCRYPTO=1 \
			  -DENABLE_GNUTLS=0 \
			  -DENABLE_OPENSSL=1"



