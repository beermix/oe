# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="expat"
PKG_VERSION="2.2.6"
PKG_SHA256="17b43c2716d521369f82fc2dc70f359860e90fa440bea65b3b85f0b246ea81f2"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/libexpat/libexpat/releases"
PKG_URL="https://github.com/libexpat/libexpat/releases/download/R_${PKG_VERSION//./_}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="cmake:host"
PKG_LONGDESC="Expat is an XML parser library written in C."

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DBUILD_examples=0 \
			  -DBUILD_shared=1 \
			  -DBUILD_tests=0 \
			  -DBUILD_tools=0"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"

PKG_CONFIGURE_OPTS_TARGET="--without-docbook"
PKG_CONFIGURE_OPTS_HOST="--without-docbook"
