PKG_NAME="syncthing"
PKG_VERSION="668eb7c"
PKG_GIT_URL="https://github.com/syncthing/syncthing.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
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
}
 
make_target() {
  mkdir -p bin
  go get -u -v -t "github.com/syncthing/syncthing"
  go get -u -v -t "github.com/syncthing/syncthing/lib"
  ./build.sh
  $GOLANG build -v -o bin/syncthing -a -tags "$DOCKER_BUILDTAGS" -ldflags "$LDFLAGS"
}

makeinstall_target() {
  :
}