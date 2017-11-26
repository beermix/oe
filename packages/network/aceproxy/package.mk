################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="aceproxy"
PKG_VERSION="dc5e0bc"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/pepsik-kiev/aceproxy"
PKG_URL="https://github.com/pepsik-kiev/aceproxy/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="aceproxy-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain gevent psutil M2Crypto"
PKG_SECTION="xmedia/torrent"
PKG_SHORTDESC="AceProxy: Ace Stream HTTP Proxy"
PKG_LONGDESC="AceProxy: Ace Stream HTTP Proxy."
PKG_IS_ADDON="no"

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
