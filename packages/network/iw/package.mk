PKG_NAME="iw"
PKG_VERSION="4.9"
PKG_SITE="http://wireless.kernel.org/en/users/Documentation/iw"
PKG_URL="https://www.kernel.org/pub/software/network/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libnl"
PKG_SECTION="tools"

make_target() {
  make CC="$CC" AR="$AR" XCFLAGS="$CFLAGS -ffunction-sections -fdata-sections" LDFLAGS="-lm -lpthread" -j1
}