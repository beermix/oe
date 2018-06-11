PKG_NAME="llvm"
PKG_VERSION="6.0.0"
PKG_SHA256="1ff53c915b4e761ef400b803f07261ade637b0c269d99569f18040f3dcee4408"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://llvm.org/releases/$PKG_VERSION/${PKG_NAME}-${PKG_VERSION}.src.tar.xz"
PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}.src"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain llvm:host zlib"
PKG_SECTION="lang"
PKG_SHORTDESC="llvm: Low Level Virtual Machine"
PKG_LONGDESC="Low-Level Virtual Machine (LLVM) is a compiler infrastructure designed for compile-time, link-time, run-time, and idle-time optimization of programs from arbitrary programming languages. It currently supports compilation of C, Objective-C, and C++ programs, using front-ends derived from GCC 4.0, GCC 4.2, and a custom new front-end, "clang". It supports x86, x86-64, ia64, PowerPC, and SPARC, with support for Alpha and ARM under development."
PKG_BUILD_FLAGS="-lto -gold -hardening"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_COMMON="-DLLVM_ENABLE_PROJECTS="" \
			  -DCMAKE_INSTALL_RPATH=$TOOLCHAIN/lib \
			  -DLLVM_CCACHE_BUILD=ON \
			  -DLLVM_TARGETS_TO_BUILD="X86" \
			  -DLLVM_TARGET_ARCH="$TARGET_ARCH" \
			  -DLLVM_TABLEGEN=$TOOLCHAIN/bin/llvm-tblgen \
			  -DBUILD_SHARED_LIBS=OFF \
			  -DLLVM_BUILD_LLVM_DYLIB=ON \
			  -DLLVM_LINK_LLVM_DYLIB=ON \
			  -DCMAKE_CROSSCOMPILING=1 \
			  -DLLVM_ENABLE_LIBEDIT=OFF \
			  -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF
			  -DLLVM_APPEND_VC_REV=OFF \
			  -DLLVM_ENABLE_BACKTRACES=OFF \
			  -DENABLE_CRASH_OVERRIDES=ON
			  -DLLVM_ENABLE_FFI=OFF \
			  -DLLVM_ENABLE_TERMINFO=OFF
			  -DLLVM_ENABLE_THREADS=ON
			  -DLLVM_ENABLE_ZLIB=ON \
			  -DLLVM_ENABLE_PIC=ON \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DLLVM_ENABLE_CXX1Y=ON \
			  -DLLVM_ENABLE_CXX1Z=ON \
			  -DLLVM_ENABLE_MODULES=OFF \
			  -DLLVM_ENABLE_MODULE_DEBUGGING=OFF \
			  -DLLVM_ENABLE_LIBCXX=OFF \
			  -DLLVM_ENABLE_LLD=OFF \
			  -DLLVM_DEFAULT_TARGET_TRIPLE=$TARGET_NAME \
			  -DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND \
			  -DOCAMLFIND=OCAMLFIND-NOTFOUND \
			  -DLLVM_OPTIMIZED_TABLEGEN=ON \
			  -DLLVM_BUILD_UTILS=ON \
			  -DLLVM_INCLUDE_UTILS=ON \
			  -DLLVM_INSTALL_UTILS=ON \
			  -DLLVM_INCLUDE_TOOLS=ON \
			  -DLLVM_BUILD_TOOLS=ON \
			  -DLLVM_INCLUDE_TOOLS=ON \
			  -DLLVM_BUILD_TOOLS=OFF \
			  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF \
			  -DLLVM_BUILD_RUNTIME=OFF \
			  -DLLVM_INCLUDE_RUNTIMES=OFF \
			  -DLLVM_POLLY_BUILD=OFF
			  -DLLVM_ENABLE_WARNINGS=ON \
			  -DLLVM_ENABLE_PEDANTIC=ON \
			  -DLLVM_ENABLE_WERROR=OFF \
			  -DLLVM_BUILD_EXAMPLES=OFF \
			  -DLLVM_BUILD_DOCS=OFF \
			  -DLLVM_BUILD_TESTS=OFF \
			  -DLLVM_ENABLE_DOXYGEN=OFF \
			  -DLLVM_ENABLE_OCAMLDOC=OFF \
			  -DLLVM_ENABLE_SPHINX=OFF \
			  -DLLVM_INCLUDE_EXAMPLES=OFF \
			  -DLLVM_INCLUDE_DOCS=OFF \
			  -DLLVM_INCLUDE_GO_TESTS=OFF \
			  -DLLVM_INCLUDE_TESTS=OFF"

