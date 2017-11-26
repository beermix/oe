PKG_NAME="transmission"
PKG_VERSION="2.92GIT"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.transmissionbt.com/"
PKG_URL="https://dl.dropboxusercontent.com/s/cp1t4gfj3d6d8jo/transmission-2.92GIT.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib openssl curl libevent miniupnpc"
PKG_SECTION="service/downloadmanager"
PKG_SHORTDESC="transmission: a fast, easy and free BitTorrent client"
PKG_LONGDESC="transmission is a fast, easy and free BitTorrent client"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_USE_CMAKE="no"


#unpack() {
#  git clone --recursive --depth 1 https://github.com/transmission/transmission $PKG_BUILD/$PKG_NAME-git
#  cd $PKG_BUILD/$PKG_NAME*
#  git reset --hard $PKG_VERSION
#  cd -
#  mv $PKG_BUILD/$PKG_NAME-git/* $PKG_BUILD/
#  rm -rf $PKG_BUILD/$PKG_NAME*
#}

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  autoreconf --verbose --install --force -I m4
}

PKG_CONFIGURE_OPTS_TARGET="--enable-utp --enable-cli --enable-daemon --with-systemd --with-crypto=openssl"

PGK_CMAKE_OPTS_TARGET="-DENABLE_CLI=1 -DENABLE_LIGHTWEIGHT=0 -DUSE_SYSTEM_MINIUPNPC=1 -DCMAKE_BUILD_TYPE=Release"

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
