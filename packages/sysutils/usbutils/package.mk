# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="usbutils"
PKG_VERSION="010"
PKG_SHA256="61c7364bb4986fb05e5067e4ac5585b1299b664c57f761caecd2e9e724794a19"
PKG_LICENSE="GPL"
PKG_SITE="http://www.linux-usb.org/"
PKG_URL="http://kernel.org/pub/linux/utils/usb/usbutils/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libusb systemd"
PKG_SECTION="system"
PKG_LONGDESC="This package contains various utilities for inspecting and setting of devices connected to the USB bus. Requires a kernel version including usbdevfs support - and this usbdevfs mounted to /proc/bus/usb."

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/lsusb.py
  rm -rf $INSTALL/usr/bin/usbhid-dump
}
