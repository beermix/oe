################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="emulationstation-theme-pixel"
PKG_VERSION="37bd4fc"
PKG_SITE="https://github.com/RetroPie/es-theme-pixel"
PKG_GIT_URL="https://github.com/RetroPie/es-theme-pixel"
PKG_SOURCE_DIR="es-theme-pixel*"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="xmedia/games"
PKG_SHORTDESC="Pixel theme for Emulationstation"



make_target() {
  : not
}

makeinstall_target() {
  mkdir -p $INSTALL/etc/emulationstation/themes/es-theme-pixel
    cp -r * $INSTALL/etc/emulationstation/themes/es-theme-pixel
}
