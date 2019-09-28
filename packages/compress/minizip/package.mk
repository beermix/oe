# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="minizip"
PKG_VERSION="2.8.9"
PKG_SHA256="ad0ab096e325ada77f4c75770ffcb03e3540e4c373e36ee22bb1d47b2b98c36d"
PKG_LICENSE="zlib"
PKG_SITE="https://github.com/nmoinvaz/minizip"
PKG_URL="https://github.com/nmoinvaz/minizip/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="zlib"
PKG_LONGDESC="Minizip zlib contribution fork with latest bug fixes"

PKG_CMAKE_OPTS_TARGET="-DUSE_AES=OFF \
                       -DBUILD_TEST=ON"

makeinstall_target() {
  cp -v miniunz_exec $SYSROOT_PREFIX/usr/bin/miniunz
  cp -v minizip_exec $SYSROOT_PREFIX/usr/bin/minizip
}
