PKG_NAME="smartmontools"
PKG_VERSION="ef73764"
PKG_GIT_URL="https://github.com/mirror/smartmontools"
#PKG_DEPENDS_TARGET="toolchain netbsd-curses libcap-ng"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config/smartmontools \
			      --datarootdir=/storage/.config/smartmontools/share \
			      --with-systemdsystemunitdir=/usr/lib/systemd/system \
			      --disable-silent-rules"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
  rm -rf $INSTALL/usr/lib
}

