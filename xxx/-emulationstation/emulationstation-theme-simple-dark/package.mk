################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="emulationstation-theme-simple-dark"
PKG_VERSION="4c33193"
PKG_SITE="https://github.com/RetroPie/es-theme-simple-dark"
PKG_GIT_URL="https://github.com/RetroPie/es-theme-simple-dark/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="es-theme-simple-dark*"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="xmedia/games"
PKG_SHORTDESC="Simple dark theme for Emulationstation"



make_target() {
  : not
}

makeinstall_target() {
  mkdir -p $INSTALL/etc/emulationstation/themes/es-theme-simple-dark
    cp -r * $INSTALL/etc/emulationstation/themes/es-theme-simple-dark
}
