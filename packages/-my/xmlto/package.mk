PKG_NAME="xmlto"
PKG_VERSION="0.0.25"
PKG_URL="http://jarek.katowice.pl/jcwww/forum_files/xmlto-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-sysroot=$SYSROOT_PREFIX"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"