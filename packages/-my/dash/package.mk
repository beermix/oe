PKG_NAME="dash"
PKG_VERSION="0.5.8"
PKG_URL="https://dl.dropboxusercontent.com/s/zkdi9mb1jffe6e5/dash_0.5.8.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
			      --enable-fnmatch \
			      --without-libedit"

post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  ln -sfv dash $INSTALL/bin/sh
}