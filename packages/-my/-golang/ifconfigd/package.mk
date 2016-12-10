PKG_NAME="ifconfigd"
PKG_VERSION="master"
PKG_URL="https://dl.dropboxusercontent.com/s/pbxk3oculo9hfat/ifconfigd-master.tar"
PKG_KEEP_CHECKOUT="yes"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

configure_target() {
  export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD/.gopath:$ROOT/$PKG_BUILD/vendor
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}
 
make_target() {
  mkdir -p bin
  go get -u -v -t "github.com/zpeters/ifconfigd"
  $GOLANG build -v -o bin/ifconfigd -a -tags "$DOCKER_BUILDTAGS" -ldflags "$LDFLAGS"
}

makeinstall_target() {
  :
}