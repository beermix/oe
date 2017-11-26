################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="inputlirc"
PKG_VERSION="23"
PKG_SITE="http://www.alexelec.in.ua"
PKG_URL="$ALEXELEC_SRC/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="xmedia/tools"
PKG_SHORTDESC="Zeroconf LIRC daemon using input event devices"
PKG_LONGDESC="This is a small LIRC-compatible daemon that reads from /dev/input/eventX devices and sends the received keycodes to connecting LIRC clients"



make_target() {
  make PREFIX=/usr
}

makeinstall_target() {
  make DESTDIR=$INSTALL PREFIX=/usr install-sbin
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/* $INSTALL/usr/bin
}

post_install() {
  enable_service inputlircd.service
}
