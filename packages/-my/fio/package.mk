PKG_NAME="fio"
PKG_VERSION="3.2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET=""
PKG_SECTION="tools"


configure_target() {
  cd $PKG_BUILD
  ./configure --prefix=/usr --enable-lex --esx --cpu=$TARGET_CPU --cc=$CC --build-static
}