PKG_NAME="i2pd"
PKG_VERSION="9739e67"
PKG_URL="https://github.com/PurpleI2P/i2pd/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain boost zlib openssl miniupnpc boost"
PKG_SECTION="my"
PKG_AUTORECONF="no"
PKG_USE_CMAKE="yes"

PKG_CMAKE_SCRIPT="$PKG_BUILD/build/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DWITH_LIBRARY=OFF \
			  -DWITH_PCH=OFF \
			  -DWITH_MESHNET=OFF \
			  -DWITH_STATIC=OFF \
			  -DWITH_UPNP=ON \
			  -DTHREADS_PTHREAD_ARG=4 \
			  -DWITH_HARDENING=OFF \
			  -DWITH_AESNI=ON"
			  
#make_target() {
#  cd $PKG_BUILD
#  make \
#  	CC="$CC" \
#  	CFLAGS="$CFLAGS" \
#  	LDFLAGS="$LDFLAGS" \
#  	RANLIB="$RANLIB" \
#  	AR="$AR" \
#  	STRIP="$STRIP"
#}