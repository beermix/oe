PKG_NAME="clang"
PKG_VERSION="6.0.0"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
#PKG_URL="https://github.com/llvm-project/clang/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain Python2:host clang:host clang:host libxml2"
PKG_DEPENDS_HOST="llvm:host libxml2:host"
PKG_SECTION="lang"
PKG_SHORTDESC="C language family frontend for LLVM"
PKG_TOOLCHAIN="cmake-make"
#PKG_TOOLCHAIN="manual"

configure_host() {
     cmake  \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
    -DPYTHON_EXECUTABLE=$TOOLCHAIN/bin/python \
    -DBUILD_SHARED_LIBS=OFF \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_ENABLE_RTTI=OFF \
    -DLLVM_BUILD_TESTS=ON \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_ENABLE_SPHINX=OFF \
    -DSPHINX_WARNINGS_AS_ERRORS=OFF \
    -DLLVM_MAIN_SRC_DIR="$srcdir/llvm-$pkgver.src" \
    -DCMAKE_C_FLAGS="${TARGET_CFLAGS} -Wno-uninitialized" \
    -DCMAKE_CXX_FLAGS="${TARGET_CXXFLAGS} -Wno-uninitialized" \
    ..
}

CCPKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release \
  		      -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
  		      -DBUILD_SHARED_LIBS=OFF \
  		      -DLLVM_LINK_LLVM_DYLIB=OFF \
  		      -DLLVM_ENABLE_RTTI=ON \
  		      -DLLVM_BUILD_TESTS=ON \
  		      -DLLVM_INCLUDE_DOCS=OFF \
  		      -DLLVM_BUILD_DOCS=OFF \
  		      -DLLVM_ENABLE_SPHINX=OFF \
  		      -DSPHINX_WARNINGS_AS_ERRORS=OFF \
  		      -DLLVM_CONFIG:FILEPATH=$TOOLCHAIN/bin/llvm-config \
  		      -DLLVM_MAIN_SRC_DIR=$(get_build_dir llvm)"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=OFF \
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
			  -DLLVM_DYLIB_COMPONENTS=all"