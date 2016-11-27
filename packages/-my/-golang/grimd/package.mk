PKG_NAME="grimd"
PKG_VERSION="f167ff0"
PKG_GIT_URL="https://github.com/looterz/grimd"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_GIT_BRANCH="master"
PKG_KEEP_CHECKOUT="no"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

strip_lto

pre_make_target() {
  export GOARCH=amd64
  export GOOS=windows
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -extldflags -static -extld $CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD.gopath:$ROOT/$PKG_BUILD/vendor/
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}
 
make_target() {
  mkdir -p bin
  go get -u -v github.com/BurntSushi/toml github.com/miekg/dns github.com/gin-gonic/gin
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