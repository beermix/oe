PKG_NAME="bridge-utils"
PKG_VERSION="1.5"
PKG_URL="http://downloads.sourceforge.net/project/bridge/bridge/bridge-utils-1.5.tar.gz"
#PKG_SOURCE_DIR="bdwgc-gc7_4_4"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static"
