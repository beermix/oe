PKG_NAME="c-ares"
PKG_VERSION="0b62958"
PKG_GIT_URL="https://github.com/c-ares/c-ares"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_SECTION="my"

PKG_AUTORECONF="no"
PKG_USE_CMAKE="yes"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

