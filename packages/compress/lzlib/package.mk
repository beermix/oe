PKG_NAME="lzlib"
PKG_VERSION="1.11"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain lzo xz"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"

make_target() {
  make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" -j1
}
