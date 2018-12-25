# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="binutils"
PKG_VERSION="2.31.1"
PKG_SHA256="5d20086ecf5752cc7d9134246e9588fa201740d540f7eb84d795b1f7a93bca86"
#PKG_VERSION="62dccf6"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/bminor/binutils-gdb/tree/binutils-2_31-branch"
PKG_URL="http://ftpmirror.gnu.org/binutils/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/bminor/binutils-gdb/archive/${PKG_VERSION}.tar.gz"
#PKG_SOURCE_DIR="$PKG_NAME-gdb-$PKG_VERSION*"
PKG_DEPENDS_HOST="ccache:host bison:host flex:host elfutils:host linux:host"
PKG_DEPENDS_TARGET="toolchain binutils:host zlib"

post_unpack() {
  sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" $PKG_BUILD/libiberty/configure
}

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
                         --enable-targets=i386-linux,x86_64-linux \
                         --enable-plugins \
                         --enable-gold \
                         --enable-ld=default \
                         --enable-lto \
                         --disable-nls"

PKG_CONFIGURE_OPTS_TARGET="--target=$TARGET_NAME \
			      --with-sysroot=$SYSROOT_PREFIX \
			      --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
			      --enable-compressed-debug-sections=all \
			      --enable-targets=i386-linux,x86_64-linux \
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
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp libiberty/libiberty.a $SYSROOT_PREFIX/usr/lib
  make MAKEINFO=true DESTDIR="$SYSROOT_PREFIX" -C bfd install
}
