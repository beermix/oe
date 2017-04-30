PKG_NAME="gdbm"
PKG_VERSION="032805d"
PKG_GIT_URL="git://git.gnu.org.ua/gdbm.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

#post_makeinstall_target() {
#  rm -rf $INSTALL
#}