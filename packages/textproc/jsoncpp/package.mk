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

PKG_NAME="jsoncpp"
PKG_VERSION="1.8.4"
PKG_SHA256="c49deac9e0933bcb7044f08516861a2d560988540b23de2ac1ad443b219afdb6"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/open-source-parsers/jsoncpp/"
PKG_URL="https://github.com/open-source-parsers/jsoncpp/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="multimedia"
PKG_SHORTDESC="A C++ library for interacting with JSON."
PKG_LONGDESC="A C++ library for interacting with JSON."
PKG_TOOLCHAIN="cmake"
PKG_BUILD_FLAGS="+pic +pic:host"

PKG_CMAKE_OPTS_TARGET="-DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF -DJSONCPP_WITH_TESTS=OFF -DJSONCPP_WITH_STRICT_ISO=OFF -DBUILD_STATIC_LIBS=ON"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"
