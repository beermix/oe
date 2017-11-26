PKG_NAME="ipd"
PKG_VERSION="faf2f62"
PKG_GIT_URL="https://github.com/martinp/ipd"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_SECTION="tools"


pre_make_target() {
  export GOARCH=amd64
  export GOOS=linux
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
  go get -u -v "github.com/martinp/ipd"
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

CFLAGS="-march=corei7-avx -mtune=corei7-avx -O3 -pipe"
LDFLAGS="-Wl,-O1 -Wl,--as-needed"