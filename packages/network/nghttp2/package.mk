PKG_NAME="nghttp2"
PKG_VERSION="1.26.0"
PKG_SITE="https://github.com/nghttp2/nghttp2/releases/"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libev libevent"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--with-spdylay=no \
			      --disable-examples \
			      --disable-python-bindings \
			      --enable-lib-only"
