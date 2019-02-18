PKG_NAME="syncthing"
PKG_VERSION="master"
PKG_GIT_URL="https://github.com/syncthing/syncthing.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_SECTION="tools"


configure_target() {
  export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extld $CC"
  export GOLANG=$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$PKG_BUILD/.gopath:$PKG_BUILD/vendor
  export GOROOT=$TOOLCHAIN/lib/golang
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