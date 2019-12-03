# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="wireguard"
PKG_VERSION="0.0.20191127"
PKG_SHA256="7d4e80a6f84564d4826dd05da2b59e8d17645072c0345d0fc0d197be176c3d06"
PKG_LICENSE="GPLv2"
PKG_SITE="https://git.zx2c4.com/WireGuard"
PKG_URL="https://git.zx2c4.com/WireGuard/snapshot/WireGuard-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux libmnl"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="The WireGuard VPN kernel module and tools"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  kernel_make KERNELDIR=$(kernel_path) -C src/ module tools
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/wg-config $INSTALL/usr/bin
    cp $PKG_DIR/scripts/wg-quick $INSTALL/usr/bin
    cp $PKG_BUILD/src/tools/wg $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/template
    cp $PKG_DIR/template/wg0.conf $INSTALL/usr/template
    cp $PKG_DIR/template/wgnet $INSTALL/usr/template

  mkdir -p $INSTALL/usr/config
    cp $PKG_DIR/config/wireguard.conf.sample $INSTALL/usr/config

  mkdir -p $INSTALL/etc/wireguard
    ln -sf /run/libreelec/wireguard/wg0.conf $INSTALL/etc/wireguard/wg0.conf

  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
    cp src/*.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME
}

post_install() {
  enable_service wireguard-config.service
}
