PKG_NAME="libnetwork"
PKG_VERSION="0f53435"
PKG_SITE="https://github.com/docker/libnetwork"
PKG_GIT_URL="https://github.com/docker/libnetwork"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_SECTION="system"
PKG_SHORTDESC="Libnetwork provides a native Go implementation for connecting containers"
PKG_LONGDESC="Libnetwork provides a native Go implementation for connecting containers"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  export GOOS=linux
  export CGO_ENABLED=0
  export GOARCH=amd64
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -extld $CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD.gopath
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}

make_target() {
  mkdir -p bin
  $GOLANG build -v -o bin/docker-proxy -a -ldflags "$LDFLAGS" ./cmd/proxy
}

makeinstall_target() {
  :
}