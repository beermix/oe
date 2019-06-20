PKG_NAME="libnl-tiny"
#PKG_VERSION="1.0.1"
#PKG_SHA256="c6334414256ec7b08defc13b54c4ab11c4415d55ae90fd2720a625d8db888e5b"
PKG_VERSION="4225e93"
PKG_SITE="https://github.com/sabotage-linux/libnl-tiny"
PKG_URL="http://ftp.barfooze.de/pub/sabotage/tarballs/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/sabotage-linux/libnl-tiny/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

pre_make_target() {
  LIBNLTINY_MAKE_OPTS="CC=$CC AR=$AR RANLIB=$RANLIB prefix=/usr SHAREDLIB="
  PKG_MAKE_OPTS_TARGET="$LIBNLTINY_MAKE_OPTS"
  PKG_MAKEINSTALL_OPTS_TARGET="$LIBNLTINY_MAKE_OPTS"
}