PKG_NAME="peg"
PKG_VERSION="0.1.18"
PKG_URL="http://piumarta.com/software/peg/peg-0.1.18.tar.gz"
PKG_DEPENDS_HOST="bison:host flex:host"
PKG_TOOLCHAIN="manual"

make_host() {
  make
}

makeinstall_host() {
  cp peg $TOOLCHAIN/bin/peg
  cp leg $TOOLCHAIN/bin/leg
}