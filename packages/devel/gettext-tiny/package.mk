PKG_NAME="gettext-tiny"
PKG_VERSION="0.0.5"
PKG_URL="http://dl.2f30.org/mirrors/sabotage/tarballs/gettext-tiny-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


make_host() {
  make CC=$HOST_CC CFLAGS="$CFLAGS -fPIC -DPIC" all
}

makeinstall_host() {
  make install PREFIX=$ROOT/$TOOLCHAIN
}