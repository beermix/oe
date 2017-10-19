################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="ImageMagick"
PKG_VERSION="7.0.7-4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/ImageMagick/ImageMagick/releases"
PKG_GIT_URL="https://github.com/ImageMagick/ImageMagick"
PKG_DEPENDS_TARGET="toolchain libX11"
PKG_SECTION="xmedia/tools"
PKG_SHORTDESC="image manipulation library"
PKG_LONGDESC="ImageMagick is a software suite to create, edit, and compose bitmap images. It can read, convert and write images in a variety of formats (over 100)."

PKG_AUTORECONF="no"
PKG_LOCALE_INSTALL="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --enable-shared \
                           --with-quantum-depth=8 \
                           --enable-hdri=no \
                           --enable-openmp"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/share/fonts/liberation
    cp -PR $PKG_DIR/config/truetype/* $INSTALL/usr/share/fonts/liberation
}
