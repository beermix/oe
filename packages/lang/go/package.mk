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

PKG_NAME="go"
PKG_VERSION="0993369"
PKG_SITE="https://github.com/golang/go/tree/release-branch.go1.9"
PKG_GIT_URL="https://github.com/golang/go"
PKG_GIT_BRANCH="release-branch.go1.9"
PKG_DEPENDS_HOST="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="Go is an open source programming language that makes it easy to build simple, reliable, and efficient software."
PKG_LONGDESC="Go is an open source programming language that makes it easy to build simple, reliable, and efficient software."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

####################################################################
# On Fedora `dnf install golang` will install go to /usr/lib/golang
#
# On Ubuntu you need to install golang manually, similar to:
# $ wget https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz
# $ tar xf go1.7.1.linux-amd64.tar.gz -C /opt/
# $ ln -s /opt/go /usr/lib/golang
####################################################################

configure_host() {
  export GOOS=linux
  export GOROOT_FINAL=$ROOT/$TOOLCHAIN/lib/golang
  #export GOROOT_BOOTSTRAP=/usr/lib/golang
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CC_FOR_TARGET="$CC"
  export CXX_FOR_TARGET="$CXX"
}

make_host() {
  cd $ROOT/$PKG_BUILD/src
  ./make.bash --no-clear
}

makeinstall_host() {
  mkdir -p $ROOT/$TOOLCHAIN/lib/golang
  cp -av $ROOT/$PKG_BUILD/* $ROOT/$TOOLCHAIN/lib/golang/
}
