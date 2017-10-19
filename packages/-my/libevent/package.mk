PKG_NAME="libevent"
PKG_VERSION="2.0.22-stable"
PKG_SITE="https://github.com/libevent/libevent/releases/"
PKG_URL="https://github.com/libevent/libevent/releases/download/release-$PKG_VERSION/libevent-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_SHORTDESC="libevent: a library for asynchronous event notification"

PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-libevent-regress --disable-samples --disable-shared --enable-openssl --with-pic"

post_makeinstall_target() {
  rm -fr $INSTALL
}
