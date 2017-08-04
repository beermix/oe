PKG_NAME="runc"
PKG_VERSION="2d41c04"
PKG_GIT_URL="https://github.com/docker/runc"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  export GOOS=linux
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -extldflags -static -X main.gitCommit=${PKG_VERSION} -X main.version=$(cat ./VERSION) -extld $CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD.gopath:$ROOT/$PKG_BUILD/Godeps/_workspace/
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin

  ln -fs $ROOT/$PKG_BUILD $ROOT/$PKG_BUILD/Godeps/_workspace/src/github.com/opencontainers/runc
}

make_target() {
  mkdir -p bin
  $GOLANG build -v -o bin/runc -a -tags "cgo static_build" -ldflags "$LDFLAGS" ./
}

makeinstall_target() {
  :
}
