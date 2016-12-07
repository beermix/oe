PKG_NAME="libevent"
PKG_VERSION="32adf43"
PKG_GIT_URL="https://github.com/libevent/libevent"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_TESTING=OFF \
			  -DEVENT_STAGE_NAME=release \
			  -DEVENT__BUILD_SHARED_LIBRARIES=OFF \
			  -DEVENT__DISABLE_SAMPLES=ON \
			  -DEVENT__DISABLE_TESTS=ON \
			  -DFIND_PYTHON2=$SYSROOT_PREFIX/usr/bin/python2.7"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}
