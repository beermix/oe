PKG_NAME="dash"
PKG_VERSION="0.5.9.1"
PKG_URL="http://ftp.osuosl.org/pub/blfs/svn/d/dash-0.5.9.1.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
			      --enable-fnmatch \
			      --without-libedit"

post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  ln -sfv dash $INSTALL/bin/sh
}