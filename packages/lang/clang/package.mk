PKG_NAME="clang"
PKG_VERSION="7.0.1"
PKG_SHA256="a45b62dde5d7d5fdcdfa876b0af92f164d434b06e9e89b5d0b1cbc65dfe3f418"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/llvm-mirror/clang/tree/release_70"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
PKG_URL="http://llvm.org/releases/$PKG_VERSION/cfe-${PKG_VERSION}.src.tar.xz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION*"
#PKG_SOURCE_DIR="clang-$PKG_VERSION*"
PKG_DEPENDS_HOST="llvm:host lld:host"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release \
			-DLLVM_LINK_LLVM_DYLIB=ON \
			-DLLVM_DYLIB_COMPONENTS=all \
			-DCLANG_BUILD_EXAMPLES=OFF \
			-DCLANG_INCLUDE_DOCS=OFF \
			-DCLANG_INCLUDE_TESTS=OFF \
			-DCLANG_BUILD_TOOLS=ON"


#post_makeinstall_host() {
#  ln -sf $TOOLCHAIN/bin/clang $TOOLCHAIN/bin/x86_64-libreelec-linux-gnu-clang
#  ln -sf $TOOLCHAIN/bin/clang $TOOLCHAIN/bin/x86_64-libreelec-linux-gnu-clang++
#}