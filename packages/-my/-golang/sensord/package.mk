PKG_NAME="sensord"
PKG_VERSION="c84a2cd"
PKG_GIT_URL="https://github.com/wolfeidau/sensord"
PKG_GIT_BRANCH="master"
PKG_KEEP_CHECKOUT="yes"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_SECTION="tools"
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
}
 
make_target() {
  mkdir -p bin
  go get -u -v -t "github.com/wolfeidau/sensord"
  $GOLANG build -v -o bin/sensord -a -tags "$DOCKER_BUILDTAGS" -ldflags "$LDFLAGS"
}

makeinstall_target() {
  :
}