PKG_NAME="clang"
PKG_VERSION="6.0.1"
PKG_SHA256="7c243f1485bddfdfedada3cd402ff4792ea82362ff91fbdac2dae67c6026b667"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION*"
PKG_DEPENDS_HOST="llvm:host"

configure_host() {
  cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
    -DPYTHON_EXECUTABLE="$TOOLCHAIN/bin/python2" \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_DYLIB_COMPONENTS=all \
    -DCLANG_BUILD_EXAMPLES=OFF \
    -DCLANG_INCLUDE_DOCS=OFF \
    -DCLANG_INCLUDE_TESTS=OFF \
    -DCLANG_BUILD_TOOLS=ON \
    -DLLVM_CONFIG:FILEPATH="$TOOLCHAIN/bin/llvm-config" \
    ..
}
	
make_host() {
  ninja -j${CONCURRENCY_MAKE_LEVEL}
}

post_makeinstall_host() {
  ln -sf clang $TOOLCHAIN/bin/x86_64-libreelec-linux-gnu-clang
  ln -sf clang $TOOLCHAIN/bin/x86_64-libreelec-linux-gnu-clang++
}