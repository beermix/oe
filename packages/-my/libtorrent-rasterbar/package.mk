PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="7638183"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_DEPENDS_TARGET="toolchain openssl expat boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' $ROOT/$PKG_BUILD/configure
  #strip_lto
  #strip_gold
  set_target_properties(icarus PROPERTIES LINK_SEARCH_START_STATIC 1)
  set_target_properties(icarus PROPERTIES LINK_SEARCH_END_STATIC 1)
  set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")

...
#Set Linker flags
set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")
}

CFLAGS="-O3 -pipe -fstack-protector-strong"
CPPFLAGS="-D_FORTIFY_SOURCE=2"
LDFLAGS="-Wl,-O1,--sort-common,--as-needed"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-python-binding \
			      --with-libiconv \
			      --disable-geoip \
			      --disable-silent-rules \
			      --disable-deprecated-functions \
			      --with-boost=$SYSROOT_PREFIX/usr \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"
			      
			      