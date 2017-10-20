PKG_NAME="fio"
PKG_VERSION="7ad86b6"
PKG_URL="https://github.com/axboe/fio/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_SECTION="tools"
PKG_AUTORECONF="no"

configure_target() {
  cd $PKG_BUILD
  ./configure --prefix=/ --enable-lex --esx --cpu=$TARGET_CPU --cc=$CC --build-static
}