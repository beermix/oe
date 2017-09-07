PKG_NAME="pstate-frequency"
PKG_VERSION="3.7.4"
PKG_GIT_URL="https://github.com/pyamsoft/pstate-frequency"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_SECTION="tools"
PKG_SHORTDESC="mono"
PKG_LONGDESC="mono"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make prefix=/usr install
}