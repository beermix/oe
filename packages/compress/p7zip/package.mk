PKG_NAME="p7zip"
PKG_VERSION="16.02"
PKG_SITE="http://p7zip.sourceforge.net/"
PKG_URL="http://downloads.sourceforge.net/project/p7zip/p7zip/${PKG_VERSION}/p7zip_${PKG_VERSION}_src_all.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_USE_CMAKE="yes"




PKG_CMAKE_SCRIPT="$PKG_BUILD/CPP/7zip/CMAKE/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release"


make_host() {
  make CXX=$CXX CC=$CC 7za
}

#make_target() {
#  cd $PKG_BUILD
#  make makefile.linux_amd64 CXX=$CXX CC=$CC 7z 7za
#}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
    cp bin/7za $TOOLCHAIN/bin
}


