PKG_NAME="i2pd"
PKG_VERSION="2.18.0"
PKG_URL="https://github.com/PurpleI2P/i2pd/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain boost zlib miniupnpc openssl"
PKG_SECTION="my"
PKG_TOOLCHAIN="make"

PKG_CMAKE_SCRIPT="$PKG_BUILD/build/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DWITH_LIBRARY=OFF \
			  -DWITH_PCH=OFF \
			  -DWITH_MESHNET=OFF \
			  -DWITH_STATIC=OFF \
			  -DWITH_UPNP=ON \
			  -DTHREADS_PTHREAD_ARG=4 \
			  -DWITH_HARDENING=OFF \
			  -DWITH_AESNI=ON"
			  
make_target() {
  cd $PKG_BUILD
  unset CPPFLAGS
  unset CFLAGS
  unset LDFLAGS
  unset CXXFLAGS
  export CXXFLAGS="$CXXFLAGS -march=haswell -O2"
  make USE_STATIC=no USE_AESNI=yes USE_AVX=yes USE_UPNP=yes \
  	CC=$CC \
  	CXX=$CXX \
  	LDFLAGS="-lpthread -static-libgcc -lrt -ldl -latomic -s" \
  	RANLIB="$RANLIB" \
  	AR=$AR
}