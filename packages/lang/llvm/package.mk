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

PKG_NAME="llvm"
PKG_VERSION="5.0.1"
PKG_SHA256="5fa7489fc0225b11821cab0362f5813a05f2bcf2533e8a4ea9c9c860168807b0"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://llvm.org/releases/$PKG_VERSION/${PKG_NAME}-${PKG_VERSION}.src.tar.xz"
PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}.src"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain llvm:host zlib"
PKG_SECTION="lang"
PKG_SHORTDESC="llvm: Low Level Virtual Machine"
PKG_LONGDESC="Low-Level Virtual Machine (LLVM) is a compiler infrastructure designed for compile-time, link-time, run-time, and idle-time optimization of programs from arbitrary programming languages. It currently supports compilation of C, Objective-C, and C++ programs, using front-ends derived from GCC 4.0, GCC 4.2, and a custom new front-end, "clang". It supports x86, x86-64, ia64, PowerPC, and SPARC, with support for Alpha and ARM under development."

PKG_CMAKE_OPTS_COMMON="-DCMAKE_BUILD_TYPE=Release \
                       -DCMAKE_INSTALL_PREFIX=/usr \
                       -DLLVM_ENABLE_FFI=ON \
                       -DLLVM_BUILD_LLVM_DYLIB=ON \
                       -DLLVM_TARGETS_TO_BUILD=X86 \
                       -DLLVM_CCACHE_BUILD=ON \
                       -DCMAKE_INSTALL_RPATH=$TOOLCHAIN/lib"

PKG_CMAKE_OPTS_TARGET="$PKG_CMAKE_OPTS_COMMON \
                       -DCMAKE_BUILD_TYPE=Release \
                       -DCMAKE_C_FLAGS="$CFLAGS" \
                       -DLLVM_ENABLE_FFI=ON \
                       -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
                       -DLLVM_TARGET_ARCH="$TARGET_ARCH" \
                       -DLLVM_CCACHE_BUILD=ON \
                       -DFFI_INCLUDE_DIR=$(pkg-config --variable=includedir libffi) \
                       -DLLVM_TABLEGEN=$TOOLCHAIN/bin/llvm-tblgen"

#make_host() {
#  ninja -j${CONCURRENCY_MAKE_LEVEL}
#}

#makeinstall_host() {
#  cp -a bin/llvm-config $SYSROOT_PREFIX/usr/bin/llvm-config-host
#  cp -a bin/llvm-tblgen $TOOLCHAIN/bin
#}

#post_makeinstall_target() {
#  rm -rf $INSTALL/usr/bin
#  rm -rf $INSTALL/usr/lib/LLVMHello.so
#  rm -rf $INSTALL/usr/lib/libLTO.so
#  rm -rf $INSTALL/usr/share
#}
