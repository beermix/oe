PKG_NAME="sniffit"
PKG_VERSION="306c544"
PKG_URL="https://github.com/hishamhm/htop/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses libpcap"

PKG_SECTION="debug/tools"
PKG_SHORTDESC="htop: Htop is an ncurses based interactive process viewer for Linux."
PKG_LONGDESC="Htop is an ncurses based interactive process viewer for Linux."



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

