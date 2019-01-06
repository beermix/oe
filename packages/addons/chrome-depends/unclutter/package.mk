PKG_NAME="unclutter"
PKG_VERSION="1.09"
PKG_SHA256="3a53575fe2a75a34bc9a2b0ad92ee0f8a7dbedc05d8783f191c500060a40a9bd"
PKG_LICENSE="Public Domain"
PKG_SITE="https://sourceforge.net/projects/unclutter/"
PKG_URL="http://jaist.dl.sourceforge.net/project/unclutter/unclutter/source_$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
#PKG_DEPENDS_TARGET="toolchain libX11"

make_target() {
  rm -f Makefile
  LDFLAGS="-lX11" $MAKE unclutter
}

makeinstall_target() {
  mkdir -p .install_pkg/usr/bin
  install -m 755 unclutter .install_pkg/usr/bin/
}
