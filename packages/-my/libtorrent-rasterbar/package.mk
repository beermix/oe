PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.1.4"
PKG_SITE="https://github.com/arvidn/libtorrent/tree/RC_1_1"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_4/libtorrent-rasterbar-1.1.4.tar.gz"
PKG_GIT_BRANCH="RC_1_1"
PKG_DEPENDS_TARGET="toolchain boost openssl"
PKG_LONGDESC="An efficient feature complete C++ bittorrent implementation"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

#CONCURRENCY_MAKE_LEVEL=1

PKG_CONFIGURE_OPTS_TARGET="--enable-python-binding \
                           --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
                           --without-libiconv"

post_unpack() {
  mkdir -p $ROOT/$PKG_BUILD/build-aux/
  touch $ROOT/$PKG_BUILD/build-aux/config.rpath
}

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3|"`
  cp -PR ../* .
}
