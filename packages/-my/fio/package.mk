PKG_NAME="fio"
PKG_VERSION="fio-2.16"
PKG_GIT_URL="https://github.com/axboe/fio"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

configure_target() {
  cd $ROOT/$PKG_BUILD
  ./configure --enable-lex \
  		--enable-pmemblk \
  		--prefix=/usr \
  		--esx \
  		--cc=$CC
}