# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mrxvt"
PKG_VERSION="0.5.4"
PKG_SHA256="f403ad5a908fcd38a55ed0a7e1b85584cb77be8781199653a39b8af1a9ad10d7"
PKG_LICENSE="GPL"
PKG_SITE="http://materm.sourceforge.net/"
PKG_URL="$SOURCEFORGE_SRC/materm/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_setpgrp_void=no --sysconfdir=/storage/.config/mrxvt --datadir=/storage/.config/mrxvt"

#makeinstall_target() {
#  : # nop
#}
