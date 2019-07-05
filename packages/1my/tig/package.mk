PKG_NAME="tig"
PKG_VERSION="faf1b86"
PKG_URL="https://github.com/jonas/tig/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  MAKEFLAGS=-j1
}

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config \
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
