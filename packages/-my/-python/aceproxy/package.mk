################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="aceproxy"
PKG_VERSION="841fbe8"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_URL="http://src.alexelec.in.ua/aceproxy-841fbe8.tar.xz"
PKG_DEPENDS_TARGET="toolchain gevent psutil M2Crypto"
PKG_SECTION="xmedia/torrent"
PKG_SHORTDESC="AceProxy: Ace Stream HTTP Proxy"
PKG_LONGDESC="AceProxy: Ace Stream HTTP Proxy."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_LOCALE_INSTALL="yes"

make_target() {
  : # nothing to make here
}

makeinstall_target() {
  DESTDIR=$INSTALL ./install

  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/* $INSTALL/usr/bin
}

post_install() {
  enable_service aceproxy.service
}
