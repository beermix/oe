# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="media-driver"
PKG_VERSION="baab321"
PKG_SHA256="7c72a4e851839e2eca409be6590ac9dbdab2adb1dfde9d173521422feabbcff4"
PKG_ARCH="x86_64"
PKG_LICENSE="MIT"
PKG_SITE="https://01.org/linuxmedia"
PKG_URL="https://github.com/intel/media-driver/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libva libdrm gmmlib"
PKG_LONGDESC="media-driver: The Intel(R) Media Driver for VAAPI is a new VA-API (Video Acceleration API) user mode driver supporting hardware accelerated decoding, encoding, and video post processing for GEN based graphics hardware."
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET="-DENABLE_NONFREE_KERNELS=OFF -DBUILD_KERNELS=OFF"
