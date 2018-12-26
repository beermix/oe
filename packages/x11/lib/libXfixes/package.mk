# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXfixes"
PKG_VERSION="5.0.3"
PKG_SHA256="de1cd33aff226e08cefd0e6759341c2c8e8c9faf8ce9ac6ec38d43e287b22ad6"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11"
PKG_LONGDESC="X Fixes Library"

pre_configure_target() {
  export CFLAGS="$CFLAGS -O3 -Os -fdata-sections -ffat-lto-objects -ffunction-sections -flto -fno-semantic-interposition"
  export CXXFLAGS="$CXXFLAGS -O3 -Os -fdata-sections -ffat-lto-objects -ffunction-sections -flto -fno-semantic-interposition"
}
