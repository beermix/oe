PKG_NAME="sysstat"
PKG_VERSION="12.1.5"
PKG_SHA256="a496936bb3f5093d780a50735f00e39b0b7f3a688eb89051f2ef5f86739522c5"
PKG_URL="http://pagesperso-orange.fr/sebastien.godard/sysstat-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-linux ncurses lm_sensors"

#pre_configure_target() {
#  cd $PKG_BUILD
#}

PKG_CONFIGURE_OPTS_TARGET="--disable-documentation \
			      --enable-yesterday \
			      --enable-install-isag \
			      --enable-install-cron \
			      --enable-copy-only \
			      --disable-man-group"

#PKG_CONFIGURE_OPTS_TARGET="--disable-documentation --disable-nls --sharedstatedir=/storage/.config"

