PKG_NAME="reaver-wps-fork-t6x"
PKG_VERSION="707c574"
PKG_GIT_URL="https://github.com/t6x/reaver-wps-fork-t6x"
PKG_DEPENDS_TARGET="toolchain sqlite libpcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}

pre_configure_target() {
   cd $ROOT/$PKG_BUILD
   export MAKEFLAGS="-j1"
   export LDFLAGS="-ldl -lpthread -lsqlite3"
   mkdir -p $INSTALL_DEV/usr/bin/
   mkdir -p $INSTALL/usr/bin/
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_sqlite3_sqlite3_open=yes \
			      --sysconfdir=/storage/.config \
			      --datarootdir=/storage/.config"

post_makeinstall_target() {
   cp wash $INSTALL/usr/bin/wash
   cp reaver $INSTALL/usr/bin/reaver
}