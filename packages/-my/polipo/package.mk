PKG_NAME="polipo"
PKG_VERSION="ab52932"
PKG_GIT_URL="https://github.com/jech/polipo"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="service/proxy"


pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|g"`
}

make_target() {
  make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS -lpthread"
}

install_target(){
:
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL_DEV/usr/bin/
  cp $PKG_BUILD/polipo $INSTALL/usr/bin/
}
