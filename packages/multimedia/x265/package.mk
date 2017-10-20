PKG_NAME="x265"
PKG_VERSION="2.5"
#PKG_URL="https://dl.dropboxusercontent.com/s/c7txy9sdgub1x96/x265_2.5.tar.gz"
PKG_URL="https://bitbucket.org/multicoreware/x265/downloads/x265_$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="x265_$PKG_VERSION"
PKG_SECTION="multimedia"
PKG_AUTORECONF="no"
PKG_USE_NINJA="yes"

PKG_CMAKE_SCRIPT="$PKG_BUILD/source/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DENABLE_CLI=0 \
			  -DENABLE_SHARED=0 \
			  -DENABLE_ASSEMBLY=0 \
			  -DEXPORT_C_API=1 \
			  -DHIGH_BIT_DEPTH=1 \
			  -DSTATIC_LINK_CRT=1"