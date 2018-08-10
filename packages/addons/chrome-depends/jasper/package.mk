# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="jasper"
PKG_VERSION="2.0.14"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="https://github.com/mdadams/jasper/releases"
PKG_URL="https://github.com/mdadams/jasper/archive/version-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}-version-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain libjpeg-turbo"
PKG_SECTION="graphics"
PKG_SHORTDESC="jasper: JPEG-2000 Part-1 standard (i.e., ISO/IEC 15444-1) implementation"
PKG_LONGDESC="This distribution contains the public release of the an open-source implementation of the ISO/IEC 15444-1 also known as JPEG-2000 standard for image compression."
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_DISABLE_FIND_PACKAGE_DOXYGEN=TRUE \
			  -DCMAKE_DISABLE_FIND_PACKAGE_LATEX=TRUE \
			  -DJAS_ENABLE_SHARED=OFF \
			  -DCMAKE_SKIP_RPATH=ON \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DJAS_ENABLE_OPENGL=ON \
			  -DJAS_ENABLE_LIBJPEG=ON"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}