PKG_NAME="clang"
PKG_VERSION="bdb1c36"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/llvm-mirror/clang/tree/release_70"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
PKG_URL="https://github.com/llvm-mirror/clang/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION*"
PKG_SOURCE_DIR="clang-$PKG_VERSION*"
PKG_DEPENDS_HOST="llvm:host lld:host"

configure_host() {
  cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
    -DCLANG_BUILD_TOOLS=ON \
    -DCLANG_BUILD_EXAMPLES=OFF \
    -DCLANG_INCLUDE_DOCS=OFF \
    -DCLANG_INCLUDE_TESTS=OFF
    -DLLVM_CONFIG:FILEPATH=$TOOLCHAIN/bin/llvm-config \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_DYLIB_COMPONENTS=all
}
	
make_host() {
  ninja -j${CONCURRENCY_MAKE_LEVEL}
}

post_makeinstall_host() {
  ln -sf clang $TOOLCHAIN/bin/x86_64-libreelec-linux-gnu-clang
  ln -sf clang $TOOLCHAIN/bin/x86_64-libreelec-linux-gnu-clang++
}