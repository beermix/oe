PKG_NAME="clang"
PKG_VERSION="6.0.1"
PKG_SHA256="7c243f1485bddfdfedada3cd402ff4792ea82362ff91fbdac2dae67c6026b667"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
#PKG_URL="https://github.com/llvm-project/clang/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain clang:host libxml llvm zlib"
PKG_DEPENDS_HOST="llvm:host"
PKG_TOOLCHAIN="cmake-make"
#PKG_TOOLCHAIN="manual"

PKG_CMAKE_OPTS_HOST="-DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_CONFIG=$SYSROOT/usr/bin/llvm-config \
    -DCLANG_TABLEGEN=$TOOLCHAIN/usr/bin/clang-tblgen \
    -DLLVM_TABLEGEN_EXE=$TOOLCHAIN/bin/llvm-tblgen \
    -DLLVM_ENABLE_SPHINX=OFF \
    -DSPHINX_WARNINGS_AS_ERRORS=OFF"