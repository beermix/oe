PKG_NAME="x265"
PKG_VERSION="2.3"
PKG_URL="https://bitbucket.org/multicoreware/x265/downloads/x265_$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="x265_$PKG_VERSION"
PKG_SECTION="multimedia"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#pre_configure_target() {
   #strip_lto
   #export LIBS="-lterminfo"
#}

PKG_CMAKE_SCRIPT_TARGET="source/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DLINKED_10BIT=ON \
			  -DLINKED_12BIT=ON \
			  -DENABLE_CLI=OFF \
			  -DENABLE_SHARED=ON \
			  -DENABLE_ASSEMBLY=OFF"