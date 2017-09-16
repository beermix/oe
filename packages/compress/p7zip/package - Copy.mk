PKG_NAME="p7zip"
PKG_VERSION="16.02"
PKG_SITE="http://p7zip.sourceforge.net/"
PKG_URL="http://downloads.sourceforge.net/project/p7zip/p7zip/${PKG_VERSION}/p7zip_${PKG_VERSION}_src_all.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_USE_CMAKE="yes"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   strip_lto
   #strip_gold
   #export CXXFLAGS="-O4 -pipe -ffast-math -fomit-frame-pointer -fexpensive-optimizations"
   #export CFLAGS="$CXXFLAGS"
   #export CPPFLAGS="-D_FORTIFY_SOURCE=2"
}


PKG_CMAKE_SCRIPT_TARGET="CPP/7zip/CMAKE/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release"