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

PKG_NAME="re2"
PKG_VERSION="2018-03-01"
PKG_ARCH="any"
PKG_LICENSE="zlib"
PKG_SITE="https://github.com/google/re2/releases"
PKG_URL="https://github.com/google/re2/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_SECTION="devel"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0 -DBUILD_TESTING=0 -DRE2_BUILD_TESTING=0 -DUSEPCRE=0"