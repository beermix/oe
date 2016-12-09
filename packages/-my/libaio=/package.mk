PKG_NAME="libaio"
PKG_VERSION="0.3.110"
PKG_URL="http://ftp.debian.org/debian/pool/main/liba/libaio/libaio_0.3.110.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make prefix=/usr \
       CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS"
}

post_make_target() {
  mkdir -p $INSTALL/usr/lib/
  cd $ROOT/$PKG_BUILD/src
  cp libaio.a $INSTALL/usr/lib/libaio.a
  cp libaio.so.1.0.1 $INSTALL/usr/lib/libaio.so.1
}
