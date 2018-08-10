PKG_NAME="clang"
PKG_VERSION="6.0.1"
PKG_SHA256="7c243f1485bddfdfedada3cd402ff4792ea82362ff91fbdac2dae67c6026b667"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION*"
PKG_DEPENDS_TARGET="clang:host"
PKG_DEPENDS_HOST="llvm:host"

configure_host() {
     cmake -G Ninja \
     -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN \
     -DCMAKE_BUILD_TYPE=Release \
     -DCLANG_BUILD_TOOLS=ON \
     -DCLANG_BUILD_EXAMPLES=OFF \
     -DCLANG_INCLUDE_DOCS=OFF \
     -DCLANG_INCLUDE_TESTS=OFF \
     -DLLVM_CONFIG:FILEPATH=$TOOLCHAIN/bin/llvm-config \
     -DLLVM_LINK_LLVM_DYLIB=ON \
     -DLLVM_DYLIB_COMPONENTS=all \
     ..
}

post_makeinstall_host() {

cat >  ${TARGET_PREFIX}clang <<EOF
#!/bin/sh
$TOOLCHAIN/bin/ccache $TOOLCHAIN/bin/clang "\$@"
EOF

chmod +x ${TARGET_PREFIX}clang

cat >  ${TARGET_PREFIX}clang++ <<EOF
#!/bin/sh
$TOOLCHAIN/bin/ccache $TOOLCHAIN/bin/clang++ "\$@"
EOF

chmod +x ${TARGET_PREFIX}clang++
}