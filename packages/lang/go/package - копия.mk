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
PKG_VERSION="go1.7.5"
#PKG_VERSION="4707045"
PKG_GIT_URL="https://github.com/golang/go"
PKG_DEPENDS_HOST="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="Go is an open source programming language that makes it easy to build simple, reliable, and efficient software."
PKG_LONGDESC="Go is an open source programming language that makes it easy to build simple, reliable, and efficient software."




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
  export GOROOT_FINAL=$TOOLCHAIN/lib/golang
  #export GOROOT_BOOTSTRAP=$TOOLCHAIN/lib/golang-1.4
  export GOARCH=amd64
  export CGO_ENABLED=1
  export CC="$CC"
  export CC_FOR_TARGET="$CC"
  export CXX_FOR_TARGET="$CXX"
}

make_host() {
  cd $PKG_BUILD/src
  ./make.bash --no-banner
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/lib/golang
  cp -av $PKG_BUILD/* $TOOLCHAIN/lib/golang/
}