PKG_NAME="CUnit"
PKG_VERSION="2.1-3"
PKG_URL="https://dl.dropboxusercontent.com/s/jdon3iktja5roh7/CUnit-2.1-3.tar.bz2"
PKG_SOURCE_DIR="x11vnc-0.9.14"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="service/system"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"
