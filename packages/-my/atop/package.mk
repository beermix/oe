PKG_NAME="atop"
PKG_VERSION="2.3.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain hwloc"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="no"

make_target() {
  make CC="$CC" AR="$AR" CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="-lcurses -lterminfo $LDFLAGS" -j1
}