PKG_CMAKE_OPTS_TARGET="-DLLVM_ENABLE_PROJECTS="" \
			  -DLLVM_CCACHE_BUILD=ON \
			  -DLLVM_TARGETS_TO_BUILD="X86" \
			  -DLLVM_TARGET_ARCH="$TARGET_ARCH" \
			  -DLLVM_TABLEGEN=$TOOLCHAIN/bin/llvm-tblgen \
			  -DBUILD_SHARED_LIBS=OFF \
			  -DLLVM_BUILD_LLVM_DYLIB=ON \
			  -DLLVM_LINK_LLVM_DYLIB=ON \
			  -DCMAKE_CROSSCOMPILING=1 \
			  -DLLVM_ENABLE_LIBEDIT=OFF \
			  -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF
			  -DLLVM_APPEND_VC_REV=OFF \
			  -DLLVM_ENABLE_BACKTRACES=OFF \
			  -DENABLE_CRASH_OVERRIDES=ON
			  -DLLVM_ENABLE_FFI=OFF \
			  -DLLVM_ENABLE_TERMINFO=OFF
			  -DLLVM_ENABLE_THREADS=ON
			  -DLLVM_ENABLE_ZLIB=ON \
			  -DLLVM_ENABLE_PIC=ON \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DLLVM_ENABLE_CXX1Y=ON \
			  -DLLVM_ENABLE_CXX1Z=ON \
			  -DLLVM_ENABLE_MODULES=OFF \
			  -DLLVM_ENABLE_MODULE_DEBUGGING=OFF \
			  -DLLVM_ENABLE_LIBCXX=OFF \
			  -DLLVM_ENABLE_LLD=OFF \
			  -DLLVM_DEFAULT_TARGET_TRIPLE=$TARGET_NAME \
			  -DLLVM_HOST_TRIPLE=$TARGET_NAME \
			  -DLLVM_BUILD_UTILS=OFF \
			  -DLLVM_INCLUDE_UTILS=OFF \
			  -DLLVM_INSTALL_UTILS=OFF \
			  -DLLVM_INCLUDE_TOOLS=ON \
			  -DLLVM_BUILD_TOOLS=OFF
			  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF \
			  -DLLVM_BUILD_RUNTIME=OFF \
			  -DLLVM_INCLUDE_RUNTIMES=OFF \
			  -DLLVM_POLLY_BUILD=OFF \
			  -DLLVM_ENABLE_WARNINGS=ON \
			  -DLLVM_ENABLE_PEDANTIC=ON \
			  -DLLVM_ENABLE_WERROR=OFF \
			  -DLLVM_BUILD_EXAMPLES=OFF \
			  -DLLVM_BUILD_DOCS=OFF \
			  -DLLVM_BUILD_TESTS=OFF \
			  -DLLVM_ENABLE_DOXYGEN=OFF \
			  -DLLVM_ENABLE_OCAMLDOC=OFF \
			  -DLLVM_ENABLE_SPHINX=OFF \
			  -DLLVM_INCLUDE_EXAMPLES=OFF \
			  -DLLVM_INCLUDE_DOCS=OFF \
			  -DLLVM_INCLUDE_GO_TESTS=OFF \
			  -DLLVM_INCLUDE_TESTS=OFF"


post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/LLVMHello.so
  rm -rf $INSTALL/usr/lib/libLTO.so
  rm -rf $INSTALL/usr/share
  
  cp $TOOLCHAIN/bin/llvm-config $SYSROOT_PREFIX/usr/bin/llvm-config
}
