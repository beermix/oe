# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="media-driver"
PKG_VERSION="f6eca7f"
PKG_SHA256="9d1a0472c407d0f2997d1ebd375926075677fea69c7745ed2ca03f53a8f0ba83"
PKG_ARCH="x86_64"
PKG_LICENSE="MIT"
PKG_SITE="https://01.org/linuxmedia"
PKG_URL="https://github.com/intel/media-driver/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libva libdrm gmmlib"
PKG_LONGDESC="media-driver: The Intel(R) Media Driver for VAAPI is a new VA-API (Video Acceleration API) user mode driver supporting hardware accelerated decoding, encoding, and video post processing for GEN based graphics hardware."

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DENABLE_NONFREE_KERNELS=OFF -DBUILD_KERNELS=OFF"
