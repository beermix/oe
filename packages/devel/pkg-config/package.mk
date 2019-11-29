PKG_NAME="pkg-config"
PKG_VERSION="1.6.3"
PKG_SHA256="61f0b31b0d5ea0e862b454a80c170f57bad47879c0c42bd8de89200ff62ea210"
PKG_SITE="https://github.com/pkgconf/pkgconf/releases"
PKG_URL="https://distfiles.dereferenced.org/pkgconf/pkgconf-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host gettext:host"

PKG_CONFIGURE_OPTS_HOST="--with-gnu-ld"

post_makeinstall_host() {
  mv $(STAGING_DIR_HOST)/bin/pkgconf $TOOLCHAIN/bin/pkg-config.real
  install -m755 $PKG_DIR/files/pkg-config $TOOLCHAIN/bin/pkg-config

  ln -sf pkgconf $TOOLCHAIN/bin/pkg-config
#  ln -sf pkgconf $TOOLCHAIN/bin/x86_64-pc-linux-gnu-pkg-config
}