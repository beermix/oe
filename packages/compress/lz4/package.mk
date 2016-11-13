PKG_NAME="lz4"
PKG_VERSION="r131"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://www.lz4.org/"
PKG_GIT_URL="https://github.com/Cyan4973/lz4"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="compress"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  :
}

makeinstall_target() {
  cd $ROOT/$PKG_BUILD/lib
  PREFIX=$SYSROOT_PREFIX/usr make install
}
