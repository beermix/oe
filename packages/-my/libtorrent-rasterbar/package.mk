PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="b065536"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_DEPENDS_TARGET="toolchain openssl expat boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  sh autotool.sh
  export CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE"
  sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' $ROOT/$PKG_BUILD/configure
  sed -i -e s/Windows.h/windows.h/ -e s/Wincrypt.h/wincrypt.h/ $ROOT/$PKG_BUILD/ed25519/src/seed.cpp
  
  #export CFLAGS="-O3 -pipe -fstack-protector-strong"
  #CPPFLAGS="-D_FORTIFY_SOURCE=2"
  #LDFLAGS="-Wl,-O1,--sort-common,--as-needed"
  strip_lto
}


PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-deprecated-functions \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
			      --disable-geoip \
			      --disable-silent-rules"
			      
			      