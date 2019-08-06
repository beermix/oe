PKG_NAME="re2c"
PKG_VERSION="1.2"
PKG_SHA256="000b7b8c3aeaf61fb492b58352574a5777518336fc96071f4d083a7397be841c"
PKG_SITE="https://github.com/skvadrik/re2c/releases/"
PKG_URL="https://github.com/skvadrik/re2c/releases/download/$PKG_VERSION/re2c-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="bison:host autotools:host"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-docs"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"