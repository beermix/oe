PKG_NAME="cfe"
PKG_VERSION="6.0.0"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://llvm.org/releases/$PKG_VERSION/${PKG_NAME}-${PKG_VERSION}.src.tar.xz"
PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}.src"
PKG_DEPENDS_TARGET="toolchain llvm:host libxml2"
PKG_SECTION="lang"
PKG_SHORTDESC="C language family frontend for LLVM"

#post_unpack() {
#  ln -sf $PKG_BUILD/.$TARGET_NAME/bin/clang-tblgen $BUILD/toolchain/bin/
#}

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"
#PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"
