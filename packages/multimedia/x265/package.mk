PKG_NAME="x265"
PKG_VERSION="2.7"
PKG_URL="https://bitbucket.org/multicoreware/x265/downloads/x265_$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain nasm:host"
PKG_SOURCE_DIR="x265_$PKG_VERSION"
PKG_SECTION="multimedia"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_SCRIPT="$PKG_BUILD/source/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DENABLE_SHARED=0 \
			  -DHIGH_BIT_DEPTH=1 \
			  -DMAIN12=1 \
			  -DEXPORT_C_API=1 \
			  -DENABLE_CLI=0 \
			  -DENABLE_SHARED=1"