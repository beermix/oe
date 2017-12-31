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
################################################################################

PKG_NAME="binutils"
PKG_VERSION="2.29"
PKG_SHA256="0b871e271c4c620444f8264f72143b4d224aa305306d85dd77ab8dce785b1e85"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/bminor/binutils-gdb"
PKG_URL="http://ftpmirror.gnu.org/binutils/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host bison:host flex:host libelf:host zlib:host linux:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="binutils: A GNU collection of binary utilities"
PKG_LONGDESC="The GNU binutils are utilities of use when dealing with object files. the packages includes ld - the GNU linker, as - the GNU assembler, addr2line - converts addresses into filenames and line numbers, ar - a utility for creating, modifying and extracting from archives, c++filt - filter to demangle encoded C++ symbols, gprof - displays profiling information, nlmconv - converts object code into an NLM, nm - lists symbols from object files, objcopy - Copys and translates object files, objdump - displays information from object files, ranlib - generates an index to the contents of an archive, readelf - displays information from any ELF format object file, size - lists the section sizes of an object or archive file, strings - lists printable strings from files, strip - discards symbols as well as windres - a compiler for Windows resource files."

post_unpack() {
  rm -rf $PKG_BUILD/gdb $PKG_BUILD/libdecnumber $PKG_BUILD/readline $PKG_BUILD/sim
}

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --without-ppl \
                         --without-cloog \
                         --disable-werror \
                         --disable-multilib \
                         --disable-libada \
                         --enable-libssp \
                         --enable-relro \
                         --enable-version-specific-runtime-libs \
                         --enable-plugins \
                         --enable-ld=default \
                         --enable-lto \
                         --enable-secureplt \
                         --disable-nls \
                         --enable-poison-system-directories"

pre_configure_host() {
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS
  CFLAGS="-g1 -O2"
  CXXFLAGS="-g1 -O2"
}

make_host() {
  make MAKEINFO=true configure-host
  make MAKEINFO=true
}

make_target() {
  make MAKEINFO=true configure-host
  make MAKEINFO=true -C libiberty
  make MAKEINFO=true -C bfd
  make MAKEINFO=true -C binutils ar
}

makeinstall_host() {
  cp -v ../include/libiberty.h $SYSROOT_PREFIX/usr/include
  make MAKEINFO=true install
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp binutils/ar $INSTALL/usr/bin
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --disable-gdb"
