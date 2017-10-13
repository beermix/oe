PKG_NAME="sysstat"
PKG_VERSION="11.6.0"
PKG_URL="http://pagesperso-orange.fr/sebastien.godard/sysstat-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-linux ncurses lm_sensors"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="--disable-documentation --disable-nls --sharedstatedir=/storage/.config"
		

