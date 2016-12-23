PKG_NAME="lz4"
PKG_VERSION="v1.7.4.2"
PKG_GIT_URL="https://github.com/Cyan4973/lz4"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="cmake:host"
PKG_SECTION="compress"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_SCRIPT_TARGET="contrib/cmake_unofficial/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF"

configure_host() {
  cd contrib/cmake_unofficial
  cmake -DCMAKE_INSTALL_PREFIX=$ROOT/$TOOLCHAIN \
  	 -DCMAKE_BUILD_TYPE=Release \
  	 -DBUILD_SHARED_LIBS=OFF
}


# -DLZ4_POSITION_INDEPENDENT_LIB=ON