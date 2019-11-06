# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv) isl:host
#--enable-gnu-indirect-function --disable-libunwind-exceptions
#                           --enable-gnu-unique-object --disable-vtable-verify\
#                           --disable-vtable-verify \
#                           --disable-libsanitizer \
#                           --enable-target-optspace \ --without-included-gettext --with-default-libstdcxx-abi=gcc4-compatible --with-gcc-major-version-only \
#                           

PKG_NAME="gcc"
PKG_VERSION="9.2.0"
PKG_SHA256="ea6ef08f121239da5695f76c9b33637a118dcf63e24164422231917fa61fb206"
PKG_LICENSE="GPL"
#PKG_VERSION="9-20191026"
#PKG_VERSION="10-20191020"
PKG_URL="https://github.com/gcc-mirror/gcc/archive/$PKG_VERSION.tar.gz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="http://ftpmirror.gnu.org/gcc/$PKG_NAME-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_BOOTSTRAP="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host glibc"
PKG_DEPENDS_INIT="toolchain"
PKG_DEPENDS_UNPACK+=" isl"
PKG_LONGDESC="This package contains the GNU Compiler Collection."

post_unpack() {
  ISL_DIR=$(get_build_dir isl)
  ln -s $ISL_DIR $PKG_BUILD/isl
}
 
post_patch() {
  #sed -i '/maybe-check-target-libphobos \\/d' $PKG_BUILD/Makefile
  echo $PKG_VERSION > $PKG_BUILD/gcc/BASE-VER
}

GCC_COMMON_CONFIGURE_OPTS="--target=$TARGET_NAME \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --with-gmp=$TOOLCHAIN \
                           --with-mpfr=$TOOLCHAIN \
                           --with-mpc=$TOOLCHAIN \
                           --with-isl \
                           --with-gnu-as \
                           --with-gnu-ld \
                           --enable-plugin \
                           --enable-lto \
                           --enable-gold \
                           --enable-ld=default \
                           --with-linker-hash-style=gnu \
                           --disable-multilib \
                           --disable-nls \
                           --enable-checking=release \
                           --with-diagnostics-color=always \
                           --disable-vtable-verify \
                           --disable-libunwind-exceptions \
                           --without-ppl \
                           --without-cloog \
                           --disable-libada \
                           --disable-libmudflap \
                           --disable-libmpx \
                           --disable-libssp"

PKG_CONFIGURE_OPTS_BOOTSTRAP="$GCC_COMMON_CONFIGURE_OPTS \
                              --enable-languages=c \
                              --disable-__cxa_atexit \
                              --disable-libsanitizer \
                              --disable-libitm \
                              --disable-libquadmath \
                              --disable-shared \
                              --disable-threads \
                              --disable-libgomp \
                              --disable-libatomic \
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
                         $GCC_OPTS"

pre_configure_host() {
#  export CCACHE_DISABLE=true
  export CXXFLAGS="$CXXFLAGS -std=gnu++98"
  unset CPP
}

#pre_configure_bootstrap() {
#  export CCACHE_DISABLE=true
#}

post_make_host() {
  # fix wrong link
  rm -rf $TARGET_NAME/libgcc/libgcc_s.so
  ln -sf libgcc_s.so.1 $TARGET_NAME/libgcc/libgcc_s.so

  if [ ! "${BUILD_WITH_DEBUG}" = "yes" ]; then
    ${TARGET_PREFIX}strip $TARGET_NAME/libgcc/libgcc_s.so*
    ${TARGET_PREFIX}strip $TARGET_NAME/libgomp/.libs/libgomp.so*
    ${TARGET_PREFIX}strip $TARGET_NAME/libatomic/.libs/libatomic.so*
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


  # POSIX conformance launcher scripts for c89 and c99
  cat > $TOOLCHAIN/bin/c89 <<"EOF"
#!/bin/sh
fl="-std=c89"
for opt; do
  case "\$opt" in
    -ansi|-std=c89|-std=iso9899:1990) fl="";;
    -std=*) echo "`basename \$0` called with non ANSI/ISO C option \$opt" >&2
        exit 1;;
  esac
done
exec $TOOLCHAIN/bin/${TARGET_NAME}-gcc $fl ${1+"$@"}
EOF

  cat > $TOOLCHAIN/bin/c99 <<"EOF"
#!/bin/sh
fl="-std=c99"
for opt; do
  case "\$opt" in
    -std=c99|-std=iso9899:1999) fl="";;
    -std=*) echo "`basename \$0` called with non ISO C99 option \$opt" >&2
        exit 1;;
  esac
done
exec $TOOLCHAIN/bin/${TARGET_NAME}-gcc $fl ${1+"$@"}
EOF

  chmod +x $TOOLCHAIN/bin/c{8,9}9

  # To avoid cache trashing
  touch -c -t $DATE $CROSS_CXX

  # install lto plugin for binutils
  mkdir -p $TOOLCHAIN/lib/bfd-plugins
    ln -sf ../gcc/$TARGET_NAME/$GCC_VERSION/liblto_plugin.so $TOOLCHAIN/lib/bfd-plugins
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
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libatomic/.libs/libatomic.so* $INSTALL/usr/lib
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so* $INSTALL/usr/lib
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
