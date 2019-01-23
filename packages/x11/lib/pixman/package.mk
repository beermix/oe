# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="pixman"
PKG_VERSION="0.36.0"
PKG_SHA256="fd92c0cc99183977e54a278d7c595ee094a8e75724c03faf3796d1e49f7780dc"
PKG_LICENSE="OSS"
PKG_SITE="http://www.x.org/"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros"
PKG_LONGDESC="Pixman is a generic library for manipulating pixel regions, contains low-level pixel manipulation routines."

if [ "$TARGET_ARCH" = arm ]; then
  if target_has_feature neon; then
    PIXMAN_NEON="--enable-arm-neon"
  else
    PIXMAN_NEON="--disable-arm-neon"
  fi
  PIXMAN_CONFIG="--disable-mmx --disable-sse2 --disable-vmx --enable-arm-simd $PIXMAN_NEON --disable-arm-iwmmxt"
elif [ "$TARGET_ARCH" = aarch64 ]; then
  PIXMAN_CONFIG="--disable-mmx --disable-sse2 --disable-vmx --disable-arm-simd --disable-arm-neon --disable-arm-iwmmxt"
elif [ "$TARGET_ARCH" = x86_64  ]; then
  PIXMAN_CONFIG="--enable-mmx --enable-sse2 --enable-ssse3 --disable-vmx --disable-arm-simd --disable-arm-neon"
fi

PKG_CONFIGURE_OPTS_TARGET="--enable-openmp \
                           --disable-loongson-mmi \
                           $PIXMAN_CONFIG \
                           --disable-mips-dspr2 \
                           --enable-gcc-inline-asm \
                           --disable-timers \
                           --disable-gtk \
                           --disable-libpng \
                           --with-gnu-ld"

pre_configure_target() {
  export LIBS="$LIBS -fopenmp"
  #export CFLAGS="$CFLAGS -falign-functions=32 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
  #export CXXFLAGS="$CXXFLAGS -falign-functions=32 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
}

post_makeinstall_target() {
  cp $SYSROOT_PREFIX/usr/lib/pkgconfig/pixman-1.pc \
     $SYSROOT_PREFIX/usr/lib/pkgconfig/pixman.pc
  cp -rf $SYSROOT_PREFIX/usr/include/pixman-1 \
     $SYSROOT_PREFIX/usr/include/pixman
}
