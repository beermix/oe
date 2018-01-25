PKG_NAME="atop"
PKG_VERSION="2.3.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain systemd"
PKG_SECTION="debug/tools"
PKG_TOOLCHAIN="manual"

make_target() {
  make CC="$CC" AR="$AR" CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" -j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL_DEV/usr/bin/
  cp $PKG_BUILD/atop $INSTALL/usr/bin/
}
