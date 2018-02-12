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

PKG_NAME="snappy"
PKG_VERSION="1.1.7"
PKG_ARCH="any"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="https://github.com/google/snappy/releases"
PKG_URL="https://github.com/google/snappy/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="compress"
PKG_SHORTDESC="fast real-time compression algorithm"
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0 -DSNAPPY_BUILD_TESTS=0"
PKG_CMAKE_OPTS_TARGET="$PKG_CMAKE_OPTS_HOST"

pre_configure_target() {
  export CFLAGS="-fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
}