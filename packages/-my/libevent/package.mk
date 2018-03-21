PKG_NAME="libevent"
PKG_VERSION="90ae4c5"
PKG_SITE="https://github.com/libevent/libevent/releases/"
#PKG_URL="https://github.com/libevent/libevent/releases/download/release-$PKG_VERSION/libevent-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/libevent/libevent/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_DEPENDS_HOST="openssl:host zlib:host"
PKG_SHORTDESC="libevent: a library for asynchronous event notification"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-libevent-regress --disable-shared --enable-openssl --with-pic"
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"

post_makeinstall_target() {
  rm -fr $INSTALL
}
