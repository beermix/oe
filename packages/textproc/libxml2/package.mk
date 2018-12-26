# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv) | --with-icu

PKG_NAME="libxml2"
PKG_VERSION="2.9.8"
PKG_SHA256="0b74e51595654f958148759cfef0993114ddccccbb6f31aee018f3558e8e2732"
PKG_LICENSE="MIT"
PKG_SITE="http://xmlsoft.org"
PKG_URL="ftp://xmlsoft.org/libxml2/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib"

PKG_CONFIGURE_OPTS_ALL="ac_cv_header_ansidecl_h=no \
             --enable-static \
             --enable-shared \
             --disable-ipv6 \
             --without-python \
             --with-zlib=$TOOLCHAIN \
             --without-lzma"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_ALL --with-zlib=$TOOLCHAIN"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_ALL --with-zlib=$SYSROOT_PREFIX/usr --with-sysroot=$SYSROOT_PREFIX"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fstack-protector-strong -mzero-caller-saved-regs"
  export CXXFLAGS="$CXXFLAGS -fstack-protector-strong -mzero-caller-saved-regs"
#  unset LDFLAGS
}

post_makeinstall_target() {
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/xml2-config

  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/xml2Conf.sh
}
