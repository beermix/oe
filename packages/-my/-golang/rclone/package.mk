PKG_NAME="rclone"
PKG_VERSION="6d59887"
PKG_GIT_URL="https://github.com/ncw/rclone"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_SECTION="system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  export GOOS=linux
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extld $CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD.gopath:$ROOT/$PKG_BUILD/
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin
}

make_target() {
  mkdir -p bin
  $GOLANG get -v github.com/ncw/rclone
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
