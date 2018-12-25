# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="intel-vaapi-driver"
PKG_VERSION="2.3.0"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/intel-vaapi-driver/releases"
PKG_URL="https://github.com/intel/intel-vaapi-driver/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libva libdrm"

post_unpack() {
  # Only relevant if intel-gpu-tools is installed,
  # since then the shaders will be recompiled
  sed -i '1s/python$/&2/' $PKG_BUILD//src/shaders/gpp.py
  # Fix undefined variable in src/meson.build
  sed -i 's/2.2.0/2.2.0.0/' $PKG_BUILD//meson.build
}

#pre_configure_target() {
#  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O2 -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math|"`
#  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O2 -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math|"`
#}

PKG_MESON_OPTS_TARGET="-Dwith_x11=yes \
			  -Dwith_wayland=no \
			  -Denable_tests=false"
