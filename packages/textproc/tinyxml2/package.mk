# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="tinyxml2"
PKG_VERSION="7.0.0"
PKG_SHA256="fa0d1c745d65d4d833e62cb183e23c2034dc7a35ec1a4977e808bdebb9b4fe60"
PKG_LICENSE="zlib"
PKG_URL="https://github.com/leethomason/tinyxml2/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="textproc"
PKG_LONGDESC="TinyXML2 is a simple, small, C++ XML parser."
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=off -DBUILD_STATIC_LIBS=on"


