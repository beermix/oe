PKG_NAME="docker"
PKG_VERSION="v1.12.4"
PKG_SITE="http://www.docker.com/"
PKG_GIT_URL="https://github.com/docker/docker"
PKG_DEPENDS_TARGET="toolchain sqlite go:host containerd runc"
PKG_SECTION="service/system"
PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Docker"
PKG_ADDON_TYPE="xbmc.service"

configure_target() {
  export DOCKER_BUILDTAGS="daemon \
                           autogen \
                           exclude_graphdriver_devicemapper \
                           exclude_graphdriver_aufs \
                           exclude_graphdriver_btrfs"

  export GOOS=linux
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extldflags -Wl,--unresolved-symbols=ignore-in-shared-libs -extld $CC"
  export GOLANG=$ROOT/$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$ROOT/$PKG_BUILD/.gopath:$ROOT/$PKG_BUILD/vendor
  export GOROOT=$ROOT/$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin

  ln -fs $ROOT/$PKG_BUILD $ROOT/$PKG_BUILD/vendor/src/github.com/docker/docker

  # used for docker version
  export GITCOMMIT=$PKG_VERSION
  export VERSION=$PKG_VERSION
  export BUILDTIME="$(date --utc)"
  bash ./hack/make/.go-autogen
}

make_target() {
  mkdir -p bin
  $GOLANG build -v -o bin/docker -a -tags "$DOCKER_BUILDTAGS" -ldflags "$LDFLAGS" ./cmd/docker
  $GOLANG build -v -o bin/dockerd -a -tags "$DOCKER_BUILDTAGS" -ldflags "$LDFLAGS" ./cmd/dockerd
  $GOLANG build -v -o bin/docker-proxy -a -ldflags "$LDFLAGS" ./vendor/src/github.com/docker/libnetwork/cmd/proxy
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $ROOT/$PKG_BUILD/bin/docker $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $ROOT/$PKG_BUILD/bin/dockerd $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $ROOT/$PKG_BUILD/bin/docker-proxy $ADDON_BUILD/$PKG_ADDON_ID/bin

    # containerd
    cp -P $(get_build_dir containerd)/bin/containerd $ADDON_BUILD/$PKG_ADDON_ID/bin/docker-containerd
    cp -P $(get_build_dir containerd)/bin/containerd-shim $ADDON_BUILD/$PKG_ADDON_ID/bin/docker-containerd-shim

    # runc
    cp -P $(get_build_dir runc)/bin/runc $ADDON_BUILD/$PKG_ADDON_ID/bin/docker-runc
}
