PKG_NAME="rhash"
PKG_VERSION="1.3.6"
PKG_SITE="https://github.com/rhash/RHash/releases"
PKG_URL="https://github.com/rhash/RHash/archive/v$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="RHash-$PKG_VERSION"
PKG_DEPENDS_HOST=""
PKG_SECTION="devel"
PKG_TOOLCHAIN="manual"

pre_configure_host() {
  cd $PKG_BUILD

  export CFLAGS="$CFLAGS -DUSE_GETTEXT -Wall -fPIC"
  export PREFIX="$TOOLCHAIN"
}

make_host() {
  make
  make -C librhash install-headers install-lib-static
}