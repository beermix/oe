PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="6d5625e"
PKG_SITE="https://github.com/arvidn/libtorrent/tree/RC_1_1"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_GIT_BRANCH="RC_1_0"
PKG_DEPENDS_TARGET="toolchain boost openssl"
PKG_LONGDESC="An efficient feature complete C++ bittorrent implementation"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

#CONCURRENCY_MAKE_LEVEL=1

PKG_CONFIGURE_OPTS_TARGET="--disable-python-binding \
                           --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
                           --without-libiconv"

post_unpack() {
  mkdir -p $ROOT/$PKG_BUILD/build-aux/
  touch $ROOT/$PKG_BUILD/build-aux/config.rpath
}

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3|"`
  sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' $ROOT/$PKG_BUILD/configure
  sed -i -e s/Windows.h/windows.h/ -e s/Wincrypt.h/wincrypt.h/ $ROOT/$PKG_BUILD/ed25519/src/seed.cpp
  cp -PR ../* .
}
