PKG_NAME="torrent2http"
PKG_VERSION="9ce9952"
PKG_GIT_URL="https://github.com/beermix/torrent2http"
PKG_DEPENDS_TARGET="toolchain go:host libtorrent-rasterbar boost openssl swig:host"
PKG_SECTION="tools"
PKG_AUTORECONF="no"


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
  $GOLANG get -v "github.com/anteo/libtorrent-go" "github.com/saintfish/chardet" "golang.org/x/net/html/charset" "golang.org/x/text/transform"
  $GOLANG build -v -o bin/torrent2http -a -ldflags "$LDFLAGS" .
}

makeinstall_target() {
  :
}