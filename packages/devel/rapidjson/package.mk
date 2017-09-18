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

PKG_NAME="rapidjson"
PKG_VERSION="v1.1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://rapidjson.org/"
PKG_GIT_URL="https://github.com/miloyip/rapidjson.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="rapidjson: JSON parser/generator"
PKG_LONGDESC="A fast JSON parser/generator for C++ with both SAX/DOM style API"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DRAPIDJSON_BUILD_DOC=OFF \
                       -DRAPIDJSON_BUILD_EXAMPLES=OFF
                       -DRAPIDJSON_BUILD_TESTS=OFF \
                       -DRAPIDJSON_BUILD_THIRDPARTY_GTEST=OFF \
                       -DRAPIDJSON_BUILD_ASAN=OFF \
                       -DRAPIDJSON_BUILD_UBSAN=OFF \
                       -DRAPIDJSON_HAS_STDSTRING=ON"
