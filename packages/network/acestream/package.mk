################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="acestream"
PKG_VERSION="3.1.35_ubuntu_18.04_x86_64"
PKG_VERSION="3.1.16_ubuntu_16.04_x86_64"
PKG_SHA256="c20f427e635238857eb2c2a8402e3d90690c252f7f187d295fbc038f2a2be001"
PKG_SHA256="452bccb8ae8b5ff4497bbb796081dcf3fec2b699ba9ce704107556a3d6ad2ad7"
PKG_SITE="http://wiki.acestream.org/wiki/index.php/Download"
#PKG_URL="http://dl.acestream.org/linux/acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz"
#PKG_URL="https://dl.dropboxusercontent.com/s/9cf62xv4dieb3qd/acestream-3.1.16_ubuntu_16.04_x86_64.tar.xz"
PKG_URL="http://dl.acestream.org/linux/acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz"
PKG_DEPENDS_TARGET="toolchain M2Crypto apsw setuptools"
#PKG_SOURCE_DIR="acestream-3.1.35_ubuntu_18.04_x86_64"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
   mkdir -p $INSTALL/opt
   cp -pr $PKG_BUILD/* $INSTALL/opt/
}

post_install() {
  enable_service acestream.service
}
