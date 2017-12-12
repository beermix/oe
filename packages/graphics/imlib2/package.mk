PKG_NAME="imlib2"
PKG_VERSION="93479fc"
PKG_GIT_URL="https://github.com/kkoudev/imlib2"
PKG_DEPENDS_TARGET="toolchain giflib jpeg libpng libid3tag libICE libSM libX11 libXext libXt"
PKG_SECTION="graphics"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"


post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}