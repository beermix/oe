PKG_NAME="bully"
PKG_VERSION="c110c39"
PKG_GIT_URL="https://github.com/aanarchyy/bully"
PKG_DEPENDS_TARGET="toolchain libpcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}

make_target() {
  make \
       CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS" \
       all -j1
}