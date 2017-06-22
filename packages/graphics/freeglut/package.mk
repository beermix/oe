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

PKG_NAME="freeglut"
#PKG_VERSION="FG_3_0_0"
PKG_VERSION="75cd7a2"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://freeglut.sourceforge.net"
PKG_GIT_URL="https://github.com/dcnieho/FreeGLUT"
PKG_GIT_BRANCH="git_master"
PKG_DEPENDS_TARGET="toolchain mesa libXi"
PKG_SECTION="graphics"
PKG_SHORTDESC="A library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)"
PKG_LONGDESC="A library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_SCRIPT_TARGET="freeglut/freeglut/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DFREEGLUT_BUILD_SHARED_LIBS=1 -DFREEGLUT_BUILD_STATIC_LIBS=0"