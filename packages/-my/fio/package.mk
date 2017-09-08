PKG_NAME="fio"
PKG_VERSION="3.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

configure_target() {
  cd $ROOT/$PKG_BUILD
  ./configure --prefix=/usr --enable-lex --esx --cpu=$TARGET_CPU --cc=$CC
}

#--build-static