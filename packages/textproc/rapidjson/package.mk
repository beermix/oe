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
PKG_VERSION="1.1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://rapidjson.org/"
PKG_URL="https://dl.dropboxusercontent.com/s/elne194yw5qc0w3/rapidjson-1.1.0.tar.xz"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="textproc"
PKG_SHORTDESC="rapidjson: A fast JSON parser/generator for C++ with both SAX/DOM style API"
PKG_LONGDESC="rapidjson is a fast JSON parser/generator for C++ with both SAX/DOM style API"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 \
			      -DCMAKE_BUILD_TYPE=None \
			      -DRAPIDJSON_BUILD_CXX11=1 \
			      -DBUILD_TESTING=0 \
			      -DRAPIDJSON_BUILD_DOC=0 \
			      -DRAPIDJSON_BUILD_EXAMPLES=0 \
			      -DRAPIDJSON_BUILD_TESTS=0"