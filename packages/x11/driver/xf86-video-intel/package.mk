################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2018-present Team LibreELEC
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="xf86-video-intel"
PKG_VERSION="3d39506"
PKG_ARCH="x86_64"
PKG_LICENSE="OSS"
PKG_SITE="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/log/"
PKG_URL="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain libXcomposite libXxf86vm libXdamage util-macros systemd xorg-server"
#PKG_DEPENDS_TARGET="toolchain libXcomposite libXxf86vm libXdamage util-macros systemd xorg-server libXtst libXScrnSaver libXcursor libSM"
#PKG_DEPENDS_TARGET="toolchain libXcomposite libXxf86vm libXdamage util-macros systemd xorg-server xcb-util libXvMC libXtst libXcursor libXScrnSaver"
PKG_SECTION="x11/driver"
PKG_SHORTDESC="xf86-video-intel: The Xorg driver for Intel video chips"
PKG_LONGDESC="The Xorg driver for Intel i810, i815, 830M, 845G, 852GM, 855GM, 865G, 915G, 915GM and 965G video chips."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="-lto -hardening"

PKG_CONFIGURE_OPTS_TARGET="--disable-backlight \
                           --disable-backlight-helper \
                           --disable-gen4asm \
                           --enable-udev \
                           --disable-tools \
                           --with-default-dri=3 \
                           --with-xorg-module-dir=$XORG_PATH_MODULES"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/polkit-1
}
