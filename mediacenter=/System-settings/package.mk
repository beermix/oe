################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="System-settings"
PKG_VERSION="4c01b39"
PKG_SITE="http://www.alexelec.in.ua"
PKG_GIT_URL="https://github.com/AlexELEC/service.system.settings"
PKG_DEPENDS_TARGET="toolchain Python connman pygobject dbus-python setxkbmap"
PKG_PRIORITY="optional"
PKG_SECTION=""
PKG_SHORTDESC="System-settings: Settings dialog for AlexELEC"
PKG_LONGDESC="System-settings: is a settings dialog for AlexELEC"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAKE_OPTS_TARGET="DISTRONAME=AlexELEC ROOT_PASSWORD=$ROOT_PASSWORD"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/alexelec
    cp $PKG_DIR/scripts/* $INSTALL/usr/lib/alexelec

  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/kodi/addons/service.system.settings/resources/lib/ -f
  rm -rf `find $INSTALL/usr/share/kodi/addons/service.system.settings/resources/lib/ -name "*.py"`

  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/kodi/addons/service.system.settings/oe.py -f
  rm -rf $INSTALL/usr/share/kodi/addons/service.system.settings/oe.py

  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/kodi/addons/service.system.settings/defaults.py -f
  rm -rf $INSTALL/usr/share/kodi/addons/service.system.settings/defaults.py
}

post_install() {
  enable_service backup-restore.service
  enable_service factory-reset.service
}
