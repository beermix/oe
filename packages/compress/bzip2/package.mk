# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bzip2"
PKG_VERSION="1.0.7"
PKG_SHA256="e768a87c5b1a79511499beb41500bcc4caf203726fff46a6f5f9ad27fe08ab2b"
PKG_LICENSE="GPL"
PKG_SITE="http://www.bzip.org"
PKG_URL="https://sourceware.org/pub/bzip2/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A high-quality bzip2 data compressor."
PKG_BUILD_FLAGS="+speed"

pre_configure_host() {
  export CFLAGS="$CFLAGS -fno-semantic-interposition -ffunction-sections -fPIC"
  export CXXFLAGS="$CXXFLAGS -fno-semantic-interposition -ffunction-sections -fPIC"
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -fno-semantic-interposition -ffunction-sections -fPIC"
  export CXXFLAGS="$CXXFLAGS -fno-semantic-interposition -ffunction-sections -fPIC"
}

pre_build_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -r $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
}

make_host() {
  cd $PKG_BUILD/.$HOST_NAME
  make -f Makefile-libbz2_so all CC=$HOST_CC LDFLAGS="$LFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"
}

makeinstall_host() {
  make install PREFIX=$TOOLCHAIN
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -r $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_make_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  sed -e "s,ln -s (lib.*),ln -snf \$$1; ln -snf libbz2.so.$PKG_VERSION libbz2.so,g" -i Makefile-libbz2_so
}

make_target() {
  make -f Makefile-libbz2_so CC=$CC CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"
  make -f Makefile libbz2.a bzip2 bzip2recover CC="$CC" CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"
}

post_make_target() {
  ln -snf libbz2.so.1.0 libbz2.so
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp bzlib.h $SYSROOT_PREFIX/usr/include
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -P libbz2.so* $SYSROOT_PREFIX/usr/lib
    cp libbz2.a $SYSROOT_PREFIX/usr/lib

  mkdir -p $INSTALL/usr/lib
    cp -P libbz2.so* $INSTALL/usr/lib
    
  mkdir -p $INSTALL/usr/bin
    cp -P bzdiff $INSTALL/usr/bin
    cp -P bzgrep $INSTALL/usr/bin
    cp -P bzip2 $INSTALL/usr/bin
    cp -P bzmore $INSTALL/usr/bin
}
