PKG_NAME="tig"
PKG_VERSION="f7e0a25"
PKG_URL="https://github.com/jonas/tig/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
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
