PKG_NAME="node"
PKG_VERSION="11.6.0"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/nodejs/node/releases"
PKG_URL="https://github.com/nodejs/node/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_SHORTDESC="Node.js JavaScript runtime"

PKG_CONFIGURE_OPTS_HOST="--prefix=$TOOLCHAIN \
                     --partly-static \
                     --with-intl=none \
                     --without-npm \
                     --without-ssl \
                     --without-snapshot \
                     --shared-zlib \
                     --without-dtrace \
                     --without-etw \
                     --dest-os=linux"
