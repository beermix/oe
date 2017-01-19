PKG_NAME="re2c"
PKG_VERSION="0.16"
#PKG_VERSION="0def065"
PKG_GIT_URL="https://github.com/skvadrik/re2c"
PKG_DEPENDS_HOST="bison:host"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

post_unpack() {
  cp -r $PKG_BUILD/re2c/* $PKG_BUILD/
}

PKG_CONFIGURE_OPTS_HOST="--disable-docs"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"