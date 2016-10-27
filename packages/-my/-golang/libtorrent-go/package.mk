PKG_NAME="libtorrent-go"
PKG_VERSION="9ea7cd2"
PKG_GIT_URL="https://github.com/anteo/libtorrent-go.git"
PKG_DEPENDS_TARGET="toolchain go:host boost"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_AUTORECONF="no"

configure_target() {
  export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-w -linkmode external -extldflags -Wl,--unresolved-symbols=ignore-in-shared-libs -extld $TARGET_CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD/.gopath:$ROOT/$PKG_BUILD/vendor
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
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