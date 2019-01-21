# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libgpg-error"
PKG_VERSION="1.33"
PKG_SHA256="5d38826656e746c936e7742d9cde072b50baa3c4c49daa168a56813612bf03ff"
PKG_LICENSE="GPLv2"
PKG_SITE="https://www.gnupg.org"
PKG_URL="https://www.gnupg.org/ftp/gcrypt/libgpg-error/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A library that defines common error values for all GnuPG components."

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="CC_FOR_BUILD=$HOST_CC --enable-static --disable-shared --disable-nls --disable-rpath --with-gnu-ld --with-pic"

# inspired by openembedded
  case ${TARGET_ARCH} in
    aarch64)
      GPGERROR_TUPLE=aarch64-unknown-linux-gnu
      GPGERROR_TARGET=linux-gnueabi
      ;;
    arm)
      GPGERROR_TUPLE=arm-unknown-linux-gnueabi
      GPGERROR_TARGET=linux-gnueabi
      ;;
    i386)
      GPGERROR_TUPLE=i486-pc-linux-gnu
      GPGERROR_TARGET=linux-gnu
      ;;
    x86_64)
      GPGERROR_TUPLE=x86_64-pc-linux-gnu
      GPGERROR_TARGET=linux-gnu
      ;;
  esac

  cp $PKG_BUILD/src/syscfg/lock-obj-pub.$GPGERROR_TUPLE.h $PKG_BUILD/src/syscfg/lock-obj-pub.$GPGERROR_TARGET.h
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/share

  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i src/gpg-error-config
  cp src/gpg-error-config $SYSROOT_PREFIX/usr/bin
}
