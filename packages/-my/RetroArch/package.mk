PKG_NAME="RetroArch"
PKG_VERSION="1.3.4"
PKG_URL="https://github.com/libretro/RetroArch/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"



configure_target() {
  cd $ROOT/$PKG_BUILD
  ./fetch-submodules.sh
}
PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --enable-sse --disable-d3d9 --enable-opengl --enable-x11 --enable-xinerama --enable-alsa --enable-freetype --disable-jack --disable-cg --disable-oss"