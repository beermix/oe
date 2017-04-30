PKG_NAME="nghttp2"
PKG_VERSION="test"
PKG_URL="https://dl.dropboxusercontent.com/s/7c3zdcpnntv2x6u/nghttp-test.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib openssl libevent c-ares jemalloc libxml2 libev jansson asio"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DENABLE_LIB_ONLY=1 \
			  -DENABLE_EXAMPLES=0 \
			  -DENABLE_PYTHON_BINDINGS=0 \
			  -DENABLE_THREADS=1 \
			  -DWITH_SPDYLAY=0"