PKG_NAME="gdbm"
PKG_VERSION="1.17"
PKG_URL="http://mirror.switch.ch/ftp/mirror/gnu/gdbm/gdbm-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-libgdbm-compat --disable-shared"
PKG_CONFIGURE_OPTS_HOST="--enable-libgdbm-compat"

post_makeinstall_target() {
  rm -rf $INSTALL
}