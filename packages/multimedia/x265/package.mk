PKG_NAME="x265"
PKG_VERSION="2.5"
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

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DENABLE_CLI=0 \
			  -DENABLE_SHARED=1 \
			  -DENABLE_ASSEMBLY=1 \
			  -DEXPORT_C_API=1 \
			  -DHIGH_BIT_DEPTH=1 \
			  -DSTATIC_LINK_CRT=1 \
			  -DYASM_EXECUTABLE=$ROOT/$TOOLCHAIN/bin/yasm"