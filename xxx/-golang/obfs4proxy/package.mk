
PKG_NAME="obfs4proxy"
PKG_VERSION="0.0.3"
PKG_DEPENDS_TARGET="toolchain go"

PKG_SECTION="web"
PKG_SHORTDESC="Obfs4proxy is a pluggable transport proxy written in Go."
PKG_LONGDESC=""




get_go_arch() {
  case $1 in
  i386*|i486*|i586*|i686*)
    echo "386";;
  x86_64*)
    echo "amd64";;
  arm*)
    echo "arm";;
  *)
    echo "unknown";;
  esac
}

make_target() {
  BIN_GO=$SYSROOT_PREFIX/usr/share/gopath/bin/go
  [ -d $PKG_BUILD/obfs4proxy ] || git clone https://git.torproject.org/pluggable-transports/obfs4.git $PKG_BUILD
  cd $PKG_BUILD/obfs4proxy
  export GOHOSTARCH=$(get_go_arch $HOST_NAME)
  export GOARCH=$(get_go_arch $TARGET_NAME)
  export GOPATH=$SYSROOT_PREFIX/usr/share/gopath
  echo "GOPATH=$GOPATH"
#  $BIN_GO get -v ./...
  $BIN_GO get golang.org/x/net/proxy
  $BIN_GO get github.com/menghan/docker/vendor/src/code.google.com/p/go.net/proxy
  $BIN_GO get git.torproject.org/pluggable-transports/obfs4.git/transports
  $BIN_GO build -i -p 1 -v .
  $STRIP obfs4proxy
  cd -
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp -f $PKG_BUILD/obfs4proxy/obfs4proxy $INSTALL/usr/bin
}

