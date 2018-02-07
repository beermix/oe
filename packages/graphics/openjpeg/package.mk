PKG_NAME="openjpeg"
PKG_VERSION="d96d2b9"
PKG_URL="https://github.com/uclouvain/openjpeg/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libxml2 libpng libjpeg-turbo tiff"
PKG_SECTION="graphics"
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
}

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=OFF -DBUILD_THIRDPARTY=OFF"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/openjpeg-2.3
}