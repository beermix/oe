PKG_NAME="reaver"
PKG_VERSION="1.4-src"
PKG_URL="https://dl.dropboxusercontent.com/s/zu77hev68w81o67/reaver-1.4-src.tar.xz"
#PKG_URL="https://dl.dropboxusercontent.com/s/khspnon2cudamxo/reaver-1.4.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   cd $ROOT/$PKG_BUILD
}
CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --sysconfdir=/storage/.config \
			   --datarootdir=/storage/.config \
			   --with-gnu-ld"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin/
  #cp wash $INSTALL/usr/bin/
  cp reaver $INSTALL/usr/bin/
}