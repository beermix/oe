# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libva-utils"
PKG_VERSION="2.5.0"
PKG_SHA256="d6c37257933731c7936775376388dfe6c9ebc460adff29f9ffe74cde2ebb3f52"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/libva-utils/releases"
PKG_URL="https://github.com/intel/libva-utils/archive/$PKG_VERSION.tar.gz"
PKG_LONGDESC="Libva-utils is a collection of tests for VA-API (VIdeo Acceleration API)"
PKG_TOOLCHAIN="autotools"

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="toolchain libva libdrm libX11"
  DISPLAYSERVER_LIBVA="--enable-x11"
else
  PKG_DEPENDS_TARGET="toolchain libva libdrm"
  DISPLAYSERVER_LIBVA="--disable-x11"
fi

PKG_CONFIGURE_OPTS_TARGET="--disable-silent-rules \
                           --enable-drm \
                           $DISPLAYSERVER_LIBVA \
                           --disable-wayland \
                           --disable-tests"
