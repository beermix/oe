# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXau"
PKG_VERSION="1.0.9"
PKG_SHA256="ccf8cbf0dbf676faa2ea0a6d64bcc3b6746064722b606c8c52917ed00dcb73ec"
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
