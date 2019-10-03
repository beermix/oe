# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)                          --enable-targets=x86_64-linux \
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv) 

PKG_NAME="binutils"
PKG_VERSION="2.32"
PKG_SHA256="0ab6c55dd86a92ed561972ba15b9b70a8b9f75557f896446c82e8b36e473ee04"
#PKG_VERSION="e648cc9"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/bminor/binutils-gdb/tree/binutils-2_33-branch"
PKG_URL="https://github.com/bminor/binutils-gdb/archive/${PKG_VERSION}.tar.gz"
PKG_URL="http://ftpmirror.gnu.org/binutils/$PKG_NAME-$PKG_VERSION.tar.xz"
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
                         --disable-nls \
                         --disable-gdb \
                         --disable-sim"

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
                         --disable-nls \
                         --disable-gdb \
                         --disable-sim"

pre_configure_host() {
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS
}

make_host() {
  make MAKEINFO=true configure-host
  make MAKEINFO=true
}

makeinstall_host() {
  cp -v ../include/libiberty.h $SYSROOT_PREFIX/usr/include
  make MAKEINFO=true install
}

make_target() {
  make MAKEINFO=true configure-host
  make MAKEINFO=true -C libiberty
  make MAKEINFO=true -C bfd
  make MAKEINFO=true -C opcodes
  make MAKEINFO=true -C binutils strings
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp libiberty/libiberty.a $SYSROOT_PREFIX/usr/lib
  make MAKEINFO=true DESTDIR="$SYSROOT_PREFIX" -C bfd install
  make MAKEINFO=true DESTDIR="$SYSROOT_PREFIX" -C opcodes install

  mkdir -p ${INSTALL}/usr/bin
    cp binutils/strings ${INSTALL}/usr/bin
}
