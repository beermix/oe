PKG_NAME="reaver"
PKG_VERSION="1.4"
PKG_URL="https://dl.dropboxusercontent.com/s/zu77hev68w81o67/reaver-1.4-src.tar.xz"
#PKG_URL="https://dl.dropboxusercontent.com/s/khspnon2cudamxo/reaver-1.4.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libpcap"

PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

pre_configure_target() {
   cd $PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --sysconfdir=/storage/.config/reaver \
			   --datarootdir=/storage/.config/reaver"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin/
  #cp wash $INSTALL/usr/bin/
  cp reaver $INSTALL/usr/bin/
}