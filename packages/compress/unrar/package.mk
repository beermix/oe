# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="unrar"
PKG_VERSION="5.7.5"
PKG_SITE="http://www.rarlab.com"
PKG_URL="http://www.rarlab.com/rar/unrarsrc-$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="unrar: Extract, test and view RAR archives"
PKG_TOOLCHAIN="manual"

make_target() {
  make CXX="$CXX" \
     CXXFLAGS="$TARGET_CXXFLAGS -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -DRAR_SMP" \
     RANLIB="$RANLIB" \
     AR="$AR" \
     STRIP="$STRIP" \
     LDFLAGS="$LDFLAGS -pthread" \
     PREFIX=/usr \
     -f makefile
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin
  cp $PKG_BUILD/unrar $INSTALL/usr/bin
}

