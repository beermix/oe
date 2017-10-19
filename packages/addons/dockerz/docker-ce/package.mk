PKG_NAME="docker-ce"
PKG_VERSION="17.06"
PKG_GIT_URL="https://github.com/docker/docker-ce"
PKG_DEPENDS_TARGET="toolchain sqlite go:host containerd runc libnetwork tini curl"
PKG_SECTION="service/system"
PKG_AUTORECONF="no"
PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Docker"
PKG_ADDON_TYPE="xbmc.service"

configure_target() {

  find $PKG_BUILD -name "*.go" -print | xargs sed -i 's/\/etc\/docker/\/storage\/.config\/docker/g'
  
  export DOCKER_BUILDTAGS="daemon \
                           autogen \
                           exclude_graphdriver_devicemapper \
                           exclude_graphdriver_aufs \
                           exclude_graphdriver_btrfs \
                           journald"

  export GOOS=linux
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -linkmode external -extldflags -Wl,--unresolved-symbols=ignore-in-shared-libs -extld $CC"
  export GOLANG=$TOOLCHAIN/lib/golang/bin/go
  export GOPATH=$PKG_BUILD/.gopath
  export GOROOT=$TOOLCHAIN/lib/golang
  export PATH=$PATH:$GOROOT/bin

  mkdir -p $PKG_BUILD/.gopath
  if [ -d $PKG_BUILD/vendor ]; then
    mv $PKG_BUILD/vendor $PKG_BUILD/.gopath/src
  fi
  ln -fs $PKG_BUILD $PKG_BUILD/.gopath/src/github.com/docker/docker

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
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $PKG_BUILD/bin/docker $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $PKG_BUILD/bin/dockerd $ADDON_BUILD/$PKG_ADDON_ID/bin

    # containerd
    cp -P $(get_pkg_build containerd)/bin/containerd $ADDON_BUILD/$PKG_ADDON_ID/bin/docker-containerd
    cp -P $(get_pkg_build containerd)/bin/containerd-shim $ADDON_BUILD/$PKG_ADDON_ID/bin/docker-containerd-shim

    # libnetwork
    cp -P $(get_pkg_build libnetwork)/bin/docker-proxy $ADDON_BUILD/$PKG_ADDON_ID/bin/docker-proxy

    # runc
    cp -P $(get_pkg_build runc)/bin/runc $ADDON_BUILD/$PKG_ADDON_ID/bin/docker-runc

    # tini
    cp -P $(get_pkg_build tini)/.$TARGET_NAME/tini-static $ADDON_BUILD/$PKG_ADDON_ID/bin/docker-init
}
