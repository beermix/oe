PKG_NAME="nghttp2"
PKG_VERSION="1.29.0"
PKG_SITE="https://github.com/nghttp2/nghttp2/releases/"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DENABLE_LIB_ONLY=1 \
			  -DENABLE_EXAMPLES=0 \
			  -DENABLE_PYTHON_BINDINGS=0 \
			  -DENABLE_THREADS=1 \
			  -DWITH_SPDYLAY=0"