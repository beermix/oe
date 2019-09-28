# SPDX-License-Identifier: GPL-2.0-or-later-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="jasper"
PKG_VERSION="2.0.16"
PKG_SHA256="f1d8b90f231184d99968f361884e2054a1714fdbbd9944ba1ae4ebdcc9bbfdb1"
PKG_LICENSE="OpenSource"
PKG_SITE="https://github.com/mdadams/jasper/releases"
PKG_URL="https://github.com/mdadams/jasper/archive/version-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libjpeg-turbo"
PKG_SHORTDESC="jasper: JPEG-2000 Part-1 standard (i.e., ISO/IEC 15444-1) implementation"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_DISABLE_FIND_PACKAGE_DOXYGEN=TRUE \
			  -DCMAKE_DISABLE_FIND_PACKAGE_LATEX=TRUE \
			  -DJAS_ENABLE_SHARED=OFF \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DJAS_ENABLE_OPENGL=ON \
			  -DJAS_ENABLE_LIBJPEG=ON \
			  -DCMAKE_SKIP_RPATH=ON"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}