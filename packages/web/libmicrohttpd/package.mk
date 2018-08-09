# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libmicrohttpd"
PKG_VERSION="0.9.51"
PKG_ARCH="any"
PKG_LICENSE="LGPLv2.1"
PKG_SITE="http://www.gnu.org/software/libmicrohttpd/"
PKG_URL="http://ftpmirror.gnu.org/libmicrohttpd/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="web"
PKG_SHORTDESC="libmicrohttpd: a small webserver C library"
PKG_LONGDESC="GNU libmicrohttpd is a small C library that is supposed to make it easy to run an HTTP server as part of another application."

#pre_configure_target() {
#  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os -Wall|"`
#  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os -Wall|"`
#}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static \
                           --disable-curl \
                           --disable-https \
                           --with-libgcrypt-prefix=$SYSROOT_PREFIX/usr"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
