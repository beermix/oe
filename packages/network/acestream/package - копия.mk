################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="acestream"
PKG_VERSION="3.1.16_ubuntu_16.04_x86_64"
PKG_SITE="http://wiki.acestream.org/wiki/index.php/Download"
PKG_URL="http://dl.acestream.org/linux/acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz"
#PKG_URL="https://dl.dropboxusercontent.com/s/9cf62xv4dieb3qd/acestream-3.1.16_ubuntu_16.04_x86_64.tar.xz"
PKG_URL="http://acestream.org/downloads/linux-beta/acestream_3.1.35_ubuntu_18.04_x86_64.tar.gz"
PKG_DEPENDS_TARGET="toolchain M2Crypto apsw setuptools"
PKG_SOURCE_DIR="${PKG_NAME}_$PKG_VERSION*"
PKG_SHORTDESC="This is an innovative media platform of a new generation, which will take you to a new high-quality level of multimedia space on the Internet."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
   mkdir -p $INSTALL/opt
    cp -pr $PKG_BUILD/* $INSTALL/opt
}

post_install() {
  enable_service acestream.service
}
