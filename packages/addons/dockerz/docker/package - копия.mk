################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2009-2016 Lukas Rusak (lrusak@libreelec.tv)
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="docker"
PKG_VERSION="v1.13.0"
PKG_GIT_URL="https://github.com/docker/docker.git"
PKG_DEPENDS_TARGET="toolchain sqlite go:host containerd runc aufs-util"
PKG_SECTION="service/system"
PKG_SHORTDESC="Docker is an open-source engine that automates the deployment of any application as a lightweight, portable, self-sufficient container that will run virtually anywhere."
PKG_LONGDESC="Docker containers can encapsulate any payload, and will run consistently on and between virtually any server. The same container that a developer builds and tests on a laptop will run at scale, in production*, on VMs, bare-metal servers, OpenStack clusters, public instances, or combinations of the above."
PKG_AUTORECONF="no"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Docker"
PKG_ADDON_TYPE="xbmc.service"

configure_target() {
  export DOCKER_BUILDTAGS="daemon \
                           autogen \
                           exclude_graphdriver_devicemapper \
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
