PKG_NAME="nghttp2"
PKG_VERSION="1.25.0"
PKG_SITE="https://github.com/nghttp2/nghttp2/releases/"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl libev zlib libxml2 jansson c-ares"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-libxml2 \
			      --without-jemalloc \
			      --disable-examples \
			      --with-spdylay=no \
			      --disable-python-bindings"
