PKG_NAME="waf"
PKG_VERSION="waf-1.9.9"
PKG_GIT_URL="https://github.com/waf-project/waf"
PKG_DEPENDS_HOST="toolchain Python:host boost"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  ./configure build
}