# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libssh2"
PKG_VERSION="1.8.2"
PKG_SHA256="088307d9f6b6c4b8c13f34602e8ff65d21c2dc4d55284dfe15d502c4ee190d67"
PKG_LICENSE="BSD"
PKG_SITE="https://www.libssh2.org"
PKG_URL="https://www.libssh2.org/download/libssh2-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_LONGDESC="A library implementing the SSH2 protocol"
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DBUILD_EXAMPLES=OFF \
                       -DBUILD_TESTING=OFF"
