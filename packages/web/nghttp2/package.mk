PKG_NAME="nghttp2"
PKG_VERSION="1.38.0"
PKG_SHA256="ef75c761858241c6b4372fa6397aa0481a984b84b7b07c4ec7dc2d7b9eee87f8"
PKG_SITE="https://github.com/nghttp2/nghttp2/releases/"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libevent libev libuv"
PKG_DEPENDS_TARGET="toolchain"

PKG_CMAKE_OPTS_TARGET="-DENABLE_LIB_ONLY=1 -DCMAKE_BUILD_TYPE=Release"