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

PKG_NAME="zstd"
PKG_VERSION="1.3.4"
PKG_SHA256="92e41b6e8dd26bbd46248e8aa1d86f1551bc221a796277ae9362954f26d605a9"
PKG_ARCH="any"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="https://github.com/facebook/zstd/releases"
PKG_URL="https://github.com/facebook/zstd/archive/v${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR=$PKG_NAME-$PKG_VERSION
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="compress"
PKG_SHORTDESC="fast real-time compression algorithm"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CMAKE_SCRIPT="$PKG_BUILD/build/cmake/CMakeLists.txt"

PKG_CMAKE_OPTS_HOST="-DZSTD_MULTITHREAD_SUPPORT=0 -DZSTD_BUILD_PROGRAMS=0 ZSTD_-DLZMA_SUPPORT=0 -DZSTD_ZLIB_SUPPORT=0"
PKG_CMAKE_OPTS_TARGET="-DZSTD_MULTITHREAD_SUPPORT=1 -DZSTD_BUILD_PROGRAMS=0 -DZSTD_BUILD_SHARED=0 -DLZMA_SUPPORT=1 -DZSTD_ZLIB_SUPPORT=1"