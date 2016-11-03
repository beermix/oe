PKG_NAME="xcalib"
PKG_VERSION="master"
PKG_GIT_URL="https://github.com/OpenICC/xcalib"
PKG_DEPENDS_TARGET="toolchain libX11 libXrandr libXxf86vm libxcb"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_AUTORECONF="no"
PKG_USE_CMAKE="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  mkdir -p $INSTALL/usr/bin
}

MAKEFLAGS="-j1"

make_target() {
  make prefix=/usr CC="$CC" LD="$LD" AR="$AR" XCFLAGS="$CFLAGS" XLDFLAGS="$LDFLAGS"
}