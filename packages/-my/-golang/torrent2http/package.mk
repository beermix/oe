PKG_NAME="torrent2http"
PKG_VERSION="a55fd4e"
PKG_GIT_URL="https://github.com/afedchin/torrent2http"
PKG_DEPENDS_TARGET="toolchain go:host openssl swig:host boost libtorrent-rasterbar"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

strip_lto

configure_target() {
  export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extld $CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD.gopath:$ROOT/$PKG_BUILD/
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}
 
make_target() {
  mkdir -p bin
  $GOLANG get -v "github.com/afedchin/torrent2http" "github.com/saintfish/chardet" "golang.org/x/net/html/charset" "golang.org/x/text/transform"
  $GOLANG build -v -o bin/torrent2http -a -ldflags "$LDFLAGS" .
}

makeinstall_target() {
  :
}