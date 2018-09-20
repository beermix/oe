PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="621da10"
PKG_SITE="https://github.com/arvidn/libtorrent/tree/RC_1_1"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_GIT_BRANCH="RC_1_1"
PKG_DEPENDS_TARGET="toolchain boost libiconv openssl"
PKG_LONGDESC="An efficient feature complete C++ bittorrent implementation"
PKG_USE_CMAKE="no"
PKG_TOOLCHAIN="autotools"

#CONCURRENCY_MAKE_LEVEL=1

PKG_CONFIGURE_OPTS_TARGET="--enable-python-binding \
                           --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
                           --with-libiconv"

post_unpack() {
  mkdir -p $PKG_BUILD/build-aux/
  touch $PKG_BUILD/build-aux/config.rpath
}

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3|"`
  cp -PR ../* .
}
