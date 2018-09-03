PKG_NAME="go"
PKG_VERSION="1.11"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="https://github.com/golang/go/releases"
PKG_URL="https://github.com/golang/go/archive/${PKG_NAME}${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}-${PKG_NAME}${PKG_VERSION}"
PKG_DEPENDS_HOST="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="Go is an open source programming language that makes it easy to build simple, reliable, and efficient software."
PKG_LONGDESC="Go is an open source programming language that makes it easy to build simple, reliable, and efficient software."
PKG_TOOLCHAIN="manual"

####################################################################
# On Fedora `dnf install golang` will install go to /usr/lib/golang
#
# On Ubuntu you need to install golang:
# $ sudo apt install golang-go
####################################################################

configure_host() {
  export GOOS=linux
  export GOROOT_FINAL=$TOOLCHAIN/lib/golang
#  if [ -x /usr/lib/go/bin/go ]; then
#    export GOROOT_BOOTSTRAP=/usr/lib/go
#  else
#    export GOROOT_BOOTSTRAP=/usr/lib/golang
#  fi
  export GOARCH=amd64
}

make_host() {
  cd $PKG_BUILD/src
  ./make.bash --no-clean -v
}

pre_makeinstall_host() {
  # need to cleanup old golang version when updating to a new version
  rm -rf $TOOLCHAIN/lib/golang
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/lib/golang
  cp -av $PKG_BUILD/* $TOOLCHAIN/lib/golang/
}
