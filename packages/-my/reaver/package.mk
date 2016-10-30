PKG_NAME="reaver"
PKG_VERSION="1.4"
PKG_URL="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/reaver-wps/reaver-1.4.tar.gz"
#PKG_URL="https://dl.dropboxusercontent.com/s/khspnon2cudamxo/reaver-1.4.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}


pre_configure_target() {
   cd $ROOT/$PKG_BUILD
   export MAKEFLAGS="-j1"
   export LDFLAGS="-lpthread"
   #LDFLAGS="-lsqlite3"
}


PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_pcap_pcap_open_live=yes \
			   ac_cv_lib_sqlite3_sqlite3_open=yes \
			   --prefix=/usr \
			   --sysconfdir=/storage/.config \
			   --datarootdir=/storage/.config"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin/
  #cp wash $INSTALL/usr/bin/
  cp reaver $INSTALL/usr/bin/
}