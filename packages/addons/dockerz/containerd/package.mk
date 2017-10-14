PKG_NAME="containerd"
PKG_VERSION="9048e5e"
PKG_SITE="https://containerd.tools/"
PKG_GIT_URL="https://github.com/docker/containerd"
PKG_DEPENDS_HOST="toolchain go"
PKG_SECTION="system"
PKG_SHORTDESC="containerd is a daemon to control runC"
PKG_LONGDESC="containerd is a daemon to control runC, built for performance and density. containerd leverages runC's advanced features such as seccomp and user namespace support as well as checkpoint and restore for cloning and live migration of containers."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  export GOOS=linux
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -extldflags -static -X github.com/docker/containerd.GitCommit=${PKG_VERSION} -extld $CC"
  export GOLANG=$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$PKG_BUILD.gopath:$PKG_BUILD/vendor/
  export GOROOT=$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin

  ln -fs $PKG_BUILD $PKG_BUILD/vendor/src/github.com/docker/containerd
}

make_target() {
  mkdir -p bin
  $GOLANG build -v -o bin/containerd      -a -tags "static_build" -ldflags "$LDFLAGS" ./containerd
  $GOLANG build -v -o bin/containerd-shim -a -tags "static_build" -ldflags "$LDFLAGS" ./containerd-shim
}

makeinstall_target() {
  :
}

