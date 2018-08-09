PKG_NAME="pkgconf"
PKG_VERSION="1.5.3"
PKG_URL="https://github.com/pkgconf/pkgconf/archive/pkgconf-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host autoconf:host automake:host"
PKG_SOURCE_DIR="pkgconf-pkgconf-$PKG_VERSION*"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --disable-rpath --with-gnu-ld"

post_makeinstall_host() {
  ln -sfv pkgconf $TOOLCHAIN/bin/pkg-config
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -Wall"
}