################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="ImageMagick"
PKG_VERSION="7.0.3-8"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.imagemagick.org"
PKG_URL="http://www.imagemagick.org/download/releases/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libX11 libtool:target"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/libs"
PKG_SHORTDESC="image manipulation library"
PKG_LONGDESC="ImageMagick is a software suite to create, edit, and compose bitmap images. It can read, convert and write images in a variety of formats (over 100)."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_LOCALE_INSTALL="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --enable-shared \
                           --with-quantum-depth=8 \
                           --enable-hdri=no \
                           --disable-openmp"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/share/fonts/liberation
    cp -PR $PKG_DIR/config/truetype/* $INSTALL/usr/share/fonts/liberation
}
