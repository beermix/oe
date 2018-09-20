# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="timepng"
PKG_VERSION="0.0.1"
PKG_REV="100"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain libpng"
PKG_SECTION="tools"
PKG_SHORTDESC="tool to time png loading"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="timepng"
PKG_ADDON_TYPE="xbmc.python.script"

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin/
    cp -P $(get_build_dir timepng)/timepng $ADDON_BUILD/$PKG_ADDON_ID/bin
}
