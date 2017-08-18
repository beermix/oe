################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################
PKG_NAME="inputstream.adaptive"
PKG_VERSION="46be790"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/peak3d/inputstream.adaptive/tree/Krypton"
PKG_GIT_URL="https://github.com/peak3d/inputstream.adaptive"
PKG_GIT_BRANCH="Krypton"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_SECTION=""
PKG_SHORTDESC="inputstream.adaptive"
PKG_LONGDESC="inputstream.adaptive"

PKG_IS_ADDON="yes"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_MODULE_PATH=$SYSROOT_PREFIX/usr/lib/kodi \
                       -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr"

post_makeinstall_target() {
  cp -P $ROOT/$PKG_BUILD/.$TARGET_NAME/wvdecrypter/libssd_wv.so $INSTALL/usr/lib
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/
  cp -R $PKG_BUILD/.install_pkg/usr/share/kodi/addons/$PKG_NAME/* $ADDON_BUILD/$PKG_ADDON_ID/

  ADDONSO=$(xmlstarlet sel -t -v "/addon/extension/@library_linux" $ADDON_BUILD/$PKG_ADDON_ID/addon.xml)
  cp -L $PKG_BUILD/.install_pkg/usr/lib/kodi/addons/$PKG_NAME/$ADDONSO $ADDON_BUILD/$PKG_ADDON_ID/

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib/
  cp -P $PKG_BUILD/.$TARGET_NAME/wv/libssd_wv.so $ADDON_BUILD/$PKG_ADDON_ID/lib
}
