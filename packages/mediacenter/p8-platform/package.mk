# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="p8-platform"
PKG_VERSION="38343e0"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_URL="https://github.com/Pulse-Eight/platform/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Platform support library used by libCEC and binary add-ons for Kodi"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_INSTALL_LIBDIR:STRING=lib \
                       -DCMAKE_INSTALL_LIBDIR_NOARCH:STRING=lib \
                       -DCMAKE_INSTALL_PREFIX_TOOLCHAIN=$SYSROOT_PREFIX/usr \
                       -DBUILD_SHARED_LIBS=0"

post_makeinstall_target() {
  rm -rf $INSTALL/usr
}
