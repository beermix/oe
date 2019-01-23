# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-video-intel"
PKG_VERSION="33ee0c3b21ea279e08d0863fcb2e874f0974b00e"
PKG_SHA256=""
PKG_LICENSE="OSS"
PKG_SITE="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/log"
PKG_URL="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libXcomposite libXxf86vm libXdamage libdrm util-macros systemd xorg-server libXvMC libXtst libxss"
PKG_LONGDESC="The Xorg driver for Intel i810, i815, 830M, 845G, 852GM, 855GM, 865G, 915G, 915GM and 965G."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="-lto -gold -hardening"
# xf86-video-intel is broken enough. dont link with LTO

PKG_CONFIGURE_OPTS_TARGET="--disable-backlight \
                           --disable-backlight-helper \
                           --with-default-dri=2 \
                           --with-xorg-module-dir=$XORG_PATH_MODULES"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -D_GNU_SOURCE"
#}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/polkit-1
}
