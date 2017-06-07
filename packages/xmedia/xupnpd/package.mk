################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="xupnpd"
PKG_VERSION="5c08c05"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://xupnpd.org/"
PKG_URL="https://github.com/clark15b/xupnpd/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_SECTION="xmedia/tools"
PKG_SHORTDESC="xupnpd - eXtensible UPnP agent"
PKG_LONGDESC="xupnpd - eXtensible UPnP agent."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  cd src
}

make_target() {
  make amlogic
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp xupnpd $INSTALL/usr/bin
    cp $PKG_DIR/scripts/* $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/config/xupnpd
    cp -P *.lua $INSTALL/usr/config/xupnpd
    cp -a plugins $INSTALL/usr/config/xupnpd
    cp -a profiles $INSTALL/usr/config/xupnpd
    cp -a ui $INSTALL/usr/config/xupnpd
    cp -a www $INSTALL/usr/config/xupnpd
    cp -a $PKG_DIR/config/playlists $INSTALL/usr/config/xupnpd

  mkdir -p $INSTALL/usr/share
    ln -sf /storage/.config/xupnpd $INSTALL/usr/share/xupnpd
}

post_install() {
  enable_service xupnpd.service
}
