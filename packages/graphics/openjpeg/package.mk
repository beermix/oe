PKG_NAME="openjpeg"
PKG_VERSION="v2.1.2"
PKG_GIT_URL="https://github.com/uclouvain/openjpeg"
PKG_DEPENDS_TARGET="toolchain zlib libpng"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_CODEC=OFF"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL
}