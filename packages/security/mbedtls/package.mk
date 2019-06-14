PKG_NAME="mbedtls"
PKG_VERSION="2.16.1"
PKG_URL="https://tls.mbed.org/download/mbedtls-$PKG_VERSION-gpl.tgz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DENABLE_PROGRAMS=0 \
			  -DENABLE_TESTING=0 \
			  -DUSE_SHARED_MBEDTLS_LIBRARY=0 \
			  -DUSE_STATIC_MBEDTLS_LIBRARY=1"
