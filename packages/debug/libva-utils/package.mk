# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libva-utils"
PKG_VERSION="2.6.0.pre1"
PKG_SHA256="c258f0c1bdc533c4b9a25fec04443a35a4651c7e6c6765210fe247f7320e44ff"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/libva-utils/releases"
PKG_URL="https://github.com/intel/libva-utils/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libva libdrm libX11"
PKG_LONGDESC="Libva-utils is a collection of tests for VA-API (VIdeo Acceleration API)"
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET="-Ddrm=true \
                       -Dx11=true \
                       -Dwayland=false \
                       -Dtests=false"
