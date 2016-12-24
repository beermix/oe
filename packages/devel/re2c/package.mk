PKG_NAME="re2c"
PKG_VERSION="0.16"
PKG_GIT_URL="https://github.com/skvadrik/re2c"
PKG_DEPENDS_HOST="bison:host"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  cp -r $PKG_BUILD/re2c/* $PKG_BUILD/
}

PKG_CONFIGURE_OPTS_HOST="--disable-docs --disable-silent-rules"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"