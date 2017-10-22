PKG_NAME="fio"
PKG_VERSION="fio-3.1"
PKG_URL="https://github.com/axboe/fio/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_SECTION="tools"
PKG_AUTORECONF="no"

configure_target() {
  cd $PKG_BUILD
  ./configure --prefix=/usr --enable-lex --esx --cpu=$TARGET_CPU --cc=$CC
}