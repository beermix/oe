PKG_NAME="bonnie"
PKG_VERSION="1.03e"
PKG_URL="http://www.coker.com.au/bonnie++/bonnie++-$PKG_VERSION.tgz"
PKG_SOURCE_DIR="bonnie++-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

PKG_MAKE_OPTS_TARGET="CC=$TARGET_CC AR=$TARGET_AR BUILD_CC=$HOST_CC -j1"

post_make_target() {
  mkdir -p $INSTALL/usr/sbin/
  cp $ROOT/$PKG_BUILD/bonnie++ $INSTALL/usr/sbin/
  cp $ROOT/$PKG_BUILD/zcav $INSTALL/usr/sbin/
}


makeinstall_target() {
  :
}