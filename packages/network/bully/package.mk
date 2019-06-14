PKG_NAME="bully"
PKG_VERSION="17dda79"
PKG_GIT_URL="https://github.com/Taikson/bully"
#PKG_VERSION="17dda79"
#PKG_GIT_URL="https://github.com/aanarchyy/bully"
PKG_DEPENDS_TARGET="toolchain libpcap"
PKG_SECTION="my"

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