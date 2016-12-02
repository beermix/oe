PKG_NAME="indent"
PKG_VERSION="2.2.11"
PKG_URL="https://dl.dropboxusercontent.com/s/deyl7mx7k79f7po/indent_2.2.11.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"