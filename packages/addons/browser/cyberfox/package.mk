PKG_NAME="cyberfox"
PKG_VERSION="60770e6"
PKG_GIT_URL="https://github.com/InternalError503/cyberfox"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="no"


configure_target() {
  cd $ROOT/$PKG_BUILD
  sh mach build
}