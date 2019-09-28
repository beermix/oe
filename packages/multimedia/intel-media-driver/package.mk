# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="intel-media-driver"
PKG_VERSION="18.3.0"
PKG_SHA256="df9af1cc796b4123508aacaf19d040cc5d8c5742c05199f45c9a3905ed8d1b52"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/intel/media-driver/releases"
PKG_URL="https://github.com/intel/media-driver/archive/intel-media-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libpciaccess libva libdrm"
PKG_SOURCE_DIR="media-driver-intel-media-$PKG_VERSION*"
PKG_SECTION="multimedia"
PKG_SHORTDESC="intel-media-driver: VA-API user mode driver for Intel GEN Graphics family"
PKG_LONGDESC="intel-media-driver: VA-API user mode driver for Intel GEN Graphics family"
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
   export LIBS="$LIBS -lpciaccess"
}

PKG_CMAKE_OPTS_TARGET="-DINSTALL_DRIVER_SYSCONF=0 -Wno-dev"