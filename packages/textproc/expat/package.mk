# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="expat"
PKG_VERSION="2.2.6"
PKG_SHA256="17b43c2716d521369f82fc2dc70f359860e90fa440bea65b3b85f0b246ea81f2"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/libexpat/libexpat/releases"
PKG_URL="https://github.com/libexpat/libexpat/releases/download/R_${PKG_VERSION//./_}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Expat is an XML parser library written in C."
PKG_BUILD_FLAGS="+hardening"

PKG_CMAKE_OPTS_TARGET="-DBUILD_doc=OFF -DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"

PKG_CMAKE_OPTS_HOST="-DBUILD_doc=OFF -DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"

