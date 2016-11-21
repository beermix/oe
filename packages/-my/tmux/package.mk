PKG_NAME="tmux"
PKG_VERSION="2.3"
PKG_GIT_URL="https://github.com/tmux/tmux"
PKG_DEPENDS_TARGET="toolchain libevent netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
  export MAKEFLAGS=-j1
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"
			  
			  
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"