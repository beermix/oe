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

PKG_NAME="runc"
PKG_VERSION="9c2d8d184e5da67c95d601382adf14862e4f2228"
PKG_ARCH="any"
PKG_LICENSE="APL"
PKG_SITE="https://github.com/opencontainers/runc"
PKG_URL="https://github.com/opencontainers/runc/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain go:host"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  tar xf $ROOT/$SOURCES/$PKG_NAME/$PKG_VERSION.tar.gz -C $ROOT/$BUILD
}

pre_make_target() {
  export GOOS=linux
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CGO_NO_EMULATION=1
  export CGO_CFLAGS=$CFLAGS
  export LDFLAGS="-s -w -extldflags -static -X main.gitCommit=${PKG_VERSION} -X main.version=$(cat ./VERSION) -extld $CC"
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
