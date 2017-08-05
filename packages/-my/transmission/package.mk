PKG_NAME="transmission"
PKG_VERSION="ed754f9"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.transmissionbt.com/"
PKG_DEPENDS_TARGET="toolchain zlib openssl curl libevent miniupnpc xfsprogs-dev"
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.0"
PKG_AUTORECONF="no"

PGK_CMAKE_OPTS_TARGET="-DENABLE_CLI=On -DENABLE_LIGHTWEIGHT=On"

pre_build_target() {
  git clone --recursive --depth 1 https://github.com/transmission/transmission $PKG_BUILD/$PKG_NAME-git
  cd $PKG_BUILD/$PKG_NAME-git
  git reset --hard $PKG_VERSION
  rm -rf .git
  cd -
  mv $PKG_BUILD/$PKG_NAME-git/* $PKG_BUILD/
  rm -rf $PKG_BUILD/$PKG_NAME-git
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
