PKG_NAME="gdbm"
PKG_VERSION="1.13"
PKG_URL="http://mirror.switch.ch/ftp/mirror/gnu/gdbm/gdbm-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld"

post_makeinstall_target() {
  rm -rf $INSTALL
}