PKG_NAME="go-peerflix"
PKG_VERSION="abb60b4"
PKG_GIT_URL="https://github.com/Sioro-Neoku/go-peerflix"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_GIT_BRANCH="master"
PKG_KEEP_CHECKOUT="no"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

strip_lto

pre_make_target() {
  export GOARCH=amd64
  export HOST_GO_CGO_ENABLED=1
  export CC="$CC"
  export CXX="$CXX"
  export GOOS=linux
  export CGO_ENABLED=0
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extldflags -Wl,--unresolved-symbols=ignore-in-shared-libs -extld $CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD.gopath:$ROOT/$PKG_BUILD/vendor/
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}
 
make_target() {
  mkdir -p bin
  go get -v "github.com/Sioro-Neoku/go-peerflix"
  $GOLANG build -v -o bin/$PKG_NAME -a -ldflags "$LDFLAGS" ./
  $STRIP bin/$PKG_NAME
}

makeinstall_target() {
  :
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/bin/$PKG_NAME $INSTALL/usr/bin/
}

CFLAGS="-march=corei7-avx -mtune=corei7-avx -O3 -pipe"
LDFLAGS="-Wl,-O1 -Wl,--as-needed"
