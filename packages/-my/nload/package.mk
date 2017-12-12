PKG_NAME="nload"
PKG_VERSION="0.7.4"
PKG_URL="http://www.roland-riegel.de/nload/nload-0.7.4.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline"

PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"


pre_configure_target() {
  export LIBS="-lterminfo"
  export MAKEFLAGS=-j1
}
