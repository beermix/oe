################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
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

PKG_NAME="dstat-system"
PKG_VERSION="4c47a34"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://dag.wiee.rs/home-made/dstat"
PKG_URL="https://github.com/dagwieers/dstat/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="dstat-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain Python"
PKG_SECTION="tools"
PKG_SHORTDESC="Versatile resource statistics tool"
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

make_target() {
  :
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/share
  cp dstat $INSTALL/usr/bin/
  cp -R plugins $INSTALL/usr/share/dstat
}
