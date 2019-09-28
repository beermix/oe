# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libva"
PKG_VERSION="2.5.0"
PKG_SHA256="9b6264dade6b6d3edb59c6c4f3c9217d1d5a195635fc07da875d565f58624418"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/libva/releases"
PKG_URL="https://github.com/intel/libva/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXfixes libdrm"
PKG_LONGDESC="Libva is an implementation for VA-API (VIdeo Acceleration API)."
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET="-Ddisable_drm=false \
                       -Dwith_x11=yes \
                       -Dwith_glx=no \
                       -Dwith_wayland=no \
                       -Denable_va_messaging=true \
                       -Denable_docs=false"