PKG_NAME="speedtest-go"
PKG_VERSION="7d194d0"
PKG_GIT_URL="https://github.com/zpeters/speedtest"
PKG_GIT_BRANCH="develop"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_SECTION="tools"


pre_make_target() {
  export GOOS=linux
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extld $CC"
  export GOLANG=$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$PKG_BUILD.gopath:$PKG_BUILD/vendor/
  export GOROOT=$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}

make_target() {
  mkdir -p bin
  go get -u -v -t github.com/zpeters/speedtest
  $GOLANG build -v -o bin/$PKG_NAME -a -ldflags "$LDFLAGS" ./
  $STRIP bin/$PKG_NAME
}

makeinstall_target() {
  :
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $PKG_BUILD/bin/$PKG_NAME $INSTALL/usr/bin/
}
