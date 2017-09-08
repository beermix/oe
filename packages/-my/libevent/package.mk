PKG_NAME="libevent"
PKG_VERSION="2.1.8-stable"
PKG_LICENSE="BSD"
PKG_SITE="http://libevent.org/"
PKG_URL="https://github.com/libevent/libevent/releases/download/release-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_SHORTDESC="libevent: a library for asynchronous event notification"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

#pre_configure_target() {
#  CFLAGS="$CFLAGS -fPIC"
#  CXXFLAGS="$CXXFLAGS -fPIC"
#  LDFLAGS="$LDFLAGS -fPIC"
#}

PKG_CONFIGURE_OPTS_TARGET="--disable-libevent-regress --disable-samples --disable-shared --enable-static --enable-openssl --with-pic"

post_makeinstall_target() {
  rm -fr $INSTALL
}
