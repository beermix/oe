PKG_NAME="cffi"
PKG_VERSION="67a9ff4"
PKG_GIT_URL="https://github.com/cffi/cffi.git"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"

PKG_SECTION="python/security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
  make shlibs
}