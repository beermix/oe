PKG_NAME="re2c"
PKG_VERSION="1.1.1"
PKG_SITE="https://github.com/skvadrik/re2c/releases/"
PKG_URL="https://github.com/skvadrik/re2c/releases/download/$PKG_VERSION/re2c-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="bison:host autotools:host"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-docs"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"