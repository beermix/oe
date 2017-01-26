PKG_NAME="bully"
PKG_VERSION="1.0-22"
PKG_URL="https://dl.dropboxusercontent.com/s/wec0256lxwboku5/bully_1.0-22.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}

pre_configure_target() {
   cd $ROOT/$PKG_BUILD
   export MAKEFLAGS="-j1"
   strip_lto
   export LDFLAGS="-ldl -lpthread -lsqlite3"
   mkdir -p $INSTALL_DEV/usr/bin/
   mkdir -p $INSTALL/usr/bin/
}


PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_sqlite3_sqlite3_open=yes \
			      --sysconfdir=/storage/.config \
			      --datarootdir=/storage/.config"

post_makeinstall_target() {
   cp wash $INSTALL/usr/bin/wash2
   cp reaver $INSTALL/usr/bin/reaver2
}