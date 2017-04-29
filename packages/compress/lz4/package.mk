PKG_NAME="lz4"
PKG_VERSION="37ef330"
PKG_GIT_URL="https://github.com/Cyan4973/lz4"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="cmake:host"
PKG_SECTION="compress"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_SCRIPT_HOST="contrib/cmake_unofficial/CMakeLists.txt"

PKG_CMAKE_OPTS_HOST="-DCMAKE_INSTALL_PREFIX=$ROOT/$TOOLCHAIN \
			-DBUILD_SHARED_LIBS=OFF \
			-DBUILD_STATIC_LIBS=ON \
			-DLZ4_POSITION_INDEPENDENT_LIB=ON"

PKG_CMAKE_SCRIPT_TARGET="contrib/cmake_unofficial/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON -DLZ4_POSITION_INDEPENDENT_LIB=ON"
