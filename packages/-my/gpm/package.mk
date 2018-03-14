PKG_NAME="gpm"
PKG_VERSION="1.99.7"
PKG_URL="http://www.nico.schottelius.org/software/gpm/archives/gpm-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain" 
PKG_SECTION="my"

MAKEFLAGS="-j1"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}