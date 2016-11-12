PKG_NAME="tig"
PKG_VERSION="e59bec5"
PKG_GIT_URL="https://github.com/jonas/tig"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="--without-ncursesw --disable-option-checking"
