PKG_NAME="torrent2http"
PKG_VERSION="9ce9952"
PKG_GIT_URL="https://github.com/beermix/torrent2http"
PKG_DEPENDS_TARGET="toolchain go:host libtorrent-rasterbar boost openssl swig:host"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

strip_lto

configure_target() {
export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD.gopath:$ROOT/$PKG_BUILD/vendor/
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}
 
make_target() {
  mkdir -p bin
  go get -u -v -t "github.com/beermix/torrent2http"
  $GOLANG build -ldflags "-w -extldflags" .
}

makeinstall_target() {
  :
}