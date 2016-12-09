PKG_NAME="libarchive"
PKG_VERSION="3.2.2"
PKG_URL="http://www.libarchive.org/downloads/libarchive-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain expat pcre libz xz bzip2 lz4 openssl"

PKG_SECTION="x11/lib"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DBUILD_TESTING=OFF \
			  -DENABLE_CAT_SHARED=OFF \
			  -DENABLE_CPIO_SHARED=OFF \
			  -DENABLE_LibGCC=ON \
			  -DENABLE_TEST=OFF"
			  
PKG_CMAKE_OPTS_HOST="$PKG_CMAKE_OPTS_TARGET"
		       
#post_makeinstall_target() {
#  ln -sf $INSTALL/usr/bin/bsdtar $INSTALL/usr/bin/tar
#}