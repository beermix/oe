PKG_NAME="openjpeg"
PKG_VERSION="2.3.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib xz libxml2 libpng libjpeg-turbo tiff"
PKG_SECTION="graphics"
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
}

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0 -DBUILD_CODEC=1"

post_makeinstall_target() {
  rm -rf $INSTALL
}