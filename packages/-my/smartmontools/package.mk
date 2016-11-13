PKG_NAME="smartmontools"
PKG_VERSION="d288e7c"
PKG_GIT_URL="https://github.com/mirror/smartmontools"
PKG_DEPENDS_TARGET="toolchain systemd netbsd-curses libcap-ng"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --sysconfdir=/storage/.config/smartmontools \
			   --datarootdir=/storage/.config/smartmontools/share \
			   --disable-silent-rules \
			   --with-systemdsystemunitdir=/usr/lib/systemd/system"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
  rm -rf $INSTALL/usr/lib
}