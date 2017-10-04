PKG_NAME="nghttp2"
PKG_VERSION="1.26.0"
PKG_SITE="https://github.com/nghttp2/nghttp2/releases/"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl libev zlib libxml2 c-ares"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-static \
			      --without-libxml2 \
			      --without-spdylay \
			      --without-neverbleed \
			      --without-jemalloc \
			      --disable-python-bindings \
			      --enable-app"
