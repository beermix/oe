PKG_NAME="openjpeg"
PKG_VERSION="53f2520"
PKG_URL="https://github.com/uclouvain/openjpeg/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libpng"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DBUILD_CODEC=ON \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_THIRDPARTY=ON \
        ..
}

post_make_target() {
  rm -rf $INSTALL/
}