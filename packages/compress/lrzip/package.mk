PKG_NAME="lrzip"
PKG_VERSION="ac393ef"
PKG_GIT_URL="https://github.com/ckolivas/lrzip"
PKG_DEPENDS_TARGET="toolchain lzo zlib bzip2"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
}

make_target() {
  make \
       CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS" \
       all -j1
}
