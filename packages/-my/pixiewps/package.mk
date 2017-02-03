PKG_NAME="pixiewps"
PKG_VERSION="fd62b81"
PKG_GIT_URL="https://github.com/wiire/pixiewps"
#PKG_DEPENDS_TARGET="toolchain sqlite libpcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}


makeinstall_target() {
  :
}

post_makeinstall_target() {
   mkdir -p $INSTALL/usr/bin/
   cp pixiewps $INSTALL/usr/bin/pixiewps
}