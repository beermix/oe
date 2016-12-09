PKG_NAME="redsocks2"
PKG_VERSION="03b4825"
PKG_GIT_URL="https://github.com/semigodking/redsocks"
PKG_DEPENDS_TARGET="toolchain openssl libevent"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAKE_OPTS_TARGET="CC=$CC ENABLE_STATIC=true"
#PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"

post_make_target() {
  mkdir -p $INSTALL/usr/bin
  cp -v redsocks2 $INSTALL/usr/bin/
}