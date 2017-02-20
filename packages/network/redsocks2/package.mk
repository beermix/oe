PKG_NAME="redsocks2"
PKG_VERSION="bc2706a"
PKG_GIT_URL="https://github.com/semigodking/redsocks"
PKG_DEPENDS_TARGET="toolchain openssl libevent"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#PKG_MAKE_OPTS_TARGET="CC=$CC ENABLE_STATIC=FALSE"
#PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"

make_target() {
  make \
       CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS" \
       all -j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin
  cp -v redsocks2 $INSTALL/usr/bin/
}