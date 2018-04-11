PKG_NAME="lnav"
PKG_VERSION="8091591"
PKG_URL="https://github.com/tstack/lnav/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite pcre ncurses readline"
PKG_DEPENDS_HOST="sqlite:host pcre:host ncurses:host readline:host"
PKG_SECTION="tools"
PKG_TOOLCHAIN="configure"
#PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
  sh autogen.sh
}

pre_configure_host() {
  cd $PKG_BUILD
  sh autogen.sh
}

PKG_CONFIGURE_OPTS_HOST="--disable-silent-rules --disable-shared --enable-static"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"