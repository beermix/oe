PKG_NAME="sysstat"
PKG_VERSION="11.7.3"
PKG_URL="http://pagesperso-orange.fr/sebastien.godard/sysstat-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-linux ncurses lm_sensors"
PKG_SECTION="devel"

pre_configure_target() {
  cd $PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="--disable-documentation --disable-nls --sharedstatedir=/storage/.config"
