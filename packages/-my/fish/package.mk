PKG_NAME="fish"
PKG_VERSION="2.2.0"
PKG_URL="http://fishshell.com/files/2.2.0/fish-2.2.0.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain ncurses"

PKG_SECTION="devel"


pre_configure_target() {
  cd $PKG_BUILD
  ./configure   --prefix=/usr  --sysconfdir=/storage/.config  --datarootdir=/storage/.config/fish/share
}


#post_makeinstall_target() {
#  rm -rf $INSTALL/storage/
#}
