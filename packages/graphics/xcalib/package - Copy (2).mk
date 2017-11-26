PKG_NAME="xcalib"
PKG_VERSION="0.9.0"
PKG_URL="http://downloads.sourceforge.net/project/openicc/xcalib/xcalib%200.9/xcalib-0.9.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11 libXrandr libXxf86vm libxcb libXau libXext"

PKG_SECTION="my"


configure_target() {
cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/usr ..

}