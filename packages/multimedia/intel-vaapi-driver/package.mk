# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="intel-vaapi-driver"
PKG_VERSION="e60af21"
PKG_SHA256="ae2f89351975050a3f56f979496027a3486e575c74b2a415870e2c1e8a419fc7"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/intel-vaapi-driver/releases"
PKG_URL="https://github.com/intel/intel-vaapi-driver/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libva libdrm"
PKG_LONGDESC="intel-vaapi-driver: VA-API user mode driver for Intel GEN Graphics family"
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET="-Dwith_x11=yes \
                       -Dwith_wayland=no \
                       -Denable_hybrid_codec=true \
                       -Denable_tests=false"