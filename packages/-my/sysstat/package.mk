PKG_NAME="sysstat"
PKG_VERSION="11.3.3"
PKG_URL="http://pagesperso-orange.fr/sebastien.godard/sysstat-11.3.3.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-linux netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"



PKG_CONFIGURE_OPTS_TARGET="--disable-documentation \
		--disable-documentation \
		--sysconfdir="/storage/.config/sysstat" \
		--disable-option-checking"
		

