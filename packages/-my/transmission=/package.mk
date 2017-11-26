PKG_NAME="transmission"
PKG_VERSION="2.92"
PKG_SITE="https://github.com/transmission/transmission-releases"
#PKG_URL="https://github.com/transmission/transmission-releases/raw/master/transmission-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl curl miniupnpc libevent"
PKG_USE_CMAKE="yes"


unpack() {
  git clone --recursive -v --depth 1 https://github.com/transmission/transmission $PKG_BUILD
}

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

PGK_CMAKE_OPTS_TARGET="-DENABLE_CLI=1 -DENABLE_LIGHTWEIGHT=0 -DINSTALL_DOC=0 -DENABLE_TESTS=0 -DCMAKE_BUILD_TYPE=Release"