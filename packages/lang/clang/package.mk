PKG_NAME="clang"
PKG_VERSION="6.0.0"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain lld:host clang:host llvm"
PKG_DEPENDS_HOST="llvm:host"

configure_host() {
     cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
    -DPYTHON_EXECUTABLE=$TOOLCHAIN/bin/python \
    -DBUILD_SHARED_LIBS=OFF \
    -DLLVM_LINK_LLVM_DYLIB=OFF \
    -DLLVM_ENABLE_RTTI=OFF \
    -DLLVM_BUILD_TESTS=ON \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_ENABLE_SPHINX=OFF \
    -DSPHINX_WARNINGS_AS_ERRORS=OFF \
    ..
}

post_makeinstall_host() {
  cp -a bin/clang-tblgen $TOOLCHAIN/bin
}

configure_target() {
     cmake -G Ninja \
     -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
     -DBUILD_SHARED_LIBS=OFF \
     -DCMAKE_BUILD_TYPE=Release \
     -DCLANG_BUILD_TOOLS=ON \
     -DCMAKE_CROSSCOMPILING=1 \
     -DCLANG_BUILD_EXAMPLES=OFF \
     -DCLANG_INCLUDE_DOCS=OFF \
     -DCLANG_INCLUDE_TESTS=OFF \
     -DLLVM_CONFIG=$SYSROOT/usr/bin/llvm-config \
     -DCLANG_TABLEGEN=$TOOLCHAIN/bin/clang-tblgen \
     -DLLVM_TABLEGEN_EXE=$TOOLCHAIN/bin/llvm-tblgen \
     -DLLVM_LINK_LLVM_DYLIB=ON \
     -DLLVM_DYLIB_COMPONENTS=all \
     ..
}