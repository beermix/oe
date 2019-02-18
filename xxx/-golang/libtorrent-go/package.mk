PKG_NAME="libtorrent-go"
PKG_VERSION="b06aef9"
PKG_GIT_URL="https://github.com/beermix/libtorrent-go.git"
PKG_DEPENDS_TARGET="toolchain go:host boost"
PKG_SECTION="system"


configure_target() {
  export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extld $CC"
  export GOLANG=$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$PKG_BUILD/.gopath:$PKG_BUILD/vendor
  export GOROOT=$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
  PKG_CONFIG_PATH=$SYSROOT_PREFIX/bin
}
 
make_target() {
  mkdir -p bin
  go get -u -t -v "github.com/anteo/libtorrent-go"
  $GOLANG build -v -o bin/speedtest -a -tags "$DOCKER_BUILDTAGS" -ldflags "$LDFLAGS"
}

makeinstall_target() {
  :
}