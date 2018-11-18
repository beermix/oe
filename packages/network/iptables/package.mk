# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="iptables"
PKG_VERSION="1.8.2"
PKG_SHA256="a3778b50ed1a3256f9ca975de82c2204e508001fc2471238c8c97f3d1c4c12af"
PKG_LICENSE="GPL"
PKG_SITE="https://netfilter.org/projects/iptables/files/?C=M;O=D"
PKG_URL="http://www.netfilter.org/projects/iptables/files/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain linux libmnl libnftnl"
PKG_TOOLCHAIN="autotools"
#PKG_BUILD_FLAGS="-hardening"

PKG_CONFIGURE_OPTS_TARGET="--disable-ipv6 --with-kernel=$(kernel_path)"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/config/iptables/
    cp -PR $PKG_DIR/config/README $INSTALL/usr/config/iptables/

  mkdir -p $INSTALL/etc/iptables/
    cp -PR $PKG_DIR/config/* $INSTALL/etc/iptables/

  mkdir -p $INSTALL/usr/lib/libreelec
    cp $PKG_DIR/scripts/iptables_helper $INSTALL/usr/lib/libreelec
}

post_install() {
  enable_service iptables.service
}

