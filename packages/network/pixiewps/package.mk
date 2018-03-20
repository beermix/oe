PKG_NAME="pixiewps"
PKG_VERSION="e2f480a"
PKG_URL="https://github.com/wiire/pixiewps/archive/${PKG_VERSION}.tar.gz"
#PKG_DEPENDS_TARGET="toolchain sqlite libpcap"
PKG_SECTION="network"

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