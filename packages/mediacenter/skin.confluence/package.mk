################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="skin.confluence"
PKG_VERSION="5c4c80f"
PKG_SITE="https://github.com/xbmc/skin.confluence"
PKG_GIT_URL="https://github.com/xbmc/skin.confluence"
PKG_DEPENDS_TARGET="toolchain kodi"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="kodi-theme-AeonNox: Kodi Mediacenter theme"
PKG_LONGDESC="kodi-theme-AeonNox: Kodi Mediacenter theme."

PKG_AUTORECONF="no"

make_target() {
  TexturePacker -input media/ \
                -output Textures.xbt \
                -dupecheck \
                -use_none
}

makeinstall_target() {
  rm -f resources/screenshot-*.jpg
  mkdir -p $INSTALL/usr/config/kodi.skins/skin.confluence
    cp -R */ $INSTALL/usr/config/kodi.skins/skin.confluence
    cp *.txt $INSTALL/usr/config/kodi.skins/skin.confluence
    cp *.xml $INSTALL/usr/config/kodi.skins/skin.confluence
      rm -rf $INSTALL/usr/config/kodi.skins/skin.confluence/media

  mkdir -p $INSTALL/usr/config/kodi.skins/skin.confluence/media
    cp Textures.xbt $INSTALL/usr/config/kodi.skins/skin.confluence/media

  mkdir -p $INSTALL/usr/share/kodi/addons
  ln -sf /storage/.config/kodi.skins/skin.confluence $INSTALL/usr/share/kodi/addons/skin.confluence
}
