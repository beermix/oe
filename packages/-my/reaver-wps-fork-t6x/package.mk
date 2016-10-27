PKG_NAME="reaver-wps-fork-t6x"
PKG_VERSION="4a19674"
PKG_GIT_URL="https://github.com/t6x/reaver-wps-fork-t6x"
PKG_DEPENDS_TARGET="toolchain sqlite libpcap"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}

#CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
#LDFLAGS="-s -Wl,-O1,--as-needed"

pre_configure_target() {
   cd $ROOT/$PKG_BUILD
   export MAKEFLAGS="-j1"
   strip_lto
   LDFLAGS="-lsqlite3"
}


PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_sqlite3_sqlite3_open=yes \
			   --prefix=/usr \
			   --sysconfdir=/storage/.config \
			   --datarootdir=/storage/.config"

post_makeinstall_target() {
   mkdir -p $INSTALL/usr/bin/
   cp wash $INSTALL/usr/bin/wash
   cp reaver $INSTALL/usr/bin/reaver
}