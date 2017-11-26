PKG_NAME="oggfwd"
PKG_VERSION="506088e"
PKG_GIT_URL="https://r-w-x.org/oggfwd.git"
PKG_DEPENDS_TARGET="toolchain libshout libogg libvorbis libtheora"
PKG_SECTION="tools"


make_target() {
  strip_lto
  make CC="$CC" CXX="$CXX" AR="$AR" CFLAGS="-O2 -pipe -fstack-protector-strong -DDEBUG=0" CPPFLAGS="$CPPFLAGS" -j1
}


post_make_target() {
  mkdir -p $INSTALL/usr/sbin/
  mkdir -p $INSTALL_DEV/usr/sbin/
  cp $PKG_BUILD/ps3remote $INSTALL/usr/sbin/
}


makeinstall_target() {
  :
}