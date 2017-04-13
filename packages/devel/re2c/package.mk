PKG_NAME="re2c"
PKG_VERSION="a0f8c13"
PKG_GIT_URL="https://github.com/skvadrik/re2c"
PKG_DEPENDS_HOST="bison:host"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

post_unpack() {
  cp -r $PKG_BUILD/re2c/* $PKG_BUILD/
}

PKG_CONFIGURE_OPTS_HOST="--disable-docs"

PKG_CONFIGURE_OPTS_TARGET="--disable-docs"