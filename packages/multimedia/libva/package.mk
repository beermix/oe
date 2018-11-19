# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libva"
PKG_VERSION="2.3.0"
PKG_SHA256="8d95e65c4d84d0f82097581e163d3770694c600cbb040ebd827f2d375e004f4b"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/libva/releases"
PKG_URL="https://github.com/intel/libva/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="libX11 libXext libXfixes libdrm"

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O2 -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math|"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O2 -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math|"`
}

PKG_MESON_OPTS_TARGET="-Ddocs=false \
			  -Ddisable_drm=false \
			  -Dwith_x11=yes \
			  -Dwith_wayland=no \
			  -Denable_docs=false"
