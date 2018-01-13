################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="zlib"
PKG_VERSION="a17fefa"
PKG_URL="https://github.com/mtl1979/zlib-ng/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="zlib-ng-$PKG_VERSION*"
PKG_DEPENDS_TARGET=""
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="compress"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DZLIB_COMPAT=1 -DWITH_GZFILEOP=1 -DWITH_OPTIM=1 -DCMAKE_BUILD_TYPE=Release"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"

post_makeinstall_host() {
  mv -f $TOOLCHAIN/share/pkgconfig/zlib.pc $TOOLCHAIN/lib/pkgconfig/zlib.pc
}

post_makeinstall_target() {
  mv -f $SYSROOT_PREFIX/usr/share/pkgconfig/zlib.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/zlib.pc
}