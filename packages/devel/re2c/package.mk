PKG_NAME="re2c"
PKG_VERSION="1.3"
PKG_SHA256="f37f25ff760e90088e7d03d1232002c2c2672646d5844fdf8e0d51a5cd75a503"
PKG_SITE="https://github.com/skvadrik/re2c/releases"
PKG_URL="https://github.com/skvadrik/re2c/releases/download/$PKG_VERSION/re2c-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="bison:host autotools:host"

PKG_CONFIGURE_OPTS_HOST="--disable-docs"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"