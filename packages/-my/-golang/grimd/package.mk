PKG_NAME="grimd"
PKG_VERSION="cde3f59"
PKG_GIT_URL="https://github.com/looterz/grimd"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_KEEP_CHECKOUT="no"
PKG_SECTION="tools"
PKG_TOOLCHAIN="manual"

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
  $GOLANG get -u -v github.com/looterz/grimd
  $GOLANG build -v -o bin/$PKG_NAME -a -ldflags $LDFLAGS ./
  $STRIP bin/$PKG_NAME
}

makeinstall_target() {
  :
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $PKG_BUILD/bin/$PKG_NAME $INSTALL/usr/bin/
}