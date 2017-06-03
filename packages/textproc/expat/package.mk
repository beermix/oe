################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="expat"
PKG_VERSION="afd0805"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://expat.sourceforge.net/"
PKG_GIT_URL="https://github.com/libexpat/libexpat"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="textproc"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_SCRIPT_TARGET="expat/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DBUILD_doc=OFF \
			  -DBUILD_tools=OFF \
			  -DBUILD_examples=OFF \
			  -DBUILD_tests=OFF \
			  -DBUILD_shared=ON"
			  
PKG_CMAKE_SCRIPT_HOST="expat/CMakeLists.txt"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"
			  
pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
}