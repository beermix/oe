PKG_NAME="clang"
PKG_VERSION="6.0.1"
PKG_SHA256="7c243f1485bddfdfedada3cd402ff4792ea82362ff91fbdac2dae67c6026b667"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
#PKG_URL="https://github.com/llvm-project/clang/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION*"
PKG_DEPENDS_TARGET="clang:host"
PKG_DEPENDS_HOST="llvm:host"
#PKG_TOOLCHAIN="cmake-make"

configure_host() {
     cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
    -DPYTHON_EXECUTABLE=$TOOLCHAIN/bin/python \
    -DBUILD_SHARED_LIBS=ON \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_ENABLE_RTTI=OFF \
    -DLLVM_BUILD_TESTS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_ENABLE_SPHINX=OFF \
    -DSPHINX_WARNINGS_AS_ERRORS=OFF \
    -DLLVM_MAIN_SRC_DIR="$srcdir/llvm-$pkgver.src" \
    -DCMAKE_CXX_FLAGS="${TARGET_CXXFLAGS} -Wno-uninitialized" \
    ..
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
     -DLLVM_CONFIG:FILEPATH=$SYSROOT/usr/bin/llvm-config \
     -DCLANG_TABLEGEN:FILEPATH=$TOOLCHAIN/usr/bin/clang-tblgen \
     -DLLVM_TABLEGEN_EXE:FILEPATH=$TOOLCHAIN/bin/llvm-tblgen \
     -DLLVM_LINK_LLVM_DYLIB=ON \
     -DLLVM_DYLIB_COMPONENTS=all \
     ..
}