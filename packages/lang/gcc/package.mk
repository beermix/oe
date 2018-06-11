################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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
# https://sources.archlinux.org/other/gcc
################################################################################

PKG_NAME="gcc"
PKG_VERSION="6.4.0"
#PKG_SHA256="832ca6ae04636adbb430e865a1451adf6979ab44ca1c8374f61fba65645ce15c"
PKG_VERSION="7-20180607"
#PKG_VERSION="8.1.1-20180531"
#PKG_VERSION="7.3.1-20180406"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="ftp://gcc.gnu.org/pub/gcc/snapshots/LATEST-7"
PKG_SITE="ftp://gcc.gnu.org/pub/gcc/snapshots/LATEST-8"
PKG_URL="ftp://gcc.gnu.org/pub/gcc/snapshots/$PKG_VERSION/gcc-$PKG_VERSION.tar.xz"
#PKG_URL="http://ftpmirror.gnu.org/gcc/$PKG_NAME-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://sources.archlinux.org/other/gcc/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="http://ftpmirror.gnu.org/gcc/$PKG_NAME-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="http://ftpmirror.gnu.org/gcc/$PKG_NAME-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_BOOTSTRAP="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host"
PKG_DEPENDS_TARGET="gcc:host"
PKG_DEPENDS_HOST="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host glibc"
PKG_SECTION="lang"
PKG_SHORTDESC="gcc: The GNU Compiler Collection (aka GNU C Compiler)"
PKG_LONGDESC="This package contains the GNU Compiler Collection. It includes compilers for the languages C, C++, Objective C, Fortran 95, Java and others ... This GCC contains the Stack-Smashing Protector Patch which can be enabled with the -fstack-protector command-line option. More information about it ca be found at http://www.research.ibm.com/trl/projects/security/ssp/."
PKG_BUILD_FLAGS="-lto -gold -hardening"

post_unpack() {
  sed -i 's@\./fixinc\.sh@-c true@' $PKG_BUILD/gcc/Makefile.in
  sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" $PKG_BUILD/libiberty/configure
  sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" $PKG_BUILD/gcc/configure
  sed -i '/m64=/s/lib64/lib/' $PKG_BUILD/gcc/config/i386/t-linux64
}

GCC_COMMON_CONFIGURE_OPTS="--target=$TARGET_NAME \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --with-gmp=$TOOLCHAIN \
                           --with-mpfr=$TOOLCHAIN \
                           --with-mpc=$TOOLCHAIN \
                           --with-gnu-as \
                           --with-gnu-ld \
                           --enable-plugin \
                           --enable-lto \
                           --enable-gold \
                           --enable-ld=default \
                           --disable-multilib \
                           --disable-nls \
                           --enable-checking=release \
                           --with-default-libstdcxx-abi=gcc4-compatible \
                           --without-ppl \
                           --without-cloog \
                           --disable-libada \
                           --disable-libmudflap \
                           --disable-libmpx \
                           --disable-libssp \
                           --with-linker-hash-style=gnu \
                           --with-tune=haswell \
                           --with-arch=westmere"

PKG_CONFIGURE_OPTS_BOOTSTRAP="$GCC_COMMON_CONFIGURE_OPTS \
                              --enable-languages=c \
                              --disable-__cxa_atexit \
                              --disable-libsanitizer \
                              --disable-libitm \
                              --disable-libquadmath \
                              --disable-libatomic \
                              --disable-libgomp \
                              --enable-cloog-backend=isl \
                              --disable-shared \
                              --disable-threads \
                              --without-headers \
                              --with-newlib \
                              --disable-decimal-float \
                              $GCC_OPTS"

PKG_CONFIGURE_OPTS_HOST="$GCC_COMMON_CONFIGURE_OPTS \
                         --enable-languages=c,c++ \
                         --enable-__cxa_atexit \
                         --enable-decimal-float \
                         --enable-tls \
                         --enable-shared \
                         --disable-static \
                         --enable-c99 \
                         --enable-long-long \
                         --enable-threads=posix \
                         --disable-libstdcxx-pch \
                         --enable-libstdcxx-time \
                         --enable-clocale=gnu \
                         --enable-libatomic \
                         --enable-libgomp \
                         $GCC_OPTS"

