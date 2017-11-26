PKG_NAME="xcalib"
PKG_VERSION="0.9.0"
PKG_URL="http://downloads.sourceforge.net/project/openicc/xcalib/xcalib%200.9/xcalib-0.9.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11 libXrandr libXxf86vm libxcb libXau libXext"

PKG_SECTION="my"


pre_configure_target() {
  cd $PKG_BUILD
  mkdir -p $INSTALL/usr/bin
}

MAKEFLAGS="-j1"

make_target() {
  make prefix=/usr CC="$CC" LD="$LD" AR="$AR" XCFLAGS="$CFLAGS" XLDFLAGS="$LDFLAGS"
}