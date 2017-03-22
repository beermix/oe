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

PKG_NAME="llvm"
PKG_VERSION="4.0.0"
PKG_REV="1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://llvm.org/releases/$PKG_VERSION/${PKG_NAME}-${PKG_VERSION}.src.tar.xz"
PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}.src"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain llvm:host zlib libedit libffi libxml2 Python:host swig:host"
PKG_PRIORITY="optional"
PKG_SECTION="lang"
PKG_SHORTDESC="llvm: Low Level Virtual Machine"
PKG_LONGDESC="Low-Level Virtual Machine (LLVM) is a compiler infrastructure designed for compile-time, link-time, run-time, and idle-time optimization of programs from arbitrary programming languages. It currently supports compilation of C, Objective-C, and C++ programs, using front-ends derived from GCC 4.0, GCC 4.2, and a custom new front-end, "clang". It supports x86, x86-64, ia64, PowerPC, and SPARC, with support for Alpha and ARM under development."


PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release \
			$LLVM_OPTS \
			-DLLVM_BUILD_TOOLS=ON \
			-DLLVM_INCLUDE_TOOLS=ON \
			-DLLVM_BUILD_EXAMPLES=OFF \
			-DLLVM_INCLUDE_EXAMPLES=OFF \
			-DLLVM_BUILD_TESTS=OFF \
			-DLLVM_INCLUDE_TESTS=OFF \
			-DLLVM_BUILD_DOCS=OFF \
			-DLLVM_ENABLE_DOXYGEN=OFF \
			-DLLVM_ENABLE_ZLIB=OFF \
			-DLLVM_ENABLE_TERMINFO=OFF \
			-DLLVM_OPTIMIZED_TABLEGEN=ON \
			-DLLVM_TARGETS_TO_BUILD=X86 \
			-DLLVM_CCACHE_BUILD=OFF \
			-DLLVM_PARALLEL_COMPILE_JOBS=7"


PKG_CMAKE_OPTS_TARGET="-DCMAKE_INSTALL_PREFIX=/usr \
			  -DCMAKE_SYSTEM_NAME=Linux \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DLLVM_ENABLE_ASSERTIONS=OFF \
			  -DLLVM_ENABLE_THREADS=4 \
			  -DPYTHON_EXECUTABLE=$ROOT/$$TOOLCHAIN/python \
			  -DLLVM_ENABLE_FFI=ON \
			  -DLLVM_ENABLE_SPHINX=ON \
			  -DLLVM_BUILD_LLVM_DYLIB=ON \
			  -DLLVM_LINK_LLVM_DYLIB=ON \
			  -DCMAKE_CXX_FLAGS="-D_GNU_SOURCE" \
			  -DLIBCLANG_BUILD_STATIC=ON \
			  -DLIBCXX_ENABLE_SHARED=OFF \
			  -DLIBCXXABI_ENABLE_SHARED=OFF \
			  -DLIBUNWIND_ENABLE_SHARED=OFF \
			  -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
			  -DLLVM_TABLEGEN=$ROOT/$TOOLCHAIN/bin/llvm-tblgen \
			  -DLLVM_ENABLE_BACKTRACES=OFF \
			  -DLLVM_OPTIMIZED_TABLEGEN=ON \
			  -DLLVM_TARGETS_TO_BUILD="X86" \
			  -DLLVM_PARALLEL_COMPILE_JOBS=7 \
			  -DLLDB_DISABLE_LIBEDIT=1 \
			  -DLLVM_BINUTILS_INCDIR=$ROOT/$TOOLCHAIN/include"


makeinstall_host() {
  cp -PR bin/llvm-config $SYSROOT_PREFIX/usr/bin/llvm-config-host
  cp -PR bin/llvm-tblgen $ROOT/$TOOLCHAIN/bin
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/LLVMHello.so
  rm -rf $INSTALL/usr/lib/libLTO.so
  rm -rf $INSTALL/usr/share
}
