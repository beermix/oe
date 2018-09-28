# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libxslt"
PKG_VERSION="1.1.33-rc1"
PKG_SHA256="fe5c2cc487b010dac66529d494f220683dcc26b9c75e33518db9b37f52ee7f77"
#PKG_VERSION="1.1.32"
#PKG_SHA256="526ecd0abaf4a7789041622c3950c0e7f2c4c8835471515fd77eec684a355460"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://xmlsoft.org/xslt/"
PKG_URL="ftp://xmlsoft.org/libxml2/libxslt-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="libxml2:host"
PKG_SOURCE_DIR="libxslt-1.1.33"
PKG_DEPENDS_TARGET="toolchain libxml2 libxslt:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="libxslt"
PKG_LONGDESC="libxslt"

PKG_CONFIGURE_OPTS_HOST="  ac_cv_header_ansidecl_h=no \
                           ac_cv_header_xlocale_h=no \
                           --without-python \
                           --with-libxml-prefix=$TOOLCHAIN \
                           --without-crypto \
                           --without-debug"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_header_ansidecl_h=no \
                           ac_cv_header_xlocale_h=no \
                           --without-python \
                           --with-libxml-prefix=$SYSROOT_PREFIX/usr \
                           --without-crypto \
                           --without-debug"

post_makeinstall_target() {
  $SED "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/xslt-config

  rm -rf $INSTALL/usr/bin/xsltproc
  rm -rf $INSTALL/usr/lib/xsltConf.sh
}
