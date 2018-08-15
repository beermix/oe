# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libxslt"
PKG_VERSION="1.1.33-rc1"
PKG_SHA256="fe5c2cc487b010dac66529d494f220683dcc26b9c75e33518db9b37f52ee7f77"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://xmlsoft.org/xslt/"
PKG_URL="ftp://xmlsoft.org/libxml2/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_URL="ftp://xmlsoft.org/libxml2/libxslt-1.1.33-rc1.tar.gz"
PKG_DEPENDS_HOST="libxml2:host"
PKG_SOURCE_DIR="libxslt-1.1.33"
PKG_DEPENDS_TARGET="toolchain libxml2 libxslt:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="libxslt"
PKG_LONGDESC="libxslt"

PKG_CONFIGURE_OPTS_HOST="  ac_cv_header_ansidecl_h=no \
                           ac_cv_header_xlocale_h=no \
                           --enable-static \
                           --enable-shared \
                           --without-python \
                           --with-libxml-prefix=$TOOLCHAIN \
                           --without-crypto"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_header_ansidecl_h=no \
                           ac_cv_header_xlocale_h=no \
                           --enable-static \
                           --enable-shared \
                           --without-python \
                           --with-libxml-prefix=$SYSROOT_PREFIX/usr \
                           --without-crypto"

post_makeinstall_target() {
  $SED "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/xslt-config

  rm -rf $INSTALL/usr/bin/xsltproc
  rm -rf $INSTALL/usr/lib/xsltConf.sh
}
