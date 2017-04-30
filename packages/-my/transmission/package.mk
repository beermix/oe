PKG_NAME="transmission"
PKG_VERSION="master"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain zlib openssl libpcap pcre libevent curl libdaemon"
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_AUTORECONF="no"

unpack() {
  git clone --recursive -v --depth 1 https://github.com/transmission/transmission $PKG_BUILD
  cd $PKG_BUILD
  git reset --hard $PKG_VERSION
  rm -rf .git
  cd $ROOT
}

PKG_CMAKE_OPTS_TARGET="-DWITH_CRYPTO=openssl \
			  -DWITH_INOTIFY=OFF \
			  -DWITH_KQUEUE=OFF \
			  -DWITH_SYSTEMD=ON \
			  -DINSTALL_LIB=ON \
			  -DINSTALL_DOC=OFF \
			  -DENABLE_UTP=ON \
			  -DENABLE_TESTS=OFF \
			  -DENABLE_QT=OFF \
			  -DENABLE_GTK=OFF \
			  -DENABLE_DAEMON=ON \
			  -DENABLE_CLI=ON \
			  -DHAVE_XFS_XFS_H=0 \
			  -DUSE_SYSTEM_EVENT2=YES \
			  -DUSE_SYSTEM_MINIUPNPC=YES \
			  -DUSE_SYSTEM_NATPMP=NO \
			  -DUSE_SYSTEM_DHT=OFF \
			  -DUSE_SYSTEM_B64=NO \
			  -DUSE_SYSTEM_UTP=NO \
			  -DENABLE_LIGHTWEIGHT=OFF"

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
