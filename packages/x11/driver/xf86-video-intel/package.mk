# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-video-intel"
PKG_VERSION="746ab3b"
PKG_SHA256="e8159be47615685a9fb22e32308a2d13ad18ca898e008df051c51b013e75329b"
PKG_LICENSE="OSS"
PKG_SITE="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/log/"
PKG_URL="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libXcomposite libXxf86vm libXdamage libdrm util-macros systemd xorg-server"
PKG_SECTION="x11/driver"
PKG_LONGDESC="The Xorg driver for Intel i810, i815, 830M, 845G, 852GM, 855GM, 865G, 915G, 915GM and 965G."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="-lto -gold -hardening"
# xf86-video-intel is broken enough. dont link with LTO

PKG_CONFIGURE_OPTS_TARGET="--disable-backlight \
                           --disable-backlight-helper \
                           --disable-gen4asm \
                           --enable-udev \
                           --disable-tools \
                           --enable-dri \
                           --disable-dri1 \
                           --enable-dri2 \
                           --enable-dri3 \
                           --enable-kms --enable-kms-only \
                           --disable-ums --disable-ums-only \
                           --enable-sna \
                           --enable-uxa \
                           --disable-xvmc \
                           --disable-xaa \
                           --disable-dga \
                           --disable-tear-free \
                           --disable-create2 \
                           --disable-async-swap \
                           --with-default-dri=3 \
                           --with-xorg-module-dir=$XORG_PATH_MODULES \
                           --disable-silent-rules"

pre_configure_target() {
  export CFLAGS="$CFLAGS -D_GNU_SOURCE"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/polkit-1
}
