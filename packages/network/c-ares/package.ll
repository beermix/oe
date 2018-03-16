PKG_NAME="c-ares"
PKG_VERSION="79ead9f"
PKG_GIT_URL="https://github.com/c-ares/c-ares"
PKG_URL="https://github.com/c-ares/c-ares/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_SECTION="my"

PKG_USE_CMAKE="yes"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

