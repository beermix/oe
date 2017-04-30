PKG_NAME="nghttp2"
PKG_VERSION="1.22.0"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib openssl libevent c-ares jemalloc libxml2 libev jansson asio"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DENABLE_LIB_ONLY=1 \
			  -DENABLE_EXAMPLES=0 \
			  -DENABLE_PYTHON_BINDINGS=0 \
			  -DENABLE_THREADS=1 \
			  -DWITH_SPDYLAY=0"

#--with-spdylay=no --disable-examples --disable-python-bindings