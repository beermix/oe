PKG_NAME="i2pd"
PKG_VERSION="2.10.0"
PKG_GIT_URL="https://github.com/PurpleI2P/i2pd"
PKG_DEPENDS_TARGET="toolchain boost libz openssl miniupnpc"
PKG_SECTION="my"



pre_configure_target() {
   strip_lto
   export LIBS="-pthread"
   CFLAGS="$CFLAGS -isystem"
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