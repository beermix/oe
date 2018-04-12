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
#PKG_SHA256="6e46b8aeae2f727a36f0bd9505e405768a72218f1796f0d09757d45209871ae6"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://ftp.gnu.org.ua/gnu/binutils/?C=M;O=D"
PKG_URL="http://ftpmirror.gnu.org/binutils/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host bison:host flex:host zlib:host linux:host"
PKG_DEPENDS_TARGET="toolchain binutils:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="binutils: A GNU collection of binary utilities"
PKG_LONGDESC="The GNU binutils are utilities of use when dealing with object files. the packages includes ld - the GNU linker, as - the GNU assembler, addr2line - converts addresses into filenames and line numbers, ar - a utility for creating, modifying and extracting from archives, c++filt - filter to demangle encoded C++ symbols, gprof - displays profiling information, nlmconv - converts object code into an NLM, nm - lists symbols from object files, objcopy - Copys and translates object files, objdump - displays information from object files, ranlib - generates an index to the contents of an archive, readelf - displays information from any ELF format object file, size - lists the section sizes of an object or archive file, strings - lists printable strings from files, strip - discards symbols as well as windres - a compiler for Windows resource files."

post_unpack() {
  sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" $PKG_BUILD/libiberty/configure
}

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --disable-werror \
                         --disable-multilib \
                         --disable-libssp \
                         --enable-version-specific-runtime-libs \
                         --enable-plugins \
                         --enable-threads \
                         --enable-relro \
                         --with-pic \
                         --disable-gdb \
                         --enable-gold \
                         --enable-ld=default \
                         --enable-targets=x86_64-pep \
                         --enable-lto \
                         --disable-nls"

PKG_CONFIGURE_OPTS_TARGET="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --enable-static \
                         --disable-shared \
                         --enable-threads \
                         --enable-relro \
                         --with-pic \
                         --disable-gdb \
                         --disable-werror \
                         --disable-multilib \
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
  make MAKEINFO=true tooldir=/usr
}

makeinstall_host() {
  cp -v ../include/libiberty.h $SYSROOT_PREFIX/usr/include
  make MAKEINFO=true install
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
