# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv) -Ddefault-accel=sna \
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-video-intel"
PKG_VERSION="3d39506"
PKG_SHA256="cfc7287fcb38028a68ffd7677032db0882c02112ad24038ee936de854761e8b3"
PKG_ARCH="x86_64"
PKG_LICENSE="OSS"
PKG_SITE="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/log/"
PKG_URL="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain libXcomposite libXxf86vm libXdamage libdrm util-macros systemd xorg-server"
PKG_SECTION="x11/driver"
PKG_SHORTDESC="xf86-video-intel: The Xorg driver for Intel video chips"
PKG_LONGDESC="The Xorg driver for Intel i810, i815, 830M, 845G, 852GM, 855GM, 865G, 915G, 915GM and 965G video chips."

PKG_MESON_OPTS_TARGET="-Ddefault-dri=2 \
			  -Dtools=false \
			  -Ddebug=no \
			  -Dbacklight=false \
			  -Dvalgrind=false \
			  -Dxvmc=false \
			  -Dbacklight-helper=false \
			  -Dxorg-module-dir=$XORG_PATH_MODULES"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/polkit-1
}
