PKG_NAME="clang"
PKG_VERSION="5.0.1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://releases.llvm.org/$PKG_VERSION/cfe-$PKG_VERSION.src.tar.xz"
PKG_SOURCE_DIR="cfe-$PKG_VERSION.src"
PKG_DEPENDS_TARGET="toolchain llvm:host libxml2"
PKG_SECTION="lang"
PKG_SHORTDESC="C language family frontend for LLVM"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"
PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release"