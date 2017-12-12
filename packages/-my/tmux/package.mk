PKG_NAME="tmux"
PKG_VERSION="2.6"
#PKG_GIT_URL="https://github.com/tmux/tmux"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libevent ncurses"
PKG_SECTION="security"
PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared"
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
