PKG_NAME="redsocks2"
PKG_VERSION="3052eea"
PKG_GIT_URL="https://github.com/semigodking/redsocks"
PKG_DEPENDS_TARGET="toolchain openssl libevent"
PKG_SECTION="my"



make_target() {
  make CC="$CC" CXX="$CXX" AR="$AR" CFLAGS="-Wall $CFLAGS" CXXFLAGS="-Wall $CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" -j3
}
#       ENABLE_STATIC=true

post_make_target() {
  mkdir -p $INSTALL/usr/bin
  cp -v redsocks2 $INSTALL/usr/bin/
}