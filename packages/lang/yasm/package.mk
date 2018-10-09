# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="yasm"
PKG_VERSION="35af972"
PKG_SITE="https://github.com/yasm/yasm"
PKG_URL="https://github.com/yasm/yasm/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host re2c:host nasm:host"
PKG_SECTION="toolchain/lang"
PKG_SHORTDESC="yasm: A complete rewrite of the NASM assembler"
PKG_LONGDESC="Yasm is a complete rewrite of the NASM assembler under the new BSD License (some portions are under other licenses, see COPYING for details). It is designed from the ground up to allow for multiple assembler syntaxes to be supported (eg, NASM, TASM, GAS, etc.) in addition to multiple output object formats and even multiple instruction sets. Another primary module of the overall design is an optimizer module."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-debug \
                         --disable-warnerror \
                         --disable-profiling \
                         --disable-gcov \
                         --disable-python-bindings \
                         --enable-nls \
                         --disable-rpath \
                         --without-dmalloc \
                         --with-gnu-ld \
                         --without-libiconv-prefix \
                         --without-libintl-prefix"