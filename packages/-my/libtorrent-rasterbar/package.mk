PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.1.4"
PKG_SITE="https://github.com/arvidn/libtorrent/tree/RC_1_1"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_4/libtorrent-rasterbar-1.1.4.tar.gz"
PKG_DEPENDS_TARGET="toolchain boost openssl"
PKG_LONGDESC="An efficient feature complete C++ bittorrent implementation"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

#post_unpack() {
#  mkdir -p $ROOT/$PKG_BUILD/build-aux/
#  touch $ROOT/$PKG_BUILD/build-aux/config.rpath
#}

#pre_configure_target() {
  #cd $ROOT/$PKG_BUILD
#  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
#  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3|"`
#  ./autotool.sh
  #export LDFLAGS="$LDFLAGS -lpthread -ldl  -lutil -lm"
 # sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' configure
#  cp -PR ../* .
#}

PKG_CONFIGURE_OPTS_TARGET="--enable-python-binding \
                           --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
                           --with-boost-python=$SYSROOT_PREFIX/usr/lib \
                           --without-libiconv \
                           --disable-deprecated-functions \
                           --disable-shared \
                           --with-pic \
                           --with-gnu-ld \
                           --disable-debug \
                           --disable-invariant-checks \
                           --disable-disk-stats \
                           --disable-examples \
                           --disable-tests"



