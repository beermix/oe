PKG_NAME="libevent"
PKG_VERSION="2.1.8-stable"
PKG_SITE="http://libevent.org/"
PKG_URL="https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_SHORTDESC="libevent: a library for asynchronous event notification"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-libevent-regress --disable-samples --disable-shared --enable-openssl --with-pic"

post_makeinstall_target() {
  rm -fr $INSTALL
}
