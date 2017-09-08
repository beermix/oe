################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="gcc"
PKG_VERSION="7-20170907"
PKG_URL="ftp://gcc.gnu.org/pub/gcc/snapshots/$PKG_VERSION/gcc-$PKG_VERSION.tar.xz"
PKG_DEPENDS_BOOTSTRAP="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host"
PKG_DEPENDS_TARGET="gcc:host"
PKG_DEPENDS_HOST="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host glibc"
PKG_PRIORITY="optional"
PKG_SECTION="lang"
PKG_SHORTDESC="gcc: The GNU Compiler Collection Version 4 (aka GNU C Compiler)"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  sed -i 's@\./fixinc\.sh@-c true@' $ROOT/$PKG_BUILD/gcc/Makefile.in
  sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" $ROOT/$PKG_BUILD/libiberty/configure
  sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" $ROOT/$PKG_BUILD/gcc/configure
}

MAKEINFO=missing

GCC_COMMON_CONFIGURE_OPTS="--target=$TARGET_NAME \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --with-gmp=$ROOT/$TOOLCHAIN \
                           --with-mpfr=$ROOT/$TOOLCHAIN \
                           --with-mpc=$ROOT/$TOOLCHAIN \
                           --with-gnu-as \
                           --with-gnu-ld \
                           --enable-plugin \
                           --enable-lto \
                           --enable-gold \
                           --enable-ld=default \
                           --disable-multilib \
                           --disable-nls \
                           --without-included-gettext \
                           --with-default-libstdcxx-abi=gcc4-compatible \
                           --enable-linker-build-id
                           --enable-checking=release \
                           --enable-threads=posix \
                           --disable-libstdcxx-pch \
                           --enable-libstdcxx-time=yes \
                           --enable-objc-gc=auto
                           --disable-vtable-verify \
                           --enable-default-pie \
                           --enable-clocale=gnu \
                           --enable-offload-targets=nvptx-none \
                           --without-ppl \
                           --without-cloog \
                           --disable-libmpx \
                           --disable-libssp \
                           --disable-libsanitizer \
                           --disable-werror \
                           --with-tune=generic"

PKG_CONFIGURE_OPTS_BOOTSTRAP="$GCC_COMMON_CONFIGURE_OPTS \
                              --enable-languages=c \
                              --disable-decimal-float \
                              --disable-libatomic \
                              --disable-libgomp \
                              --disable-libitm \
                              --disable-libada \
                              --disable-libquadmath \
                              --disable-libmudflap \
                              --disable-libhsail-rt \
                              --disable-threads \
                              --enable-linker-build-id
                              --disable-__cxa_atexit \
                              --disable-shared \
                              --without-headers \
                              --with-newlib \
                              $GCC_OPTS"

PKG_CONFIGURE_OPTS_HOST="$GCC_COMMON_CONFIGURE_OPTS \
                         --enable-languages=c,c++ \
                         --enable-__cxa_atexit \
                         --enable-decimal-float \
                         --enable-tls \
                         --enable-shared \
                         --enable-static \
                         --enable-c99 \
                         --enable-long-long \
                         $GCC_OPTS"

pre_configure_host() {
  #export CXXFLAGS="$CXXFLAGS -std=gnu++98"
  unset CPP
}

post_make_host() {
  # fix wrong link
  rm -rf $TARGET_NAME/libgcc/libgcc_s.so
  ln -sf libgcc_s.so.1 $TARGET_NAME/libgcc/libgcc_s.so

  if [ ! "$DEBUG" = yes ]; then
    ${TARGET_NAME}-strip $TARGET_NAME/libgcc/libgcc_s.so*
    ${TARGET_NAME}-strip $TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so*
  fi
}

post_makeinstall_host() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -PR $TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so* $SYSROOT_PREFIX/usr/lib
    cp -PR $TARGET_NAME/libgomp/.libs/libgomp.so* $SYSROOT_PREFIX/usr/lib
    cp -PR $TARGET_NAME/libatomic/.libs/libatomic.so* $SYSROOT_PREFIX/usr/lib

  mkdir -p $ROOT/$TOOLCHAIN/lib/ccache
    ln -sf $ROOT/$TOOLCHAIN/bin/ccache $ROOT/$TOOLCHAIN/lib/ccache/${TARGET_NAME}-gcc
    ln -sf $ROOT/$TOOLCHAIN/bin/ccache $ROOT/$TOOLCHAIN/lib/ccache/${TARGET_NAME}-g++
}

configure_target() {
 : # reuse configure_host()
}

make_target() {
 : # reuse make_host()
}

makeinstall_target() {
  mkdir -p $INSTALL/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgcc/libgcc_s.so* $INSTALL/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgomp/.libs/libgomp.so* $INSTALL/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libatomic/.libs/libatomic.so* $INSTALL/lib
  mkdir -p $INSTALL/usr/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so* $INSTALL/usr/lib
}

configure_init() {
 : # reuse configure_host()
}

make_init() {
 : # reuse make_host()
}

makeinstall_init() {
  mkdir -p $INSTALL/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgcc/libgcc_s.so* $INSTALL/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgomp/.libs/libgomp.so* $INSTALL/lib
    cp -P $ROOT/$PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libatomic/.libs/libatomic.so* $INSTALL/lib
}
