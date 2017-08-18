PKG_NAME="libtorrent-go"
#PKG_VERSION="a55fd4e"
#PKG_GIT_URL="https://github.com/afedchin/torrent2http"
PKG_VERSION="b06aef9"
PKG_GIT_URL="https://github.com/beermix/libtorrent-go.git"
PKG_DEPENDS_TARGET="toolchain go:host boost"
PKG_SECTION="system"
PKG_AUTORECONF="no"

configure_target() {
  export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extld $CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD/.gopath:$ROOT/$PKG_BUILD/vendor
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
  PKG_CONFIG_PATH=$SYSROOT_PREFIX/bin
}
 
make_target() {
  mkdir -p bin
  go get -u -t -v "github.com/beermix/torrent2http"
  go build -v -u -buildmode=exe -o bin/torrent2http -a -ldflags "-s -w"
}

makeinstall_target() {
  :
}