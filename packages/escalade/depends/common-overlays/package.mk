################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="common-overlays"
PKG_VERSION="latest"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/common-overlays"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="xmedia/games"
PKG_SHORTDESC="Common Overlays for RetroArch"
PKG_LONGDESC="Common Overlays for RetroArch."



unpack() {
  mkdir -p $PKG_BUILD
  cd $PKG_BUILD
  git clone --depth 1 https://github.com/libretro/common-overlays.git overlay
  find . -type f -exec chmod 644 {} \;
  rm -fr overlay/.git
  cd $ROOT
}

make_target() {
  : none
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/retroarch
    cp -a overlay $INSTALL/usr/share/retroarch
}
