################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="AlexELEC-settings"
PKG_VERSION="db4f7ba"
PKG_SITE="http://www.alexelec.in.ua"
PKG_GIT_URL="https://github.com/AlexELEC/service.alexelec.settings"
PKG_DEPENDS_TARGET="toolchain Python pygobject dbus-python"
PKG_SECTION=""
PKG_SHORTDESC="AlexELEC-settings: Advanced settings dialog for AlexELEC"
PKG_LONGDESC="AlexELEC-settings: is a Advanced settings dialog for AlexELEC"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAKE_OPTS_TARGET="DISTRONAME=AlexELEC ROOT_PASSWORD=$ROOT_PASSWORD"

post_makeinstall_target() {
  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/kodi/addons/service.alexelec.settings/resources/lib/ -f
  rm -rf `find $INSTALL/usr/share/kodi/addons/service.alexelec.settings/resources/lib/ -name "*.py"`

  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/kodi/addons/service.alexelec.settings/oe.py -f
  rm -rf $INSTALL/usr/share/kodi/addons/service.alexelec.settings/oe.py

  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/kodi/addons/service.alexelec.settings/defaults.py -f
  rm -rf $INSTALL/usr/share/kodi/addons/service.alexelec.settings/defaults.py
}
