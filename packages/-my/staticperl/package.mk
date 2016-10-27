PKG_NAME="staticperl"
PKG_VERSION="b272b6fd861d1e00757cb29c1040dafe00671d90"
PKG_URL="https://github.com/gh0stwizard/staticperl-modules/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="staticperl-modules-b272b6fd861d1e00757cb29c1040dafe00671d90"
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  cd $ROOT/$PKG_BUILD
  ./staticperl install
}
