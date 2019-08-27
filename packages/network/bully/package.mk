PKG_NAME="bully"
PKG_VERSION="17dda79"
PKG_URL="https://github.com/Taikson/bully/archive/${PKG_VERSION}.tar.gz"
#PKG_VERSION="17dda79"
#PKG_URL="https://github.com/aanarchyy/bully/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libpcap"

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