# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="unrar"
PKG_VERSION="5.7.4"
PKG_SITE="http://www.rarlab.com"
PKG_URL="http://www.rarlab.com/rar/unrarsrc-$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_SHORTDESC="unrar: Extract, test and view RAR archives"
PKG_LONGDESC="Unrar is a package to handle files compressed in the RAR format. Due to strange licensing issues this package can only view, test and extract files in a given archive, but not pack files. But since we have far more advanced open-source compression utils it should be enough to extract the content when you get a RAR archive."
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

