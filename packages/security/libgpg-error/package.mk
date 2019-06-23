# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libgpg-error"
PKG_VERSION="1.36"
PKG_SHA256="babd98437208c163175c29453f8681094bcaf92968a15cafb1a276076b33c97c"
PKG_LICENSE="GPLv2"
PKG_SITE="https://www.gnupg.org"
PKG_URL="https://www.gnupg.org/ftp/gcrypt/libgpg-error/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A library that defines common error values for all GnuPG components."

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="CC_FOR_BUILD=$HOST_CC  --disable-nls --disable-rpath"

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
    x86_64)
      GPGERROR_TUPLE=x86_64-unknown-linux-gnu
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
