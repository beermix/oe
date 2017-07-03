PKG_NAME="expat"
PKG_VERSION="R_2_2_1"
PKG_GIT_URL="https://github.com/libexpat/libexpat"
#PKG_VERSION="bfa1152"
#PKG_GIT_URL="https://github.com/libexpat/libexpat"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="textproc"

PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_SCRIPT_TARGET="expat/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"