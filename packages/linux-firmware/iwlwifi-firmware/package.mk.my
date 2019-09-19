# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="iwlwifi-firmware"
#PKG_VERSION="8d85157324d4a86a6525ec1e577ff95b760aa764"
#PKG_SHA256="519ae24d22145b7c40ec2fb4dbd1fde63c328c3e2f3cb2e2981b6fd9de7d5326"
PKG_LICENSE="Free-to-use"
PKG_SITE="https://github.com/LibreELEC/iwlwifi-firmware"
PKG_URL="https://github.com/LibreELEC/iwlwifi-firmware/archive/$PKG_VERSION.tar.gz"
PKG_VERSION="d7e0fb4"
PKG_SHA256="eea915c5e323e179d5b1655076c62e59ee6b603a961c5de224b7948278727936"
PKG_URL="https://github.com/beermix/iwlwifi-firmware/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="iwlwifi-firmware: firmwares for various Intel WLAN drivers"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  DESTDIR=$INSTALL/$(get_kernel_overlay_dir) ./install
}
