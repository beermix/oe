PKG_NAME="dash"
PKG_VERSION="0.5.9.1"
PKG_URL="http://ftp.osuosl.org/pub/blfs/svn/d/dash-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CONCURRENCY_MAKE_LEVEL=1

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin"

post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  #ln -sfv dash $INSTALL/bin/sh
}