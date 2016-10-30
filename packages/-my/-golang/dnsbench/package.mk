PKG_NAME="dnsbench"
PKG_VERSION="f2c5ef0"
PKG_GIT_URL="https://github.com/LunaNode/dnsbench"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_make_target() {
  export GOARCH=amd64
  export GOOS=linux
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -extldflags -static -X github.com/LunaNode/dnsbench.GitCommit=${PKG_VERSION} -extld $CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD.gopath:$ROOT/$PKG_BUILD/vendor/
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}
 
make_target() {
  mkdir -p bin
  go get -u -v "github.com/miekg/dns"
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