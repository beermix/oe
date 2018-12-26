# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="tiff"
PKG_VERSION="4.0.10"
PKG_SHA256="2c52d11ccaf767457db0c46795d9c7d1a8d8f76f68b0b800a3dfe45786b996e4"
PKG_LICENSE="OSS"
PKG_SITE="http://download.osgeo.org/libtiff/?C=M;O=D"
PKG_URL="http://download.osgeo.org/libtiff/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libjpeg-turbo zlib"
PKG_BUILD_FLAGS="+pic +lto +hardening"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--disable-mdi \
                           --enable-cxx \
                           --with-jpeg-lib-dir=$SYSROOT_PREFIX/usr/lib \
                           --with-jpeg-include-dir=$SYSROOT_PREFIX/usr/include \
                           --without-x"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
