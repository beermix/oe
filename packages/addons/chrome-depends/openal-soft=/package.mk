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

PKG_NAME="openal-soft"
PKG_VERSION="openal-soft-1.18.2"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="https://github.com/kcat/openal-soft/releases"
PKG_URL="https://github.com/kcat/openal-soft/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libjpeg-turbo"
PKG_SECTION="graphics"
PKG_SHORTDESC="jasper: JPEG-2000 Part-1 standard (i.e., ISO/IEC 15444-1) implementation"
PKG_LONGDESC="This distribution contains the public release of the an open-source implementation of the ISO/IEC 15444-1 also known as JPEG-2000 standard for image compression."
PKG_TOOLCHAIN="cmake-make"


PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"