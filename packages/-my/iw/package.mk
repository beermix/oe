PKG_NAME="iw"
PKG_VERSION="4.9"
PKG_SITE="http://wireless.kernel.org/en/users/Documentation/iw"
PKG_URL="https://www.kernel.org/pub/software/network/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libnl"
PKG_SECTION="tools"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
   strip_lto
   export LIBS="-lm"
}

make_target() {
  make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS -D_GNU_SOURCE -ffunction-sections -fdata-sections" RANLIB="$RANLIB" LDFLAGS="$LDFLAGS -Wl,--gc-sections -pthread" -j1
}