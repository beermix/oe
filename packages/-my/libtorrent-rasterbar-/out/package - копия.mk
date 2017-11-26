PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.0.10"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_10/libtorrent-rasterbar-1.0.10.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain openssl expat boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"



pre_configure_target() {
  cd $PKG_BUILD
  strip_lto
  #export CXXFLAGS="$CXXFLAGS -std=gnu++98"
  #CFLAGS="$CFLAGS -fPIC -std=gnu99"
  #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Ofast|"`
  sed -i 's/$PKG_CONFIG openssl --libs-only-l/$PKG_CONFIG openssl --static --libs-only-l/' ./configure
  sed -i -e s/Windows.h/windows.h/ -e s/Wincrypt.h/wincrypt.h/ ./ed25519/src/seed.cpp
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --enable-python-binding \
			      --without-libiconv \
			      --disable-geoip \
			      --with-boost=$SYSROOT_PREFIX/usr \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"
			      
			      
#PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
#			  -Dunicode=ON \
#			  -Dstatic_runtime=ON \
#			  -Dshared=OFF \
#			  -Dlibiconv=OFF \
#			  -Dencryption=ON"