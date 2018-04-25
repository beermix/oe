PKG_NAME="p7zip"
PKG_VERSION="16.02"
PKG_SITE="http://p7zip.sourceforge.net/"
PKG_URL="http://downloads.sourceforge.net/project/p7zip/p7zip/${PKG_VERSION}/p7zip_${PKG_VERSION}_src_all.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_TOOLCHAIN="cmake-make"

#pre_configure_target() {
#  export LDFLAGS="$LDFLAGS -pthread -libm -lc"
#}

PKG_CMAKE_SCRIPT="$PKG_BUILD/CPP/7zip/CMAKE/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"
PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release"
