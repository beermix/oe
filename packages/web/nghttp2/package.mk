PKG_NAME="nghttp2"
PKG_VERSION="1.22.0"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib openssl libaio libevent c-ares jemalloc libxml2 libev jansson"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --with-libxml2 \
			      --with-sysroot=$SYSROOT_PREFIX \
			      --with-jemalloc \
			      --disable-examples \
			      --disable-python-bindings"

#PKG_CMAKE_OPTS_TARGET="-DENABLE_LIB_ONLY=1 -DENABLE_EXAMPLES=0 -DENABLE_PYTHON_BINDINGS=0 -DENABLE_THREADS=1 -DWITH_SPDYLAY=0"