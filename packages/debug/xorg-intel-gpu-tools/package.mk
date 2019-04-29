# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xorg-intel-gpu-tools"
PKG_VERSION="4b728a5"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain cairo procps-ng elfutils libXv"
PKG_SITE="https://github.com/freedesktop/xorg-intel-gpu-tools"
PKG_URL="https://github.com/freedesktop/xorg-intel-gpu-tools/archive/$PKG_VERSION.tar.gz"
PKG_LONGDESC="Test suite and tools for DRM/KMS drivers"
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET="-Dbuild_overlay=true \
                       -Dbuild_man=false \
                       -Dwith_valgrind=false \
                       -Dbuild_audio=false \
                       -Dbuild_chamelium=false \
                       -Dbuild_docs=false \
                       -Dbuild_tests=true
                       -Dwith_libdrm=intel \
                       -Dwith_libunwind=false \
                       -Dbuild_runner=false"