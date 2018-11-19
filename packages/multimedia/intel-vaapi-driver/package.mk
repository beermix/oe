# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="intel-vaapi-driver"
PKG_VERSION="2.2.0"
PKG_SHA256="13eb518bd168106a64d8e1c0f0a72e9b9937e6fd9a4c713a10f51e52508ea9b2"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/intel-vaapi-driver/releases"
PKG_URL="https://github.com/intel/intel-vaapi-driver/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libva libdrm"
#PKG_BUILD_FLAGS="+hardening"

post_unpack() {
  sed -i '1s/python$/&2/' $PKG_BUILD/src/shaders/gpp.py
  sed -i 's/2.2.0/2.2.0.0/' $PKG_BUILD/meson.build
}

PKG_MESON_OPTS_TARGET="-Dwith_x11=yes \
			  -Dwith_wayland=no \
			  -Denable_tests=false"
