PKG_NAME="runc"
#PKG_VERSION="v1.0.0-rc2"
PKG_VERSION="02f8fa7"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="APL"
PKG_SITE="https://github.com/opencontainers/runc"
PKG_GIT_URL="https://github.com/opencontainers/runc"
PKG_DEPENDS_HOST="toolchain go"
PKG_SECTION="system"
PKG_SHORTDESC="runc is a CLI tool for spawning and running containers according to the OCI specification"
PKG_LONGDESC="runc is a CLI tool for spawning and running containers according to the OCI specification"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  export GOOS=linux
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -extldflags -static -X main.gitCommit=${PKG_VERSION} -extld $CC"
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
