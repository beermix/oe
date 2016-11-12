PKG_NAME="libedit"
PKG_VERSION="20160903-3.1"
PKG_SITE="http://www.gnu.org/readline"
PKG_URL="http://thrysoee.dk/editline/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -D__STDC_ISO_10646__"
  #export MAKEFLAGS=-j1
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --with-gnu-ld \
			   --enable-widec"