PKG_NAME="reaver-wps-fork-t6x"
PKG_VERSION="a265851"
PKG_URL="https://github.com/t6x/reaver-wps-fork-t6x/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libpcap aircrack-ng pixiewps"
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"

post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}

pre_configure_target() {
   cd $PKG_BUILD
   export MAKEFLAGS="-j1"
   strip_lto
   CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE"
   mkdir -p $INSTALL_DEV/usr/bin/
   mkdir -p $INSTALL/usr/bin/
}

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config --datarootdir=/storage/.config"
			      
makeinstall_target() {
  :
}

post_makeinstall_target() {
   cp wash $INSTALL/usr/bin/wash
   cp reaver $INSTALL/usr/bin/reaver
}