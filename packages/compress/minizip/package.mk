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

PKG_NAME="minizip"
PKG_VERSION="98cd93d"
#PKG_SHA256="5666b5ee3e85dfd2dd119970613c12e6267d31813f07d3ffa5d359fe272cb6d1"
PKG_ARCH="any"
PKG_LICENSE="zlib"
PKG_SITE="https://github.com/nmoinvaz/minizip"
PKG_URL="https://github.com/nmoinvaz/minizip/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="zlib libbsd"
PKG_SECTION="compress"
PKG_SHORTDESC="Minizip zlib contribution fork with latest bug fixes"
PKG_LONGDESC="Minizip zlib contribution fork with latest bug fixes"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DUSE_AES=OFF -DBUILD_TEST=ON"

makeinstall_target() {
  cp -v minizip $SYSROOT_PREFIX/usr/bin/minizip
}
