# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="unclutter"
PKG_VERSION="b450d78"
PKG_SHA256=""
PKG_LICENSE="Public Domain"
PKG_SITE="https://github.com/Airblader/unclutter-xfixes"
PKG_URL="https://github.com/Airblader/unclutter-xfixes/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libev libX11"
PKG_LONGDESC="Unclutter runs in the background of an X11 session and hides the X11 Cursor."

makeinstall_target() {
  mkdir -p .install_pkg/usr/bin
  install -m 755 unclutter .install_pkg/usr/bin/
}
