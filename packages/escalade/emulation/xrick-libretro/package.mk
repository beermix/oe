# Made by github.com/escalade

PKG_NAME="xrick-libretro"
PKG_VERSION="3d49a66"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/r-type/xrick-libretro"
PKG_URL="https://github.com/r-type/xrick-libretro/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="emulation"
PKG_SHORTDESC="Xrick is an open source implementation of the legendary game Rick Dangerous."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make -f Makefile.libretro CC=$CC
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp *.so $INSTALL/usr/lib/libretro/
}
