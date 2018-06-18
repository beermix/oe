PKG_NAME="zapcc"
PKG_VERSION="01"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://192.168.1.200:8080/%2Fzapcc-clang-01.tar.xz"
PKG_SOURCE_DIR="zapcc-clang-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain zapcc:host"
#PKG_DEPENDS_HOST="llvm:host"

configure_host() {
     cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
    -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
    -DPYTHON_EXECUTABLE=$TOOLCHAIN/bin/python \
    -DLLVM_ENABLE_WARNINGS=OFF \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    -DLLVM_MAIN_SRC_DIR="/home/user/.br/arch-packages/clang/trunk/src/llvm-6.0.0.src" \
    ..
}

#PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WARNINGS=OFF"

#PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WARNINGS=OFF"

configure_host() {
     cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DPYTHON_EXECUTABLE=$TOOLCHAIN/bin/python \
    -DLLVM_ENABLE_WARNINGS=OFF \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    ../llvm
}