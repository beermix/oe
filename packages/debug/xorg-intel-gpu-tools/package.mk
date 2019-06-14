# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xorg-intel-gpu-tools"
PKG_VERSION="ff711b343c06a25ac4995ab8bd9a8bcb5ce1eb10"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain cairo procps-ng elfutils libXv peg:host"
PKG_SITE="https://github.com/freedesktop/xorg-intel-gpu-tools"
PKG_URL="https://github.com/freedesktop/xorg-intel-gpu-tools/archive/$PKG_VERSION.tar.gz"
PKG_LONGDESC="Test suite and tools for DRM/KMS drivers"
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET="-Dbuild_overlay=enabled \
                       -Doverlay_backends=x,xv \
                       -Dwith_valgrind=disabled \
                       -Dbuild_man=disabled \
                       -Dbuild_audio=false \
                       -Dbuild_chamelium=disabled \
                       -Dbuild_docs=disabled \
                       -Dbuild_tests=disabled \
                       -Dwith_libdrm=intel \
                       -Dwith_libunwind=disabled \
                       -Dbuild_runner=disabled"