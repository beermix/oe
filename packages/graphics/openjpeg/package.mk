PKG_NAME="openjpeg"
PKG_VERSION="2.3.1"
PKG_URL="https://github.com/uclouvain/openjpeg/archive/$PKG_VERSION.tar.gz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libxml2 libpng libjpeg-turbo tiff"
PKG_SECTION="graphics"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 -DBUILD_THIRDPARTY=1"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/openjpeg-2.3
}