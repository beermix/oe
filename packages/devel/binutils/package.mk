# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv) 

PKG_NAME="binutils"
PKG_VERSION="2.33.1"
PKG_SHA256="ab66fc2d1c3ec0359b8e08843c9f33b63e8707efdff5e4cc5c200eae24722cbf"
#PKG_VERSION="e648cc9"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/bminor/binutils-gdb/tree/binutils-2_33-branch"
PKG_URL="https://github.com/bminor/binutils-gdb/archive/${PKG_VERSION}.tar.gz"
PKG_URL="http://ftp.gnu.org/gnu/binutils/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host bison:host flex:host linux:host"
PKG_DEPENDS_TARGET="toolchain binutils:host"
PKG_LONGDESC="A GNU collection of binary utilities."

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --without-ppl \
                         --without-cloog \
                         --disable-werror \
                         --disable-multilib \
                         --disable-libada \
                         --disable-libssp \
                         --enable-version-specific-runtime-libs \
                         --enable-plugins \
                         --enable-gold \
                         --enable-ld=default \
                         --enable-targets=x86_64-linux \
                         --enable-lto \
                         --disable-nls"

PKG_CONFIGURE_OPTS_TARGET="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --without-ppl \
                         --without-cloog \
                         --enable-static \
                         --disable-shared \
                         --disable-werror \
                         --disable-multilib \
                         --disable-libada \
                         --disable-libssp \
                         --disable-plugins \
                         --disable-gold \
                         --enable-targets=x86_64-linux \
                         --disable-ld \
                         --disable-lto \
                         --disable-nls"

pre_configure_host() {
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS
}

make_host() {
  make configure-host
  make
}

makeinstall_host() {
  cp -v ../include/libiberty.h $SYSROOT_PREFIX/usr/include
  make MAKEINFO=true install
}

#post_makeinstall_host() {
  # No shared linking to these files outside binutils
#  rm -f "$pkgdir"/usr/lib/lib{bfd,opcodes}.so
#  echo 'INPUT( /usr/lib/libbfd.a -liberty -lz -ldl )' > "$pkgdir/usr/lib/libbfd.so"
#  echo 'INPUT( /usr/lib/libopcodes.a -lbfd )' > "$pkgdir/usr/lib/libopcodes.so"
#}

make_target() {
  make configure-host
  make -C libiberty
  make -C bfd
  make -C opcodes
  make -C binutils strings
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp libiberty/libiberty.a $SYSROOT_PREFIX/usr/lib
  make DESTDIR="$SYSROOT_PREFIX" -C bfd MAKEINFO=true install
  make DESTDIR="$SYSROOT_PREFIX" -C opcodes MAKEINFO=true install

  mkdir -p ${INSTALL}/usr/bin
    cp binutils/strings ${INSTALL}/usr/bin
}
