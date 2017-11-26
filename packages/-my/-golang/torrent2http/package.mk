PKG_NAME="torrent2http"
PKG_VERSION="a55fd4e"
PKG_GIT_URL="https://github.com/afedchin/torrent2http"
PKG_DEPENDS_TARGET="toolchain go:host openssl swig:host boost libtorrent-rasterbar"
PKG_SECTION="tools"


strip_lto

configure_target() {
  export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extld $CC"
  export GOLANG=$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$PKG_BUILD.gopath:$PKG_BUILD/
  export GOROOT=$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}
 
make_target() {
  mkdir -p bin
  $GOLANG get -v github.com/afedchin/torrent2http
  $GOLANG build -v -o bin/torrent2http -a -ldflags "$LDFLAGS" .
}

makeinstall_target() {
  :
}