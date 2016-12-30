PKG_NAME="antizapret"
PKG_VERSION="16dd799"
PKG_GIT_URL="https://github.com/afedchin/antizapret"
PKG_DEPENDS_TARGET="toolchain Python"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_LOCALE_INSTALL="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
}