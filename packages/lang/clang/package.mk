PKG_NAME="clang"
PKG_VERSION="6.0.1"
PKG_SHA256="7c243f1485bddfdfedada3cd402ff4792ea82362ff91fbdac2dae67c6026b667"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION*"
#PKG_DEPENDS_TARGET="clang:host"
#PKG_DEPENDS_HOST="llvm:host"

configure_host() {
  cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
    -DPYTHON_EXECUTABLE="$TOOLCHAIN/bin/python2" \
    -DBUILD_SHARED_LIBS=OFF \
    -DLLVM_LINK_LLVM_DYLIB=OFF \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_BUILD_TESTS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_EXTERNAL_LIT=/usr/bin/lit \
    -DLLVM_MAIN_SRC_DIR="$(get_build_dir llvm)" \
    ..
}

make_host() {
  ninja
}