PKG_NAME="node"
PKG_VERSION="10.9.0"
#PKG_VERSION="8.11.4"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/nodejs/node/releases"
PKG_URL="https://github.com/nodejs/node/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_SHORTDESC="Node.js JavaScript runtime"
PKG_LONGDESC="Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient. The Node.js package ecosystem, npm, is the largest ecosystem of open source libraries in the world."

HOST_CONFIGURE_OPTS="--prefix=$TOOLCHAIN \
                     --fully-static \
                     --with-intl=none \
                     --without-npm \
                     --without-ssl \
                     --without-snapshot \
                     --shared-zlib \
                     --without-dtrace \
                     --without-etw \
                     --dest-os=linux"

pre_configure_host() {
  cd ..
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS
#  export LDFLAGS="-s" --partly-static --fully-static
}
