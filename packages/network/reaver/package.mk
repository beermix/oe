PKG_NAME="reaver"
PKG_VERSION="1.4"
PKG_URL="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/reaver-wps/reaver-1.4.tar.gz"
#PKG_URL="https://dl.dropboxusercontent.com/s/khspnon2cudamxo/reaver-1.4.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap"
PKG_SECTION="my"



post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}

pre_configure_target() {
   cd $PKG_BUILD
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