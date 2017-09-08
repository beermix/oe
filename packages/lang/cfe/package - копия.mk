PKG_NAME="cfe"
PKG_VERSION="5.0.0"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://llvm.org/releases/$PKG_VERSION/${PKG_NAME}-${PKG_VERSION}.src.tar.xz"
PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}.src"
#PKG_DEPENDS_HOST="toolchain llvm"
PKG_DEPENDS_TARGET="toolchain llvm:host"
PKG_SECTION="lang"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
                       -DCMAKE_C_FLAGS="$CFLAGS" \
                       -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
                       -DLLVM_INCLUDE_TOOLS=ON \
                       -DLLVM_BUILD_TOOLS=OFF \
                       -DLLVM_BUILD_UTILS=ON \
                       -DLLVM_BUILD_EXAMPLES=OFF \
                       -DLLVM_INCLUDE_EXAMPLES=OFF \
                       -DLLVM_BUILD_TESTS=OFF \
                       -DLLVM_INCLUDE_TESTS=OFF \
                       -DLLVM_INCLUDE_GO_TESTS=OFF \
                       -DLLVM_BUILD_DOCS=OFF \
                       -DLLVM_INCLUDE_DOCS=OFF \
                       -DLLVM_ENABLE_DOXYGEN=OFF \
                       -DLLVM_ENABLE_SPHINX=OFF \
                       -DLLVM_TARGETS_TO_BUILD="X86" \
                       -DLLVM_ENABLE_TERMINFO=OFF \
                       -DLLVM_ENABLE_ASSERTIONS=OFF \
                       -DLLVM_ENABLE_WERROR=OFF \
                       -DLLVM_TARGET_ARCH="$TARGET_ARCH" \
                       -DLLVM_TABLEGEN=$ROOT/$TOOLCHAIN/bin/llvm-tblgen"
                       
PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"