# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXcomposite"
PKG_VERSION="0.4.4"
PKG_SHA256="ede250cd207d8bee4a338265c3007d7a68d5aca791b6ac41af18e9a2aeb34178"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libXfixes libXext libX11"
PKG_LONGDESC="X Composite Library"

pre_configure_target() {
  export CFLAGS="$CFLAGS -Os -fdata-sections -ffunction-sections -fno-semantic-interposition"
  export CXXFLAGS="$CXXFLAGS -Os -fdata-sections -ffunction-sections -fno-semantic-interposition"
}
