# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXau"
PKG_VERSION="1.0.8"
PKG_SHA256="fdd477320aeb5cdd67272838722d6b7d544887dfe7de46e1e7cc0c27c2bea4f2"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros xorgproto"
PKG_LONGDESC="X authorization file management libary"

PKG_CONFIGURE_OPTS_TARGET="--enable-xthreads"

pre_configure_target() {
  export CFLAGS="$CFLAGS -Os -fdata-sections -ffunction-sections -fno-semantic-interposition"
  export CXXFLAGS="$CXXFLAGS -Os -fdata-sections -ffunction-sections -fno-semantic-interposition"
}
