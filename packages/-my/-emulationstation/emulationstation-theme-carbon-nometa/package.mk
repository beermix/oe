################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="emulationstation-theme-carbon-nometa"
PKG_VERSION="e76a6f6"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/RetroPie/es-theme-carbon-nometa"
PKG_GIT_URL="https://github.com/RetroPie/es-theme-carbon-nometa"
PKG_SOURCE_DIR="es-theme-carbon-nometa*"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/games"
PKG_SHORTDESC="Carbon-NoMeta theme for Emulationstation"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  : not
}

makeinstall_target() {
  mkdir -p $INSTALL/etc/emulationstation/themes/es-theme-carbon-nometa
    cp -r * $INSTALL/etc/emulationstation/themes/es-theme-carbon-nometa
}
