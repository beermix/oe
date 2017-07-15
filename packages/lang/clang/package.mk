# Made by github.com/escalade

PKG_NAME="clang"
PKG_VERSION="4.0.1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="https://dl.dropboxusercontent.com/s/64stoxn39ggfb5c/clang-4.0.1.tar.xz"
#PKG_SOURCE_DIR="cfe-$PKG_VERSION.src"
PKG_DEPENDS_TARGET="toolchain llvm:host libxml2"
PKG_SECTION="lang"
PKG_SHORTDESC="C language family frontend for LLVM"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  strip_lto
  strip_gold
}


PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"