PKG_NAME="pkgconf"
PKG_VERSION="1.6.1"
PKG_SHA256="22b9ee38438901f9d60f180e5182821180854fa738fd071f593ea26a81da208c"
PKG_URL="https://distfiles.dereferenced.org/pkgconf/pkgconf-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host autotools:host gettext-tiny:host"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --with-pic"

post_makeinstall_host() {
  ln -sf pkgconf $TOOLCHAIN/bin/pkg-config
  ln -sf pkgconf $TOOLCHAIN/bin/x86_64-pc-linux-gnu-pkg-config
}