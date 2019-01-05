# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="tinyxml2"
PKG_VERSION="7.0.1"
PKG_SHA256="a381729e32b6c2916a23544c04f342682d38b3f6e6c0cad3c25e900c3a7ef1a6"
PKG_LICENSE="zlib"
PKG_URL="https://github.com/leethomason/tinyxml2/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="TinyXML2 is a simple, small, C++ XML parser."
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=off -DBUILD_STATIC_LIBS=on"

