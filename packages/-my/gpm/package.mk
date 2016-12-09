PKG_NAME="gpm"
PKG_VERSION="1.20.4"
PKG_URL="https://dl.dropboxusercontent.com/s/062u8cjob7s8adc/gpm-1.20.4.tar.xz"
PKG_DEPENDS_TARGET="toolchain" 

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
}
#PKG_CONFIGURE_OPTS_TARGET="--with-curses"