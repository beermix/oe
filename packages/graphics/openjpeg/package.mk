PKG_NAME="openjpeg"
PKG_VERSION="2.3.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib xz libxml2 libpng libjpeg-turbo tiff lcms2"
PKG_SECTION="my"

PKG_USE_NINJA="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=1 -DBUILD_CODEC=1"