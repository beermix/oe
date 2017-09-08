PKG_NAME="libevent"
PKG_VERSION="release-2.1.8-stable"
PKG_LICENSE="BSD"
PKG_SITE="http://libevent.org/"
PKG_GIT_URL="https://github.com/nmathewson/libevent"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_SHORTDESC="libevent: a library for asynchronous event notification"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-libevent-regress --disable-samples --disable-shared --enable-openssl --with-gnu-ld"

post_makeinstall_target() {
  rm -fr $INSTALL
}
