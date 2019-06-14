################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="pvr.iptvsimple.multi"
PKG_VERSION="10471f9"
PKG_REV="1"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/AlexELEC/pvr.iptvsimple.multi"
PKG_URL="https://github.com/AlexELEC/pvr.iptvsimple.multi/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain kodi-platform zlib"
PKG_TOOLCHAIN="cmake-make"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.pvrclient"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_MODULE_PATH=$SYSROOT_PREFIX/usr/lib/kodi \
                       -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr"

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/
  cp -R $ROOT/$PKG_BUILD/.install_pkg/usr/share/kodi/addons/$PKG_NAME/* $ADDON_BUILD/$PKG_ADDON_ID/

  ADDONSO=$(xmlstarlet sel -t -v "/addon/extension/@library_linux" $ADDON_BUILD/$PKG_ADDON_ID/addon.xml)
  cp -L $ROOT/$PKG_BUILD/.install_pkg/usr/lib/kodi/addons/$PKG_NAME/$ADDONSO $ADDON_BUILD/$PKG_ADDON_ID/
}
