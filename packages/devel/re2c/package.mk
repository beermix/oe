PKG_NAME="re2c"
PKG_VERSION="1.0.3"
PKG_URL="https://github.com/skvadrik/re2c/releases/download/$PKG_VERSION/re2c-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="bison:host"
PKG_SECTION="devel"


PKG_CONFIGURE_OPTS_HOST="--disable-docs"
PKG_CONFIGURE_OPTS_TARGET="--disable-docs"