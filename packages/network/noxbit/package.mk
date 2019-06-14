################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="noxbit"
PKG_VERSION="x86-64"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/AlexELEC/noxbit"
#PKG_URL="http://download.noxbit.com/noxbit-pa-x86-64.tar.gz"
	PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="xmedia/torrent"
PKG_SHORTDESC="NoxBit: Meet the New Generation of Live Video Streaming"
PKG_LONGDESC="NoxBit: Meet the New Generation of Live Video Streaming."
PKG_IS_ADDON="no"


make_target() {
  : # nothing to make here
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/* $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/config/noxbit
    cp noxbit.cfg $INSTALL/usr/config/noxbit
    cp $PKG_DIR/config/* $INSTALL/usr/config/noxbit
  mkdir -p $INSTALL/usr/config/noxbit/bin
    cp STM-* $INSTALL/usr/config/noxbit/bin
    
  ln -sf $PKG_BUILD/bin/noxbit.cfg $INSTALL/usr/config/noxbit
  ln -sf $PKG_BUILD/bin/STM-Agent $INSTALL/usr/bin/STM-Agent
  ln -sf $PKG_BUILD/bin/STM-Downloader $INSTALL/usr/bin/STM-Downloader
  ln -sf $PKG_BUILD/bin/STM-Hypervisor $INSTALL/usr/bin/STM-Hypervisor
}

post_install() {
  enable_service noxbit.service
}
