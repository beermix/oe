# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="intel-vaapi-driver"
PKG_VERSION="2.3.0"
PKG_SHA256="fcc3f09291e58fd316fd015d4e1329e7e03c38cffa4651bda725d500a66aa74e"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/intel-vaapi-driver/releases"
PKG_URL="https://github.com/intel/intel-vaapi-driver/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libva libdrm"
PKG_LONGDESC="intel-vaapi-driver: VA-API user mode driver for Intel GEN Graphics family"
PKG_TOOLCHAIN="meson"

post_unpack() {
  sed -i '1s/python$/&2/' $PKG_BUILD/src/shaders/gpp.py

  # Fix undefined variable in src/meson.build
  sed -i 's/2.2.0/2.2.0.0/' $PKG_BUILD/meson.build
}

PKG_MESON_OPTS_TARGET="-Dwith_x11=yes \
                       -Dwith_wayland=no \
                       -Denable_hybrid_codec=true"
