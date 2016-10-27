PKG_NAME="torrent2http"
PKG_VERSION="9ce9952"
PKG_URL="https://github.com/anteo/torrent2http/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain go:host libtorrent-rasterbar boost openssl swig:host"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

CFLAGS="-fdata-sections -ffunction-sections -Os"
LDFLAGS="-s -Wl,--gc-sections -Wl,-z,relro,-z,now"

configure_target() {
export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-w -extldflags -static -X github.com/docker/containerd.GitCommit=${PKG_VERSION} -extld $TARGET_CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD.gopath:$ROOT/$PKG_BUILD/vendor/
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}
 
make_target() {
  mkdir -p bin
  go get -u -v -t "github.com/anteo/torrent2http"
  $GOLANG build -ldflags "-w -extldflags" .
}

makeinstall_target() {
  :
}