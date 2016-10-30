PKG_NAME="x265"
PKG_VERSION="2.1"
PKG_URL="https://bitbucket.org/multicoreware/x265/downloads/x265_$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="x265_$PKG_VERSION"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CMAKE_SCRIPT_TARGET="source/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DEXPORT_C_API=0 \
		       -DHAVE_INT_TYPES_H=1 \
		       -DHIGH_BIT_DEPTH=1 \
		       -DX265_ARCH_X86=1 \
		       -DX265_DEPTH=10 \
		       -DX265_NS=x265_10bit \
		       -DX86_64=1 -D__STDC_LIMIT_MACROS=1 \
		       -DENABLE_CLI=OFF"


