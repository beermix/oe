PKG_NAME="transmission"
PKG_VERSION="master"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.transmissionbt.com/"
PKG_DEPENDS_TARGET="toolchain zlib openssl curl libevent miniupnpc"
PKG_SECTION="service/downloadmanager"
PKG_SHORTDESC="transmission: a fast, easy and free BitTorrent client"
PKG_LONGDESC="transmission is a fast, easy and free BitTorrent client"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

unpack() {
  git clone --recursive --depth 1 https://github.com/transmission/transmission $ROOT/$PKG_BUILD/$PKG_NAME-git
  cd $ROOT/$PKG_BUILD/$PKG_NAME-git
  git reset --hard $PKG_VERSION
  cd -
  mv $ROOT/$PKG_BUILD/$PKG_NAME-git/* $ROOT/$PKG_BUILD/
  rm -rf $ROOT/$PKG_BUILD/$PKG_NAME-git
}

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  NOCONFIGURE=1 ./autogen.sh
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-utp --enable-cli --enable-daemon --with-gnu-ld --with-systemd --with-crypto=openssl"

PGK_CMAKE_OPTS_TARGET="-DENABLE_CLI=1 -DENABLE_LIGHTWEIGHT=0 -DUSE_SYSTEM_MINIUPNPC=1 -DCMAKE_BUILD_TYPE=Release"

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $ROOT/$PKG_BUILD/.$TARGET_NAME/daemon/transmission-daemon $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $ROOT/$PKG_BUILD/.$TARGET_NAME/daemon/transmission-remote $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $ROOT/$PKG_BUILD/.$TARGET_NAME/utils/transmission-create $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $ROOT/$PKG_BUILD/.$TARGET_NAME/utils/transmission-edit $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $ROOT/$PKG_BUILD/.$TARGET_NAME/utils/transmission-show $ADDON_BUILD/$PKG_ADDON_ID/bin

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/web
  cp -R $ROOT/$PKG_BUILD/web/* $ADDON_BUILD/$PKG_ADDON_ID/web
  find $ADDON_BUILD/$PKG_ADDON_ID/web -name "Makefile*" -exec rm -rf {} ";"
  rm -rf $ADDON_BUILD/$PKG_ADDON_ID/web/LICENSE
}
