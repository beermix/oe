# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="expat"
PKG_VERSION="2.2.7"
PKG_SHA256="30e3f40acf9a8fdbd5c379bdcc8d1178a1d9af306de29fc8ece922bc4c57bef8"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/libexpat/libexpat/releases"
PKG_URL="https://github.com/libexpat/libexpat/releases/download/R_${PKG_VERSION//./_}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Expat is an XML parser library written in C."
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DBUILD_doc=OFF \
			  -DBUILD_tools=OFF \
			  -DBUILD_examples=OFF \
			  -DBUILD_tests=OFF \
			  -DBUILD_shared=ON"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"

