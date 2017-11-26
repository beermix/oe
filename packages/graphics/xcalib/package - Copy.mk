PKG_NAME="xcalib"
PKG_VERSION="master"
PKG_URL="https://github.com/OpenICC/xcalib/archive/master.zip"
PKG_DEPENDS_TARGET="toolchain libX11 libXrandr libXxf86vm libxcb"

PKG_SECTION="my"


configure_target() {
	cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
  	-DCMAKE_INSTALL_PREFIX=/usr \
  	..
}
