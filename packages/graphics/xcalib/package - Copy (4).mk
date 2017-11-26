PKG_NAME="xcalib"
PKG_VERSION="95c9329"
PKG_GIT_URL="https://github.com/OpenICC/xcalib"
PKG_DEPENDS_TARGET="toolchain libX11 libXrandr libXxf86vm libxcb"

PKG_SECTION="my"

PKG_USE_CMAKE="yes"

pre_configure_target() {
  cd $PKG_BUILD
  mkdir -p $INSTALL/usr/bin
  export LDFLAGS="-lX11 -lXrandr -lXxf86vm -lXext -lm"
}

MAKEFLAGS="-j1"

make_target() {
  make prefix=/usr CC="$CC" LD="$LD" AR="$AR" XCFLAGS="$CFLAGS" XLDFLAGS="$LDFLAGS"
}