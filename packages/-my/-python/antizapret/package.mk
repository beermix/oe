PKG_NAME="antizapret"
PKG_VERSION="c6f9bd8"
PKG_GIT_URL="https://github.com/afedchin/antizapret"
PKG_DEPENDS_TARGET="toolchain Python"


PKG_LOCALE_INSTALL="no"

pre_configure_target() {
  cd $PKG_BUILD
}