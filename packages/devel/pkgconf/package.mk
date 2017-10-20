PKG_NAME="pkgconf"
PKG_VERSION="1.3.10"
PKG_URL="https://github.com/pkgconf/pkgconf/archive/pkgconf-1.3.10.tar.gz"
PKG_DEPENDS_HOST="ccache:host gettext:host autoconf:host automake:host"
PKG_SOURCE_DIR="pkgconf-pkgconf-$PKG_VERSION*"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --disable-rpath --with-gnu-ld"

post_makeinstall_host() {
  ln -sfv pkgconf $TOOLCHAIN/bin/pkg-config
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -Wall"
}