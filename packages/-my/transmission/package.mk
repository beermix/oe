PKG_NAME="transmission"
PKG_VERSION="git"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

unpack() {
  git clone --recursive -v --depth 1 https://github.com/transmission/transmission $PKG_BUILD
  cd $PKG_BUILD
}

PKG_CMAKE_OPTS_TARGET="-DINSTALL_DOC=OFF -DENABLE_TESTS=OFF"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/config/transmission-daemon
  cp $PKG_DIR/config/* $INSTALL/usr/config/transmission-daemon
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/daemon/transmission-daemon $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/daemon/transmission-remote $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/utils/transmission-create $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/utils/transmission-edit $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/utils/transmission-show $ADDON_BUILD/$PKG_ADDON_ID/bin

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/web
  cp -R $PKG_BUILD/web/* $ADDON_BUILD/$PKG_ADDON_ID/web
  find $ADDON_BUILD/$PKG_ADDON_ID/web -name "Makefile*" -exec rm -rf {} ";"
  rm -rf $ADDON_BUILD/$PKG_ADDON_ID/web/LICENSE
}
