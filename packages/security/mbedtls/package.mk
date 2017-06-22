PKG_NAME="mbedtls"
PKG_VERSION="2.5.1"
PKG_URL="https://tls.mbed.org/download/mbedtls-$PKG_VERSION-gpl.tgz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DENABLE_PROGRAMS=0 \
			  -DENABLE_TESTING=0 \
			  -DUSE_SHARED_MBEDTLS_LIBRARY=0 \
			  -DUSE_STATIC_MBEDTLS_LIBRARY=1"
			  
PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"