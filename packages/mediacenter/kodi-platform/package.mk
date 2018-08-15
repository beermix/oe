# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="kodi-platform"
PKG_VERSION="c8188d8"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_URL="https://github.com/xbmc/kodi-platform/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain tinyxml $MEDIACENTER p8-platform"
PKG_SECTION="multimedia"
PKG_SHORTDESC="kodi-platform:"
PKG_LONGDESC="kodi-platform:"
#PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_INSTALL_LIBDIR:STRING=lib \
                       -DCMAKE_INSTALL_LIBDIR_NOARCH:STRING=lib \
                       -DCMAKE_INSTALL_PREFIX_TOOLCHAIN=$SYSROOT_PREFIX/usr \
                       -DBUILD_SHARED_LIBS=0"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/lib/kodiplatform
}
