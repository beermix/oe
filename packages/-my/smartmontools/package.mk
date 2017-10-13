PKG_NAME="smartmontools"
PKG_VERSION="df25dda"
PKG_URL="https://github.com/mirror/smartmontools/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses libcap-ng"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config/smartmontools \
			      --datarootdir=/storage/.config/smartmontools/share \
			      --disable-silent-rules"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
#  rm -rf $INSTALL/usr/lib
}

#post_install() {
#  enable_service smartd.service
#}
