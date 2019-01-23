# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="pciutils"
PKG_VERSION="3.6.2"
PKG_SHA256="db452ec986edefd88af0d222d22f6102f8030a8633fdfe846c3ae4bde9bb93f3"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://mj.ucw.cz/pciutils.shtml"
PKG_URL="http://www.kernel.org/pub/software/utils/pciutils/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain kmod systemd"
PKG_LONGDESC="Utilities for inspecting devices connected to the PCI bus and the PCI vendor/product ID database."

PKG_MAKE_OPTS="PREFIX=/usr SHARED=no STRIP= IDSDIR=/usr/share"
PKG_MAKE_OPTS2="PREFIX=/usr SHARED=yes STRIP= IDSDIR=/usr/share"

make_target() {
  make OPT="$CFLAGS" \
       CROSS_COMPILE=${TARGET_PREFIX} \
       HOST=$TARGET_ARCH-linux \
       $PKG_MAKE_OPTS \
       ZLIB=no DNS=no LIBKMOD=yes HWDB=yes

  make OPT="$CFLAGS" \
       CROSS_COMPILE=${TARGET_PREFIX} \
       HOST=$TARGET_ARCH-linux \
       $PKG_MAKE_OPTS2 \
       ZLIB=no DNS=no LIBKMOD=yes HWDB=yes
}

makeinstall_target() {
    make $PKG_MAKE_OPTS DESTDIR=$INSTALL install
    make $PKG_MAKE_OPTS2 DESTDIR=$INSTALL install
}


post_makeinstall_target() {
  rm -rf $INSTALL/usr/sbin/setpci
  rm -rf $INSTALL/usr/sbin/update-pciids
  rm -rf $INSTALL/usr/share
}
