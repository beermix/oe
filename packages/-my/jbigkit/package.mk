PKG_NAME="jbigkit"
PKG_VERSION="2.1"
PKG_URL="https://www.cl.cam.ac.uk/~mgk25/jbigkit/download/jbigkit-2.1.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses"

PKG_SECTION="python/system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


MAKEFLAGS="-j1"

make_target() {
  make prefix=/usr \
       CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS"
}

post_make_target() {
  mkdir -p $INSTALL/usr/lib
  mkdir -p $INSTALL/usr/bin
  
  $STRIP $ROOT/$PKG_BUILD/libjbig/libjbig.so
  $STRIP $ROOT/$PKG_BUILD/libjbig/libjbig85.so
  
  cp $ROOT/$PKG_BUILD/libjbig/libjbig.so $SYSROOT_PREFIX/usr/lib
  cp $ROOT/$PKG_BUILD/libjbig/libjbig85.so $SYSROOT_PREFIX/usr/lib
  
  cp $ROOT/$PKG_BUILD/libjbig/libjbig.so $INSTALL/usr/lib/
  cp $ROOT/$PKG_BUILD/libjbig/libjbig85.so $INSTALL/usr/lib/
  
  cp -fv $ROOT/$PKG_BUILD/libjbig/jbig.h $SYSROOT_PREFIX/usr/include/
  cp -fv $ROOT/$PKG_BUILD/libjbig/jbig85.h $SYSROOT_PREFIX/usr/include/
  cp -fv $ROOT/$PKG_BUILD/libjbig/jbig_ar.h $SYSROOT_PREFIX/usr/include/
}

makeinstall_target() {
  :
}