pre_configure_host() {
  # export CFLAGS="-g -O2 -I$TOOLCHAIN/include"
  # export CXXFLAGS="-g -O2 -I$TOOLCHAIN/include"
  # export CFLAGS_FOR_TARGET="$TARGET_CFLAGS"
  # export CXXFLAGS_FOR_TARGET="$TARGET_CXXFLAGS"
  
  # export CFLAGS="-march=westmere -g -O2 -fstack-protector -Wl,-z -Wl,now -Wl,-z -Wl,relro  -Wl,-z,max-page-size=0x1000 -mtune=haswell"
  # export CXXFLAGS="-march=westmere -g -O2  -Wl,-z,max-page-size=0x1000 -mtune=haswell"

  export CXXFLAGS="$CXXFLAGS -std=gnu++98"
  unset CPP
}

#pre_configure_bootstrap() {
  # export CFLAGS="-march=westmere -g -O2 -fstack-protector -Wl,-z -Wl,now -Wl,-z -Wl,relro  -Wl,-z,max-page-size=0x1000 -mtune=haswell"
  # export CXXFLAGS="-march=westmere -g -O2  -Wl,-z,max-page-size=0x1000 -mtune=haswell"
  # export CFLAGS_FOR_TARGET="$TARGET_CFLAGS"
  # export CXXFLAGS_FOR_TARGET="$TARGET_CXXFLAGS"
#}

post_make_host() {
  # fix wrong link
  rm -rf $TARGET_NAME/libgcc/libgcc_s.so
  ln -sf libgcc_s.so.1 $TARGET_NAME/libgcc/libgcc_s.so

  if [ ! "${BUILD_WITH_DEBUG}" = "yes" ]; then
    ${TARGET_PREFIX}strip $TARGET_NAME/libgcc/libgcc_s.so*
    ${TARGET_PREFIX}strip $TARGET_NAME/libgomp/.libs/libgomp.so*
    ${TARGET_PREFIX}strip $TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so*
  fi
}

post_makeinstall_host() {
  cp -PR $TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so* $SYSROOT_PREFIX/usr/lib

  GCC_VERSION=`$TOOLCHAIN/bin/${TARGET_NAME}-gcc -dumpversion`
  DATE="0501`echo $GCC_VERSION | sed 's/\([0-9]\)/0\1/g' | sed 's/\.//g'`"
  CROSS_CC=${TARGET_PREFIX}gcc-${GCC_VERSION}
  CROSS_CXX=${TARGET_PREFIX}g++-${GCC_VERSION}

  rm -f ${TARGET_PREFIX}gcc

cat > ${TARGET_PREFIX}gcc <<EOF
#!/bin/sh
$TOOLCHAIN/bin/ccache $CROSS_CC "\$@"
EOF

  chmod +x ${TARGET_PREFIX}gcc

  # To avoid cache trashing
  touch -c -t $DATE $CROSS_CC

  [ ! -f "$CROSS_CXX" ] && mv ${TARGET_PREFIX}g++ $CROSS_CXX

cat > ${TARGET_PREFIX}g++ <<EOF
#!/bin/sh
$TOOLCHAIN/bin/ccache $CROSS_CXX "\$@"
EOF

  chmod +x ${TARGET_PREFIX}g++

  # To avoid cache trashing
  touch -c -t $DATE $CROSS_CXX
}

configure_target() {
 : # reuse configure_host()
}

make_target() {
 : # reuse make_host()
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgcc/libgcc_s.so* $INSTALL/usr/lib
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgomp/.libs/libgomp.so* $INSTALL/usr/lib
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so* $INSTALL/usr/lib
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libatomic/.libs/libatomic.so* $INSTALL/usr/lib
}

configure_init() {
 : # reuse configure_host()
}

make_init() {
 : # reuse make_host()
}

makeinstall_init() {
  mkdir -p $INSTALL/usr/lib
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgcc/libgcc_s.so* $INSTALL/usr/lib
}
