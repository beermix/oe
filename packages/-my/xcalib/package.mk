PKG_NAME="xcalib"
PKG_VERSION="0.8.dfsg1"
PKG_URL="https://dl.dropboxusercontent.com/s/xuwrntdqqyi7trm/xcalib_0.8.dfsg1.orig.tar.gz"
#PKG_URL="https://sourceforge.net/projects/xcalib/files/xcalib/0.8/xcalib-source-0.8.tar.gz"
PKG_DEPENDS_TARGET="toolchain xorg-server libX11 libXau libXext libXrandr libXxf86vm libxcb"
#PKG_DEPENDS_TARGET="toolchain libICE libpciaccess libSM libX11 libXau libxcb libXcomposite libXdamage libXext libXfixes libXfont libXi libXinerama libxkbfile libXmu libXrandr libXrender libxshmfence libXt libXtst libXxf86vm"
PKG_SECTION="my"
PKG_AUTORECONF="no"


pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  mkdir -p $INSTALL/usr/bin
}

