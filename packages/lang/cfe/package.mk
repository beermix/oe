PKG_NAME="cfe"
PKG_VERSION="5.0.0"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://llvm.org/"
PKG_URL="http://llvm.org/releases/$PKG_VERSION/${PKG_NAME}-${PKG_VERSION}.src.tar.xz"
PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}.src"
PKG_DEPENDS_TARGET="toolchain llvm:host libxml2"
PKG_SECTION="lang"
PKG_SHORTDESC="C language family frontend for LLVM"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  ln -sf $ROOT/$PKG_BUILD/.$TARGET_NAME/bin/clang-tblgen $ROOT/$BUILD/toolchain/bin/
}

pre_configure_target() {
  strip_lto
  strip_gold
  strip_hard
}

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"
#PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"