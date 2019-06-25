# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libva-utils"
PKG_VERSION="fbb1720"
PKG_SHA256="2166181d320b79929fd6d1b9b9316b71b79536caf5e8bb52262da26d02cc3330"
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
