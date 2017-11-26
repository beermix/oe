################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="kodi-theme-xonfluence"
PKG_VERSION="26fe189"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Helly1206/skin.xonfluence"
PKG_GIT_URL="https://github.com/Helly1206/skin.xonfluence"
PKG_DEPENDS_TARGET="toolchain kodi"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="kodi-theme-xonfluence: Kodi Mediacenter theme"
PKG_LONGDESC="kodi-theme-xonfluence: Kodi Mediacenter theme."
PKG_IS_ADDON="no"


make_target() {
  TexturePacker -input media/ \
                -output Textures.xbt \
                -dupecheck \
                -use_none

  for theme in themes/*; do
    TexturePacker -input $theme \
                -output $(basename $theme).xbt \
                -dupecheck
  done
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

  mkdir -p $INSTALL/usr/share/kodi/config
    cp $PKG_DIR/config/Nox-DialogButtonMenu.xml $INSTALL/usr/share/kodi/config
}
