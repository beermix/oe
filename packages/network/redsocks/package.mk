PKG_NAME="redsocks"
PKG_VERSION="78a73fc"
PKG_GIT_URL="https://github.com/darkk/redsocks"
PKG_DEPENDS_TARGET="toolchain openssl libevent"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAKE_OPTS_TARGET="CC=$CC ENABLE_STATIC=true"
#PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"

post_make_target() {
  mkdir -p $INSTALL/usr/bin
  cp -v redsocks $INSTALL/usr/bin/
}