PKG_NAME="x265"
PKG_VERSION="2.1"
PKG_URL="https://bitbucket.org/multicoreware/x265/downloads/x265_$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="x265_$PKG_VERSION"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  cp -r $PKG_BUILD/source/* $PKG_BUILD/
}

PKG_CMAKE_OPTS_TARGET="-DEXPORT_C_API=OFF \
		       -DENABLE_SHARED=OFF \
		       -DENABLE_CLI=OFF"


makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
  cp x265.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
  cp libx265.a $SYSROOT_PREFIX/usr/lib/
  cp x265_config.h $SYSROOT_PREFIX/usr/include/
  cp ../x265.h $SYSROOT_PREFIX/usr/include/
}