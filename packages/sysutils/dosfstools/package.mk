# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="dosfstools"
PKG_VERSION="4.1"
PKG_SHA256="e6b2aca70ccc3fe3687365009dd94a2e18e82b688ed4e260e04b7412471cc173"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/dosfstools/dosfstools"
PKG_URL="https://github.com/dosfstools/dosfstools/releases/download/v$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="gcc:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_INIT="toolchain dosfstools"
PKG_LONGDESC="dosfstools contains utilities for making and checking MS-DOS FAT filesystems."

make_init() {
  : # reuse make_target()
}

