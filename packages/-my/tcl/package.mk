PKG_NAME="tcl"
PKG_VERSION="19d4625"
PKG_GIT_URL="https://github.com/tcltk/tcl"
PKG_DEPENDS_HOST="ccache:host gettext:host"

PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

strip_lto

PKG_CONFIGURE_SCRIPT="unix/configure"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-threads --enable-64bit"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_HOST"

post_makeinstall_target() {
  rm -rf $INSTALL
}