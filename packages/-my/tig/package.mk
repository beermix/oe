PKG_NAME="tig"
PKG_VERSION="cef17fc"
PKG_GIT_URL="https://github.com/jonas/tig"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
   export LIBS="-lreadline"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-option-checking \
			      --sysconfdir=/storage/.config \
			      --datadir=/storage/.config \
			      --libdir=/storage/.config \
			      --libexecdir=/storage/.config \
			      --sharedstatedir=/storage/.config \
			      --localstatedir=/storage/.config \
			      --includedir=/storage/.config \
			      --oldincludedir=/storage/.config \
			      --datarootdir=/storage/.config \
			      --infodir=/storage/.config \     
			      --localedir=/storage/.config"
