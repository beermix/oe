# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="zstd"
PKG_VERSION="1.4.4"
PKG_SHA256="59ef70ebb757ffe74a7b3fe9c305e2ba3350021a918d168a046c6300aeea9315"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="https://github.com/facebook/zstd/releases"
PKG_URL="https://github.com/facebook/zstd/releases/download/v${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
#PKG_URL="https://github.com/facebook/zstd/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="gcc:host ninja:host meson:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A fast real-time compression algorithm."
PKG_TOOLCHAIN="meson"

configure_package() {
  PKG_MESON_SCRIPT="${PKG_BUILD}/build/meson/meson.build"
}

PKG_MESON_OPTS_HOST="-Ddebug_level=0 \
		       -Dstatic_runtime=false \
		       -Dbin_programs=false \
		       -Ddefault_library=static"

PKG_MESON_OPTS_TARGET="-Ddebug_level=0 \
                       -Dstatic_runtime=true \
                       -Dbin_programs=false \
                       -Ddefault_library=static"
