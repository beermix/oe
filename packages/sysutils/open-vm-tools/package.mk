# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="open-vm-tools"
PKG_VERSION="10.3.0-8931395"
PKG_SHA256="ca5bcd62a969803015bb4ca8e2610c376487be6b6b95e7500f6684d65813b161"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vmware/open-vm-tools/releases"
PKG_URL="https://github.com/vmware/open-vm-tools/archive/${PKG_VERSION}.tar.gz"
PKG_URL="https://github.com/vmware/open-vm-tools/releases/download/stable-10.3.0/open-vm-tools-10.3.0-8931395.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse glib:host glib libdnet libtirpc"
PKG_DEPENDS_TARGET="toolchain fuse glib libdnet rpcsvc-proto:host"
PKG_SECTION="virtualization"
PKG_LONGDESC="open-vm-tools: open source implementation of VMware Tools"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-docs \
                           --disable-tests \
                           --disable-deploypkg \
                           --without-pam \
                           --without-gtk2 \
                           --without-gtkmm \
                           --without-ssl \
                           --without-x \
                           --without-xerces \
                           --without-icu \
                           --without-procps \
                           --without-kernel-modules \
                           --with-udev-rules-dir=/usr/lib/udev/rules.d/ \
                           --with-sysroot=$SYSROOT_PREFIX"

pre_configure_target() {
  export LIBS="-ldnet"
}

post_makeinstall_target() {
  rm -rf $INSTALL/sbin
  rm -rf $INSTALL/usr/share
  rm -rf $INSTALL/etc/vmware-tools/scripts/vmware/network

  find $INSTALL/etc/vmware-tools/ -type f | xargs sed -i '/.*expr.*/d'
}

post_install() {
  enable_service vmtoolsd.service
  enable_service vmware-vmblock-fuse.service
}
