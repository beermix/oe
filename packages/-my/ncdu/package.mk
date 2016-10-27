PKG_NAME="ncdu"
PKG_VERSION="1.12"
PKG_URL="https://dev.yorhel.nl/download/ncdu-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --enable-largefile"