################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="vdr-skin-nopacity"
PKG_VERSION="f593ad5"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://projects.vdr-developer.org/git/skin-nopacity.git/"
PKG_URL="$ALEXELEC_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain vdr ImageMagick"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/tvservice"
PKG_SHORTDESC="TV"
PKG_LONGDESC="TV"


PKG_LOCALE_INSTALL="yes"

make_target() {
  VDR_DIR=$(get_build_dir vdr)
  make VDRDIR=$VDR_DIR
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage/.config/vdr/plugins/skinnopacity/logos
  ln -sf /storage/.config/vdr/plugins/skindesigner/logos $INSTALL/storage/.config/vdr/plugins/skinnopacity/logos
  mkdir -p $INSTALL/usr/config
    mv -f $INSTALL/storage/.config/vdr $INSTALL/usr/config
    cp $PKG_DIR/config/*.png $INSTALL/usr/config/vdr/plugins/skinnopacity/icons/pluginIcons
    rm -rf $INSTALL/usr/config/vdr/plugins/skinnopacity/logos
    ln -sf /storage/.config/vdr/plugins/skindesigner/logos $INSTALL/usr/config/vdr/plugins/skinnopacity/logos
  rm -rf $INSTALL/storage
}
