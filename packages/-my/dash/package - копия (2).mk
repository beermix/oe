PKG_NAME="dash"
PKG_VERSION="0.5.8"
PKG_URL="https://dl.dropboxusercontent.com/s/zkdi9mb1jffe6e5/dash_0.5.8.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
			      --enable-fnmatch \
			      --without-libedit \
			      --enable-glob"
	      
post_makeinstall_target() {
  mv $INSTALL/bin/dash $INSTALL/bin/sh
}