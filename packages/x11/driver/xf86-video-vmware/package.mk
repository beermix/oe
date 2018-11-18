# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-video-vmware"
PKG_VERSION="13.3.0"
PKG_SHA256="47971924659e51666a757269ad941a059ef5afe7a47b5101c174a6022ac4066c"
PKG_LICENSE="OSS"
PKG_SITE="http://www.vmware.com"
PKG_URL="http://xorg.freedesktop.org/releases/individual/driver/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain mesa libX11 xorg-server"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-vmwarectrl-client \
                           --with-xorg-module-dir=$XORG_PATH_MODULES"

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-fno-plt||"
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-fno-plt||"
  LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-z,now||"` sed -e "s|,-z,now||"`
}