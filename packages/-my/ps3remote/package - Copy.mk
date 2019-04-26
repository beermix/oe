PKG_NAME="ps3remote"
PKG_VERSION="7d20fa3e"
PKG_GIT_URL="https://github.com/rootlis/ps3remote"
PKG_DEPENDS_TARGET="toolchain systemd"
PKG_SECTION="my"



CONCURRENCY_MAKE_LEVEL=1

pre_configure_target() {
  strip_lto
  strip_gold
}

make_target() {
  make CC="$CC" CXX="$CXX" AR="$AR" CFLAGS="-Wall -DDEBUG=0 $CFLAGS" CXXFLAGS="-Wall $CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL_DEV/usr/bin/
  $STRIP $PKG_BUILD/ps3remote
  cp $PKG_BUILD/ps3remote $INSTALL/usr/bin/
}

makeinstall_target() {
  :
}

post_install () {
  enable_service ps3remote.service
}