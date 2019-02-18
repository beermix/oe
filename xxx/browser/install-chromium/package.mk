################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="install-chromium"
PKG_VERSION="1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.alexelec.in.ua"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain chromium kodi-addon-chromium"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/browser"
PKG_SHORTDESC="Install Chromium Browser"
PKG_LONGDESC="Install Chromium Browser."



make_target() {
  : # nothing to do here
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/* $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/config/chromium
    cp -PR $PKG_DIR/config/* $INSTALL/usr/config/chromium
}
