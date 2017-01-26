PKG_NAME="dash"
PKG_VERSION="0.5.8"
PKG_URL="https://dl.dropboxusercontent.com/s/zkdi9mb1jffe6e5/dash_0.5.8.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

post_makeinstall_target() {
  ln -sfv dash $INSTALL/bin/sh
}