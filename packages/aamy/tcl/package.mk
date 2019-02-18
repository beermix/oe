PKG_NAME="tcl"
PKG_VERSION="core_8_6_7"
PKG_GIT_URL="https://github.com/tcltk/tcl"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="toolchain/devel"



strip_lto

PKG_CONFIGURE_SCRIPT="unix/configure"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-threads --enable-64bit"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_HOST"

post_makeinstall_target() {
  rm -rf $INSTALL
}