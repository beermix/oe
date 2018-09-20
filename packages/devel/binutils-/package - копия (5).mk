# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="binutils"
PKG_VERSION="2.31.1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/bminor/binutils-gdb/tree/binutils-2_31-branch"
PKG_URL="http://ftpmirror.gnu.org/binutils/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/bminor/binutils-gdb/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="$PKG_NAME-gdb-$PKG_VERSION*"
PKG_DEPENDS_HOST="ccache:host bison:host flex:host elfutils:host linux:host"
PKG_DEPENDS_TARGET="toolchain binutils:host zlib"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="binutils: A GNU collection of binary utilities"
PKG_LONGDESC="The GNU binutils are utilities of use when dealing with object files. the packages includes ld - the GNU linker, as - the GNU assembler, addr2line - converts addresses into filenames and line numbers, ar - a utility for creating, modifying and extracting from archives, c++filt - filter to demangle encoded C++ symbols, gprof - displays profiling information, nlmconv - converts object code into an NLM, nm - lists symbols from object files, objcopy - Copys and translates object files, objdump - displays information from object files, ranlib - generates an index to the contents of an archive, readelf - displays information from any ELF format object file, size - lists the section sizes of an object or archive file, strings - lists printable strings from files, strip - discards symbols as well as windres - a compiler for Windows resource files."

#post_unpack() {
#  sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" $PKG_BUILD/libiberty/configure
#}

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
                         --enable-compressed-debug-sections=all \
                         --disable-gdb \
                         --with-system-zlib \
                         --enable-plugins \
                         --enable-gold \
                         --enable-ld=default \
                         --enable-lto \
                         --disable-nls"

PKG_CONFIGURE_OPTS_TARGET="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --enable-compressed-debug-sections=all \
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
                         --with-system-zlib \
                         --disable-ld \
                         --disable-lto \
                         --disable-nls \
                         --disable-gdb"

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
  make install
}

make_target() {
  make configure-host
  make -C libiberty
  make -C bfd
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp libiberty/libiberty.a $SYSROOT_PREFIX/usr/lib
  make DESTDIR="$SYSROOT_PREFIX" -C bfd install
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp libiberty/libiberty.a $SYSROOT_PREFIX/usr/lib
  make DESTDIR="$SYSROOT_PREFIX" -C bfd install
}
