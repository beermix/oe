################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
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

PKG_NAME="lz4"
PKG_VERSION="1.8.1.2"
PKG_SHA256="12f3a9e776a923275b2dc78ae138b4967ad6280863b77ff733028ce89b8123f9"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/lz4/lz4/releases"
PKG_URL="https://github.com/lz4/lz4/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET=""
PKG_SECTION="compress"
PKG_SHORTDESC="lz4 data compressor/decompressor"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_SCRIPT="$PKG_BUILD/contrib/cmake_unofficial/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0 -DCMAKE_POSITION_INDEPENDENT_CODE=1"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL
}
