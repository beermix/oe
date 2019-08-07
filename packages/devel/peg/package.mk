PKG_NAME="peg"
PKG_VERSION="0.1.18"
PKG_URL="https://sources.voidlinux.org/peg-0.1.18/peg-0.1.18.tar.gz"
PKG_DEPENDS_HOST="bison:host flex:host"

make_host() {
  make
}

makeinstall_host() {
  cp peg $TOOLCHAIN/bin/peg
  cp leg $TOOLCHAIN/bin/leg
}