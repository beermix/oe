PKG_NAME="ncdc"
PKG_VERSION="1.20"
PKG_URL="https://dev.yorhel.nl/download/ncdc-$PKG_VERSION.tar.gz"
#PKG_VERSION="e4f211d"
#PKG_GIT_URL="git://g.blicky.net/ncdu.git"
PKG_DEPENDS_TARGET="toolchain ncurses sqlite"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LIBS="-lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --enable-largefile"