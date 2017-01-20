PKG_NAME="gpm"
PKG_VERSION="1.20.7"
PKG_URL="http://www.nico.schottelius.org/software/gpm/archives/gpm-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain" 
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   sh autogen.sh
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_path_emacs=no \
			      itz_cv_sys_elf=yes \
			      --without-curses \
			      --enable-static \
			      --disable-shared"