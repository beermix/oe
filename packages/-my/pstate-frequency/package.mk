PKG_NAME="pstate-frequency"
PKG_VERSION="2bbd296"
PKG_URL="https://github.com/pyamsoft/pstate-frequency/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"

PKG_SECTION="tools"
PKG_SHORTDESC="mono"
PKG_LONGDESC="mono"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

MAKEFLAGS="-j1"

make_target() {
  make prefix=/usr \
       CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS"
}