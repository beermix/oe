PKG_NAME="valgrind"
PKG_VERSION="3.11.0"
PKG_URL="http://valgrind.org/downloads/valgrind-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain boost gdb which libxslt"

PKG_SECTION="debug/tools"
PKG_SHORTDESC="htop: Htop is an ncurses based interactive process viewer for Linux."
PKG_LONGDESC="Htop is an ncurses based interactive process viewer for Linux."
PKG_TOOLCHAIN="autotools"


pre_configure_target() {
  strip_lto
  cd $PKG_BUILD
  ./autogen.sh
  ./configure --prefix=/usr
  make
}


pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

