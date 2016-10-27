PKG_NAME="p7zip"
PKG_VERSION="16.02"
PKG_SITE="http://p7zip.sourceforge.net/"
PKG_URL="http://downloads.sourceforge.net/project/p7zip/p7zip/${PKG_VERSION}/p7zip_${PKG_VERSION}_src_all.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_PRIORITY="optional"

strip_lto
CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"

PKG_CMAKE_SCRIPT_TARGET="CPP/7zip/CMAKE/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"