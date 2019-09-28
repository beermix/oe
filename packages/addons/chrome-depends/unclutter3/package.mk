# SPDX-License-Identifier: GPL-2.0-or-later-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="unclutter"
PKG_VERSION="d505b8ea9c8081ec8085cc9bfb54ffa59e09fc0d"
PKG_SHA256=""
PKG_LICENSE="Public Domain"
PKG_SITE="https://github.com/Airblader/unclutter-xfixes"
PKG_URL="http://jaist.dl.sourceforge.net/project/unclutter/unclutter/source_$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/Airblader/unclutter-xfixes/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="unclutter-xfixes-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain libX11 libev"
PKG_SHORTDESC="Unclutter: Hide X11 Cursor"
PKG_LONGDESC="Unclutter runs in the background of an X11 session and after a specified period of inactivity hides the cursor from display. When the cursor is moved its display is restored. Users may specify specific windows to be ignored by unclutter."

pre_configure_target() {
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS
}

makeinstall_target() {
  mkdir -p .install_pkg/usr/bin
  install -m 755 unclutter .install_pkg/usr/bin/
}
