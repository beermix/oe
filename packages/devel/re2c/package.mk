PKG_NAME="re2c"
PKG_VERSION="0def065"
PKG_GIT_URL="https://github.com/skvadrik/re2c"
PKG_DEPENDS_HOST="bison:host"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


post_unpack() {
  cp -r $PKG_BUILD/re2c/* $PKG_BUILD/
}