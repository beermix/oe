PKG_NAME="fio"
PKG_VERSION="fio-2.18"
PKG_GIT_URL="https://github.com/axboe/fio"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

configure_target() {
  cd $ROOT/$PKG_BUILD
  ./configure --prefix=/usr --enable-lex --esx --cc=$CC
}

#--build-static