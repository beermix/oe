# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="yasm"
PKG_VERSION="ea8f239"
PKG_SHA256="85de609061b52062539dd1b936ab299fe8f6bf05f8d264311a7cb3c36bc8bc2c"
PKG_SITE="https://github.com/yasm/yasm"
PKG_URL="https://github.com/yasm/yasm/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="cmake:host re2c:host "
PKG_SHORTDESC="yasm: A complete rewrite of the NASM assembler"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DENABLE_NLS=OFF -DBUILD_SHARED_LIBS=OFF"