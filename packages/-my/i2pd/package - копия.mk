PKG_NAME="i2pd"
PKG_VERSION="280407a"
PKG_GIT_URL="https://github.com/PurpleI2P/i2pd"
PKG_DEPENDS_TARGET="toolchain boost zlib openssl miniupnpc"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   strip_lto
   strip_gold
}

PKG_CMAKE_SCRIPT="$PKG_BUILD/build/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DWITH_LIBRARY=ON \
			  -DWITH_PCH=OFF \
			  -DWITH_MESHNET=OFF \
			  -DWITH_STATIC=OFF \
			  -DWITH_UPNP=ON \
			  -DTHREADS_PTHREAD_ARG=4 \
			  -DWITH_HARDENING=OFF \
			  -DWITH_AESNI=ON"

post_makeinstall_target() {
 rm -rf $INSTALL/usr/src/
 rm  $INSTALL/usr/LICENSE
}