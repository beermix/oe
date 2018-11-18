# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="intel-gmmlib"
PKG_VERSION="e52096b"
#PKG_SHA256="e3114d7ddd429f1b9aa43a1b1d0086d881fbf4d90e4a90ab8577c369d2e3a5e1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/gmmlib/releases"
PKG_URL="https://github.com/intel/gmmlib/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libpciaccess libva libdrm"
#PKG_SOURCE_DIR="gmmlib-intel-gmmlib-$PKG_VERSION*"
PKG_SECTION="multimedia"
PKG_SHORTDESC="intel-media-driver: VA-API user mode driver for Intel GEN Graphics family"
PKG_LONGDESC="intel-media-driver: VA-API user mode driver for Intel GEN Graphics family"
#PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE='None' -DRUN_TEST_SUITE=OFF -Wno-dev"