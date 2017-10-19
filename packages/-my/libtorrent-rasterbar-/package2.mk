PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.0.11"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_11/libtorrent-rasterbar-1.0.11.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl expat boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"

PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $PKG_BUILD
  export CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE"
  sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' $PKG_BUILD/configure
  sed -i -e s/Windows.h/windows.h/ -e s/Wincrypt.h/wincrypt.h/ $PKG_BUILD/ed25519/src/seed.cpp
  
  #CFLAGS="-O3 -pipe -fstack-protector-strong"
  #CPPFLAGS="-D_FORTIFY_SOURCE=2"
  #LDFLAGS="-Wl,-O1,--sort-common,--as-needed"
}


PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-deprecated-functions \
			      --with-boost-system=$SYSROOT_PREFIX/usr/lib \
			      --with-boost-thread=$SYSROOT_PREFIX/usr/lib \
			      --with-boost-regex=$SYSROOT_PREFIX/usr/lib \
			      --with-boost-filesystem=$SYSROOT_PREFIX/usr/lib \
			      --with-boost-locale=$SYSROOT_PREFIX/usr/lib \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
			      --disable-geoip"
			      
			      