PKG_NAME="libarchive"
PKG_VERSION="412bae0"
PKG_GIT_URL="https://github.com/libarchive/libarchive"
PKG_DEPENDS_TARGET="toolchain expat pcre libz xz bzip2 openssl"

PKG_SECTION="x11/lib"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_TESTING=OFF \
		       -DENABLE_CAT_SHARED=OFF \
		       -DENABLE_CPIO_SHARED=OFF \
		       -DENABLE_LibGCC=ON \
		       -DENABLE_TEST=OFF"
		       
post_makeinstall_target() {
  ln -sf $INSTALL/usr/bin/bsdtar $INSTALL/usr/bin/tar
}