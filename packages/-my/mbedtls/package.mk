PKG_NAME="mbedtls"
PKG_VERSION="2.4.0"
PKG_URL="https://tls.mbed.org/download/mbedtls-$PKG_VERSION-gpl.tgz"
PKG_DEPENDS_TARGET="toolchain libz"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

strip_lto

PKG_CMAKE_OPTS_TARGET="-DENABLE_PROGRAMS=NO \
		       -DENABLE_TESTING=NO \
		       -DENABLE_zlib_SUPPORT=ON \
		       -DINSTALL_MBEDTLS_HEADERS=ON \
		       -DUSE_SHARED_MBEDTLS_LIBRARY=NO \
		       -DUSE_STATIC_MBEDTLS_LIBRARY=ON \
		       -DCMAKE_BUILD_TYPE=Release"