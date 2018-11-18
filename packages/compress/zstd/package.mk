# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="zstd"
PKG_VERSION="1.3.7"
PKG_SHA256="5dd1e90eb16c25425880c8a91327f63de22891ffed082fcc17e5ae84fce0d5fb"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="https://github.com/facebook/zstd/releases"
PKG_URL="https://github.com/facebook/zstd/archive/v${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR=$PKG_NAME-$PKG_VERSION
PKG_DEPENDS_TARGET="toolchain"
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_SCRIPT="$PKG_BUILD/build/cmake/CMakeLists.txt"

PKG_CMAKE_OPTS_HOST="-DZSTD_BUILD_SHARED=0"

PKG_CMAKE_OPTS_TARGET="-DZSTD_MULTITHREAD_SUPPORT=1 -DZSTD_BUILD_PROGRAMS=0 -DZSTD_BUILD_SHARED=0"
