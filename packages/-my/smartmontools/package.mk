PKG_NAME="smartmontools"
PKG_VERSION="4db810c"
PKG_GIT_URL="https://github.com/mirror/smartmontools"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config/smartmontools \
			      --datarootdir=/storage/.config/smartmontools/share \
			      --disable-silent-rules"

#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#  rm -rf $INSTALL/usr/lib
#}

