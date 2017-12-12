PKG_NAME="libpthread"
PKG_VERSION="2"
PKG_URL="https://dl.dropboxusercontent.com/s/psdgktqf7hzehlv/libpthread-2.tar.xz"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="network"

PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"