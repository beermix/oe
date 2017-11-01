# Made by github.com/escalade

PKG_NAME="redream-libretro"
PKG_VERSION="3ebfbe4"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://redream.io"
PKG_URL="https://github.com/inolen/redream/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="redream-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain cmake:host"
PKG_SECTION="escalade"
PKG_SHORTDESC="SEGA Dreamcast emulator"

PKG_USE_CMAKE="no"

make_target() {
  cd ..
  make -f deps/libretro/Makefile GIT_VERSION=$PKG_VERSION
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp redream_libretro.so $INSTALL/usr/lib/libretro/
}
