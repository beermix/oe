# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="yasm"
PKG_VERSION="bcc01c5"
PKG_SHA256="8f56152f5997eef9e1980e6133c0c3da6feed154f02bd04e8ef1253f0aae38c8"
PKG_SITE="https://github.com/yasm/yasm"
PKG_URL="https://github.com/yasm/yasm/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host autotools:host autoconf:host re2c:host nasm:host cmake:host"
PKG_SHORTDESC="yasm: A complete rewrite of the NASM assembler"
PKG_TOOLCHAIN="cmake-make"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-debug \
		           --disable-warnerror \
		           --disable-profiling \
		           --disable-python-bindings"
                         
PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DENABLE_NLS=OFF -DBUILD_SHARED_LIBS=OFF"