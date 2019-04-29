PKG_NAME="bridge-utils"
PKG_VERSION="1.6"
PKG_URL="https://www.kernel.org/pub/linux/utils/net/bridge-utils/bridge-utils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"

PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

