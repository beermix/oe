# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libzip"
PKG_VERSION="1.4.0"
PKG_SHA256="e508aba025f5f94b267d5120fc33761bcd98440ebe49dbfe2ed3df3afeacc7b1"
PKG_LICENSE="GPL"
PKG_SITE="http://www.bzip.org"
PKG_URL="https://nih.at/libzip/libzip-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_BUILD_FLAGS="+pic +pic:host"

PKG_CMAKE_OPTS_TARGET="-BUILD_SHARED_LIBS=1 -DCMAKE_BUILD_TYPE=Release"
PKG_CMAKE_OPTS_HOST="-BUILD_SHARED_LIBS=1 -DCMAKE_BUILD_TYPE=Release"
