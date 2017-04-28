################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="visualization.spectrum"
PKG_VERSION="73c8786"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_GIT_URL="https://github.com/notspiff/visualization.spectrum"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_SECTION=""
PKG_SHORTDESC="visualization.spectrum"
PKG_LONGDESC="visualization.spectrum"
PKG_AUTORECONF="no"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.player.musicviz"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_MODULE_PATH=$SYSROOT_PREFIX/usr/lib/kodi \
                       -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr"

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/
  cp -R $PKG_BUILD/.install_pkg/usr/share/kodi/addons/$PKG_NAME/* $ADDON_BUILD/$PKG_ADDON_ID/

  ADDONSO=$(xmlstarlet sel -t -v "/addon/extension/@library_linux" $ADDON_BUILD/$PKG_ADDON_ID/addon.xml)
  cp -L $PKG_BUILD/.install_pkg/usr/lib/kodi/addons/$PKG_NAME/$ADDONSO $ADDON_BUILD/$PKG_ADDON_ID/
}
