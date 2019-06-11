# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="intel-vaapi-driver"
PKG_VERSION="205e103"
PKG_SHA256="ee4f5025215c7623990fe0aee67c085fb3812b7de92475f6787c1fc911e7bf26"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/intel-vaapi-driver"
PKG_URL="https://github.com/intel/intel-vaapi-driver/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libva libdrm"
PKG_LONGDESC="intel-vaapi-driver: VA-API user mode driver for Intel GEN Graphics family"
PKG_TOOLCHAIN="autotools"

post_unpack() {
  sed -i '1s/python$/&2/' $PKG_BUILD/src/shaders/gpp.py
}

if [ "$DISPLAYSERVER" = "x11" ]; then
  DISPLAYSERVER_LIBVA="--enable-x11 --disable-wayland"
elif [ "$DISPLAYSERVER" = "weston" ]; then
  DISPLAYSERVER_LIBVA="--disable-x11 --enable-wayland"
else
  DISPLAYSERVER_LIBVA="--disable-x11 --disable-wayland"
fi

PKG_CONFIGURE_OPTS_TARGET="--disable-silent-rules \
                           --enable-drm \
                           $DISPLAYSERVER_LIBVA"
