################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="emulationstation-theme-carbon"
PKG_VERSION="1ed9747"
PKG_SITE="https://github.com/RetroPie/es-theme-carbon"
PKG_GIT_URL="https://github.com/RetroPie/es-theme-carbon"
PKG_SOURCE_DIR="es-theme-carbon*"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="xmedia/games"
PKG_SHORTDESC="Carbon theme for Emulationstation"



make_target() {
  : not
}

makeinstall_target() {
  mkdir -p $INSTALL/etc/emulationstation/themes/es-theme-carbon
    cp -r * $INSTALL/etc/emulationstation/themes/es-theme-carbon
}
