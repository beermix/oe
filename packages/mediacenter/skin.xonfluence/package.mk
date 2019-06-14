################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="skin.xonfluence"
PKG_VERSION="ebb0130"
PKG_SITE="https://github.com/Helly1206/skin.xonfluence"
PKG_URL="https://github.com/Helly1206/skin.xonfluence/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain kodi"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="kodi-theme-AeonNox: Kodi Mediacenter theme"
PKG_LONGDESC="kodi-theme-AeonNox: Kodi Mediacenter theme."
PKG_IS_ADDON="no"

make_target() {
  TexturePacker -input media/ \
                -output Textures.xbt \
                -dupecheck
}

makeinstall_target() {
  rm -f resources/screenshot-*.jpg
  mkdir -p $INSTALL/usr/config/kodi.skins/skin.xonfluence
    cp -R */ $INSTALL/usr/config/kodi.skins/skin.xonfluence
    cp *.txt $INSTALL/usr/config/kodi.skins/skin.xonfluence
    cp *.xml $INSTALL/usr/config/kodi.skins/skin.xonfluence
      rm -rf $INSTALL/usr/config/kodi.skins/skin.xonfluence/media

  mkdir -p $INSTALL/usr/config/kodi.skins/skin.xonfluence/media
    cp Textures.xbt $INSTALL/usr/config/kodi.skins/skin.xonfluence/media
    for theme in themes/*; do
      cp $(basename $theme).xbt $INSTALL/usr/config/kodi.skins/skin.xonfluence/media
    done

  mkdir -p $INSTALL/usr/share/kodi/addons
  ln -sf /storage/.config/kodi.skins/skin.xonfluence $INSTALL/usr/share/kodi/addons/skin.xonfluence
}
