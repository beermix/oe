# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="llvm"
PKG_VERSION="b860b5e"
PKG_SHA256="cbfc66ff2850afcc72e232446c73ebd781a32d5bced4b9aecc5b52453bb5543a"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="https://github.com/RPCS3/llvm/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain llvm:host zlib"
PKG_LONGDESC="Low-Level Virtual Machine (LLVM) is a compiler infrastructure."

if [ "$LVM_SUPPORT" = "yes" ]; then
  LLVM_TARGETS="AMDGPU;X86"
else
  LLVM_TARGETS="X86"
fi

PKG_CMAKE_OPTS_COMMON="-DLLVM_INCLUDE_TOOLS=ON \
                       -DLLVM_BUILD_TOOLS=OFF \
                       -DLLVM_BUILD_UTILS=OFF \
                       -DLLVM_BUILD_EXAMPLES=OFF \
                       -DLLVM_INCLUDE_EXAMPLES=OFF \
                       -DLLVM_BUILD_TESTS=OFF \
                       -DLLVM_INCLUDE_TESTS=OFF \
                       -DLLVM_INCLUDE_GO_TESTS=OFF \
                       -DLLVM_BUILD_DOCS=OFF \
                       -DLLVM_INCLUDE_DOCS=OFF \
                       -DLLVM_ENABLE_DOXYGEN=OFF \
                       -DLLVM_ENABLE_SPHINX=OFF \
                       -DLLVM_TARGETS_TO_BUILD=$LLVM_TARGETS \
                       -DLLVM_ENABLE_TERMINFO=OFF \
                       -DLLVM_ENABLE_ASSERTIONS=OFF \
                       -DLLVM_ENABLE_WERROR=OFF \
                       -DLLVM_ENABLE_ZLIB=ON \
                       -DLLVM_BUILD_LLVM_DYLIB=ON \
                       -DLLVM_LINK_LLVM_DYLIB=ON \
                       -DLLVM_OPTIMIZED_TABLEGEN=ON \
                       -DLLVM_APPEND_VC_REV=OFF \
                       -DLLVM_ENABLE_RTTI=ON"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_COMMON \
                     -DCMAKE_INSTALL_RPATH=$TOOLCHAIN/lib"

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET="$PKG_CMAKE_OPTS_COMMON \
                         -DCMAKE_BUILD_TYPE=Release \
                         -DCMAKE_C_FLAGS="$CFLAGS" \
                         -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
                         -DLLVM_TARGET_ARCH="$TARGET_ARCH" \
                         -DLLVM_TABLEGEN=$TOOLCHAIN/bin/llvm-tblgen"
}

make_host() {
  ninja $NINJA_OPTS llvm-config llvm-tblgen FileCheck
}

makeinstall_target() {
  DESTDIR=$SYSROOT_PREFIX ninja install $PKG_MAKEINSTALL_OPTS_TARGET
  if [ "$LVM_SUPPORT" = "yes" ]; then
    DESTDIR=$INSTALL ninja install $PKG_MAKEINSTALL_OPTS_TARGET
  fi
}

makeinstall_host() {
  cp -a bin/llvm-config $SYSROOT_PREFIX/usr/bin/llvm-config-host
  cp -a bin/llvm-tblgen $TOOLCHAIN/bin
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/LLVMHello.so
  rm -rf $INSTALL/usr/lib/libLTO.so
  rm -rf $INSTALL/usr/share
}
