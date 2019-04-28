# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="configtools"
PKG_VERSION="798218fde97a422ce8a0f6a654d3c56204507364"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_SITE="http://git.savannah.gnu.org/cgit/config.git"
PKG_URL="http://git.savannah.gnu.org/cgit/config.git/snapshot/$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST=""
PKG_LONGDESC="configtools"
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  mkdir -p $TOOLCHAIN/configtools
  cp config.* $TOOLCHAIN/configtools
}
