# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libevdev"
PKG_VERSION="1.5.9"
PKG_SHA256="e1663751443bed9d3e76a4fe2caf6fa866a79705d91cacad815c04e706198a75"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.freedesktop.org/wiki/Software/libevdev/"
PKG_URL="http://www.freedesktop.org/software/libevdev/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="libevdev: a wrapper library for evdev devices."
PKG_LONGDESC="libevdev is a wrapper library for evdev devices. it moves the common tasks when dealing with evdev devices into a library and provides a library interface to the callers, thus avoiding erroneous ioctls, etc."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared --disable-static"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
