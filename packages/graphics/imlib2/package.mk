PKG_NAME="imlib2"
PKG_VERSION="93479fc"
PKG_GIT_URL="https://github.com/kkoudev/imlib2"
PKG_DEPENDS_TARGET="toolchain libXext giflib jpeg xz libpng"
PKG_SECTION="graphics"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"


post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}