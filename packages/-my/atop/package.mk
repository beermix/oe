PKG_NAME="atop"
PKG_VERSION="fa4db43"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/Atoptool/atop/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain systemd"

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $PKG_BUILD/atop $INSTALL/usr/bin/
}
