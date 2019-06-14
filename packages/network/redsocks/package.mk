PKG_NAME="redsocks"
PKG_VERSION="27b1788"
PKG_GIT_URL="https://github.com/darkk/redsocks"
PKG_DEPENDS_TARGET="toolchain openssl libevent"
PKG_SECTION="my"



make_target() {
  make -j1 \
       CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS" \
       ENABLE_STATIC=false
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin
  cp -v redsocks2 $INSTALL/usr/bin/
}