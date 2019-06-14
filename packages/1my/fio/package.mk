PKG_NAME="fio"
PKG_VERSION="3.13"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libaio"
PKG_TOOLCHAIN="manual"

configure_target() {
  cd $PKG_BUILD
  LIBS="-laio -lrt" ./configure --prefix=/usr
}

make_target() {
 LDFLAGS=-s make
}

configure_host() {
  cd $PKG_BUILD
  LIBS="-laio -lrt" ./configure --build-static
}

make_host() {
 LDFLAGS=-s make
}