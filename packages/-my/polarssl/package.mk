PKG_NAME="polarssl"
PKG_VERSION="1.3.9"
PKG_URL="https://tls.mbed.org/code/releases/polarssl-$PKG_VERSION-gpl.tgz"
PKG_DEPENDS_TARGET="toolchain zlib"

PKG_SECTION="my"

PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DENABLE_PROGRAMS=OFF \
		       -DENABLE_zlib_SUPPORT=OFF \
		       -DINSTALL_POLARSSL_HEADERS=ON \
		       -DUSE_SHARED_POLARSSL_LIBRARY=OFF \
		       -DUSE_STATIC_POLARSSL_LIBRARY=ON"