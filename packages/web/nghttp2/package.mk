PKG_NAME="nghttp2"
PKG_VERSION="1.33.0"
PKG_SITE="https://github.com/nghttp2/nghttp2/releases/"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libevent libev libuv"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="cmake-make"
#PKG_TOOLCHAIN="autotools"

PKG_CMAKE_OPTS_TARGET="-DENABLE_LIB_ONLY=1 \
			  -DENABLE_EXAMPLES=0 \
			  -DENABLE_PYTHON_BINDINGS=0 \
			  -DCMAKE_BUILD_TYPE=Release"

PKG_CONFIGURE_OPTS_TARGET="--disable-examples \
			      --disable-python-bindings \
			      --enable-lib-only"