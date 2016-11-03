PKG_NAME="​iptraf-ng"
PKG_VERSION="master"
PKG_GIT_URL="git://repo.or.cz/iptraf-ng.git"
PKG_DEPENDS_TARGET="toolchain sqlite libpcap"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
  export MAKEFLAGS=-j1
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --sysconfdir=/storage/.config \
			   --datarootdir=/storage/.config \
			   --enable-static \
			   --disable-shared"

#post_makeinstall_target() {
#   mkdir -p $INSTALL/usr/bin/
#   cp wash $INSTALL/usr/bin/wash
#   cp reaver $INSTALL/usr/bin/reaver
#}