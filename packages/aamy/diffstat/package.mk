PKG_NAME="diffstat"
PKG_VERSION="1.61"
PKG_URL="ftp://invisible-island.net/diffstat/diffstat-1.61.tgz"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="security"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --enable-static --disable-shared"
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"