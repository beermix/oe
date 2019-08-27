# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="usbutils"
PKG_VERSION="012"
PKG_SHA256="88634625f91840bc1993d2731cc081ee8d3b13d56069a95bdd6ac6ef0e063e46"
PKG_LICENSE="GPL"
PKG_SITE="http://www.linux-usb.org/"
PKG_URL="http://kernel.org/pub/linux/utils/usb/usbutils/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libusb systemd"
PKG_LONGDESC="This package contains various utilities for inspecting and setting of devices connected to the USB bus."
PKG_TOOLCHAIN="autotools"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/lsusb.py
  rm -rf $INSTALL/usr/bin/usbhid-dump
}
