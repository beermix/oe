PKG_NAME="pkgconf"
PKG_VERSION="1.3.8"
PKG_URL="https://distfiles.dereferenced.org/pkgconf/pkgconf-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host gettext:host"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--disable-shared"
PKG_CONFIGURE_OPTS_TARGET="--disable-shared"

post_makeinstall_host() {
  ln -sfv pkgconf $ROOT/$TOOLCHAIN/bin/pkg-config
}
