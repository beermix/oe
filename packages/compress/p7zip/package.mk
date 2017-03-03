PKG_NAME="p7zip"
PKG_VERSION="16.02"
PKG_SITE="http://p7zip.sourceforge.net/"
PKG_URL="http://downloads.sourceforge.net/project/p7zip/p7zip/${PKG_VERSION}/p7zip_${PKG_VERSION}_src_all.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain zlib"

PKG_CMAKE_SCRIPT="$ROOT/$PKG_BUILD/CPP/7zip/CMAKE/CMakeLists.txt"

pre_configure_target() {
   #strip_lto
   export CXXFLAGS="-Wall -Wextra -Ofast -pipe -fomit-frame-pointer -fexpensive-optimizations -fstack-protector-strong"
   #export CFLAGS="$CXXFLAGS"
   #export CPPFLAGS="-D_FORTIFY_SOURCE=2"
}

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release"