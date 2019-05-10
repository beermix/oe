PKG_NAME="go1.4"
PKG_VERSION="bdd4b95"
PKG_SHA256="452bebf72e540b4e59c7e40aca751c1dc7bbac39da8d4cea6f5871351072befd"
PKG_URL="https://github.com/golang/go/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_TOOLCHAIN="manual"

####################################################################
# On Fedora `dnf install golang` will install go to /usr/lib/golang
#
# On Ubuntu you need to install golang manually, similar to:
# $ wget https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
# $ tar xf go1.6.linux-amd64.tar.gz -C /opt/
# $ ln -s /opt/go /usr/lib/golang
####################################################################

configure_host() {
  export GOOS=linux
  export GOROOT_FINAL=$TOOLCHAIN/lib/golang-1.4
  export GOARCH=amd64
  export CGO_ENABLED=0
  export PKG_CONFIG="$TOOLCHAIN/bin/pkg-config"
  export CC_FOR_TARGET="$CC"
  export CXX_FOR_TARGET="$CXX"
}

make_host() {
  cd $PKG_BUILD/src
  bash make.bash --no-banner
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/lib/golang-1.4
  cp -av $PKG_BUILD/* $TOOLCHAIN/lib/golang-1.4/
}