PKG_NAME="xz-utils"
PKG_VERSION="5.1.1alpha_20120614"
PKG_URL="https://dl.dropboxusercontent.com/s/f1wx95fg2fa1hc2/xz-utils-5.1.1alpha_20120614.tar.xz"
PKG_DEPENDS_HOST="ccache:host gettext:host"
PKG_SECTION="toolchain/archivers"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static --with-gnu-ld"