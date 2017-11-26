PKG_NAME="speedtest-go"
PKG_VERSION="90af466"
PKG_URL="https://github.com/showwin/speedtest-go/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_SECTION="system"


pre_make_target() {
  export GOOS=linux
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-w -linkmode external -extld $CC -s"
  export GOLANG=$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$PKG_BUILD.gopath:$PKG_BUILD/
  export GOROOT=$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}

make_target() {
  mkdir -p bin
  $GOLANG get -v github.com/showwin/speedtest-go
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
