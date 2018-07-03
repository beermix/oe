################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="unclutter"
PKG_VERSION="1.09"
PKG_SHA256="3a53575fe2a75a34bc9a2b0ad92ee0f8a7dbedc05d8783f191c500060a40a9bd"
PKG_ARCH="any"
PKG_LICENSE="Public Domain"
PKG_SITE="https://sourceforge.net/projects/unclutter/"
PKG_URL="https://sourceforge.net/projects/unclutter/unclutter/source_$PKG_VERSION/unclutter-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11"
PKG_LONGDESC="Unclutter runs in the background of an X11 session and hides the X11 Cursor."

make_target() {
  rm -f Makefile
  LDFLAGS="$LDFLAGS -lX11" $MAKE unclutter
}

makeinstall_target() {
  mkdir -p .install_pkg/usr/bin
  install -m 755 unclutter .install_pkg/usr/bin/
}
