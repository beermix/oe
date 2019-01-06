PKG_NAME="gdbm"
PKG_VERSION="1.18.1"
PKG_URL="http://mirror.switch.ch/ftp/mirror/gnu/gdbm/gdbm-$PKG_VERSION.tar.gz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-libgdbm-compat --disable-shared"

PKG_CONFIGURE_OPTS_HOST="--enable-libgdbm-compat"

post_makeinstall_target() {
  rm -rf $INSTALL
}