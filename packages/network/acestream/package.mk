################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="acestream"
PKG_VERSION="3.1.0-b3-pre4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.acestream.com/"
PKG_URL="https://dl.dropboxusercontent.com/s/cfucv4k0suz1d2i/acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz"
PKG_DEPENDS_TARGET="toolchain M2Crypto PyAMF setuptools"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/network"
PKG_SHORTDESC="This is an innovative media platform of a new generation, which will take you to a new high-quality level of multimedia space on the Internet."
PKG_LONGDESC="This is an innovative media platform of a new generation, which will take you to a new high-quality level of multimedia space on the Internet."

PKG_AUTORECONF="no"

post_unpack() {
  rm -rf $PKG_BUILD/usr/lib
}

make_target() {
  : # nothing to make here
}

makeinstall_target() {
  mkdir -p $INSTALL
    cp -a $PKG_BUILD/usr $INSTALL
    cp $PKG_DIR/scripts/* $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/config
    cp $PKG_DIR/config/* $INSTALL/usr/config
}

post_install() {
  enable_service acestream.service
}
