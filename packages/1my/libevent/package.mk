PKG_NAME="libevent"
PKG_VERSION="2.1.10-stable"
PKG_SHA256="52c9db0bc5b148f146192aa517db0762b2a5b3060ccc63b2c470982ec72b9a79"
PKG_SITE="http://libevent.org/"
PKG_URL="https://github.com/libevent/$PKG_NAME/archive/release-$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="$PKG_NAME-release-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_SHORTDESC="libevent: a library for asynchronous event notification"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-libevent-regress \
                           --disable-samples \
                           --disable-shared \
                           --enable-static \
                           --enable-openssl"

post_makeinstall_target() {
  rm -fr "$INSTALL"
}
