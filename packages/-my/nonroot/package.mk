PKG_NAME="nonroot"
PKG_VERSION="20120608"
PKG_URL="https://dl.dropboxusercontent.com/s/bt91fn9kxay56hh/nonroot-20120608.tar.bz2"
PKG_DEPENDS_TARGET="toolchain linux"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  make prefix=/usr
  make prefix=/usr install
}