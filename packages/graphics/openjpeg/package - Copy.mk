PKG_NAME="openjpeg"
PKG_VERSION="2.2.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libpng"
PKG_SECTION="my"

PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_CODEC=OFF"

PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL
}